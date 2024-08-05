local classes = require("classes")
local Model = require("Model")
local GameController = require("GameController")
local AssetsManager = require("AssetsManager")
local Bullet = require("Bullet")
local Collectable = require("Collectable")

local CollisionManager = classes.class()

local explosions = {} 
local collectables = {}

function CollisionManager:checkCollisions(bullets, enemies, ship, dt)
    local bulletsToRemove = {}
    local enemiesToRemove = {}
    
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            
            if self:checkBulletEnemyCollision(bullet, enemy) then
                local isEnemyDead = enemy:takeDamage()
                if isEnemyDead then 
                    table.insert(enemiesToRemove, j)
                    createExplosion(enemy.x, enemy.y)
                    GameController.instance:addPoints(enemy.points)
                    spawnCollectable(enemy.x, enemy.y)
                end
                table.insert(bulletsToRemove, i)
                break
            end
        end
    end
    
    for _, i in ipairs(bulletsToRemove) do
        table.remove(bullets, i)
    end
    
    for _, j in ipairs(enemiesToRemove) do
        table.remove(enemies, j)
    end
    
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        
        if self:checkShipEnemyCollision(ship, enemy) then
            ship:takeDamage()
            GameController.instance:removeLife()
            if GameController.instance:getLives() <= 0 then
                createExplosion(enemy.x, enemy.y)
            end
            table.remove(enemies, i)
            break
        end
    end
    
    self:checkCollectableShipCollision(ship)
    updateExplosions(dt)
end

function spawnCollectable(x, y)
    local asset = AssetsManager.sprites.coin
    local collectable = Collectable:init(x, y, asset)
    table.insert(collectables, collectable)
end

function CollisionManager:checkCollectableShipCollision(ship)
    for i = #collectables, 1, -1 do
        local collectable = collectables[i]
        
        local dx = ship.x - collectable.x
        local dy = ship.y - collectable.y
        local distance = math.sqrt(dx * dx + dy * dy)
        
        if distance < (ship.radius + collectable.radius) then
            GameController.instance:addGold(1)
            table.remove(collectables, i)
        end
    end
end

function CollisionManager:updateCollectables(dt)
    for _, collectable in ipairs(collectables) do
        collectable:update(dt)
    end
end

function createExplosion(x, y)
    table.insert(explosions, {
        x = x,
        y = y,
        timer = 0.5, 
        asset = AssetsManager.sprites.explosion,
    })
end

function updateExplosions(dt)
    for i = #explosions, 1, -1 do
        local explosion = explosions[i]
        explosion.timer = explosion.timer - dt 

        if explosion.timer <= 0 then
            table.remove(explosions, i)
        end
    end
end

function CollisionManager:checkBulletEnemyCollision(bullet, enemy)
    local dx = bullet.x - enemy.x
    local dy = bullet.y - enemy.y
    local distance = math.sqrt(dx * dx + dy * dy)
    
    return distance < (bullet.radius + enemy.radius)
end

function CollisionManager:checkShipEnemyCollision(ship, enemy)
    local dx = ship.x - enemy.x
    local dy = ship.y - enemy.y
    local distance = math.sqrt(dx * dx + dy * dy)
    
    return distance < (ship.radius + enemy.radius)
end

function CollisionManager:draw()
    for _, explosion in ipairs(explosions) do
        local w = explosion.asset:getWidth()
        local h = explosion.asset:getHeight()
        love.graphics.draw(explosion.asset, explosion.x - w / 2, explosion.y - h / 2)
    end
    
    for _, collectable in ipairs(collectables) do
        collectable:draw()
    end
end

return CollisionManager