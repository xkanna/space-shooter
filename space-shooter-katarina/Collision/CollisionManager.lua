local classes = require("classes")
local Model = require("Model")
local CollisionManager = classes.class()

local GameController = require("GameController")
local AssetsManager = require("AssetsManager")
local Bullet = require("Shooting.Bullet")
local Collectable = require("Collectables.Collectable")

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
                    local collectable = spawnCollectable(enemy.x, enemy.y)
                    if collectable.type == "regular" then
                        GameController.instance:addPoints(enemy.points)
                    end
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
            if GameController.instance:getLives() <= 0 then
                createExplosion(enemy.x, enemy.y)
            end
            table.remove(enemies, i)
            break
        end
    end
    
    self:checkCollectableShipCollision(ship)
    self:updateCollectables(collectables, ship,  dt)
    updateExplosions(dt)
end

function spawnCollectable(x, y)
    local asset = AssetsManager.sprites.coin
    local collectable = Collectable:init(x, y, asset)
    
    local chance = math.random()
    if chance <= 0.1 then
        local powerUpType = Model.powerUpTypes[math.random(#Model.powerUpTypes)]
        collectable.type = powerUpType.name
        collectable.asset = AssetsManager.sprites[powerUpType.assetName]
        collectable.duration = powerUpType.duration
    else
        collectable.type = "regular" 
    end
    
    table.insert(collectables, collectable)
    return collectable
end

function CollisionManager:checkCollectableShipCollision(ship)
    for i = #collectables, 1, -1 do
        local collectable = collectables[i]
        
        local dx = ship.x - collectable.x
        local dy = ship.y - collectable.y
        local distance = math.sqrt(dx * dx + dy * dy)
        
        if distance < (ship.coinRadius + collectable.radius) then
            collectable.isCollected = true
            ship:collect(collectable)
        end
    end
end


function CollisionManager:updateCollectables(collectables, ship, dt)
    local speed = 500

    for i = #collectables, 1, -1 do
        local collectable = collectables[i]
        if collectable.isCollected then
            local dx = ship.x - collectable.x
            local dy = ship.y - collectable.y
            
            local angle = math.atan2(dy, dx)
            
            collectable.x = collectable.x + math.cos(angle) * speed * dt
            collectable.y = collectable.y + math.sin(angle) * speed * dt
            
            if math.abs(dx) < 5 and math.abs(dy) < 5 then
                GameController.instance:addGold(1)
                table.remove(collectables, i)
            end
        elseif collectable.y > Model.stage.stageHeight then
             table.remove(collectables, i)
        else
            collectable:update(dt)
        end
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