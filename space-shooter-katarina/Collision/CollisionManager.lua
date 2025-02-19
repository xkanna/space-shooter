local classes = require("classes")
local Model = require("Model")
local CollisionManager = classes.class()

local GameController = require("GameController")
local AssetsManager = require("AssetsManager")
local BulletSpawner = require("Shooting.BulletSpawner")
local Bullet = require("Shooting.Bullet")
local Collectable = require("Collectables.Collectable")

local explosions = {}
local collectables = {}

function CollisionManager:init()
    self.quadrants = {
        bullets = {{}, {}, {}, {}},
        enemies = {{}, {}, {}, {}},
        collectables = {{}, {}, {}, {}}
    }
end

function CollisionManager:checkCollisions(bullets, enemies, ship, dt)
    self:sortObjectsIntoQuadrants(bullets, enemies, collectables)

    for i = 1, 4 do
        self:checkQuadrantCollisions(i, ship, dt) --optimised collision detection
    end

    self:checkCollectableShipCollision(ship)
    self:updateCollectables(collectables, ship, dt) -- move them to ship
    updateExplosions(dt) -- show explosions
end

function CollisionManager:sortObjectsIntoQuadrants(bullets, enemies, collectables)
    self.quadrants.bullets = {{}, {}, {}, {}}
    self.quadrants.enemies = {{}, {}, {}, {}}
    self.quadrants.collectables = {{}, {}, {}, {}}

    for _, bullet in ipairs(bullets) do
        local quadrant = self:getQuadrant(bullet.x, bullet.y)
        table.insert(self.quadrants.bullets[quadrant], bullet)
    end

    for _, enemy in ipairs(enemies) do
        local quadrant = self:getQuadrant(enemy.x, enemy.y)
        table.insert(self.quadrants.enemies[quadrant], enemy)
    end

    for _, collectable in ipairs(collectables) do
        local quadrant = self:getQuadrant(collectable.x, collectable.y)
        table.insert(self.quadrants.collectables[quadrant], collectable)
    end
end

function CollisionManager:getQuadrant(x, y)
    local stageWidth, stageHeight = Model.stage.stageWidth, Model.stage.stageHeight
    if x < stageWidth / 2 then
        if y < stageHeight / 2 then
            return 1
        else
            return 3
        end
    else
        if y < stageHeight / 2 then
            return 2
        else
            return 4
        end
    end
end

function CollisionManager:checkQuadrantCollisions(quadrant, ship, dt)
    local bullets = self.quadrants.bullets[quadrant]
    local enemies = self.quadrants.enemies[quadrant]

    for i = #bullets, 1, -1 do
        local bullet = bullets[i]

        for j = #enemies, 1, -1 do
            local enemy = enemies[j]

            if self:checkBulletEnemyCollision(bullet, enemy) then
                self:bulletAndEnemyCollided(bullet, enemy)
                break
            end
        end
    end

    for i = #enemies, 1, -1 do
        local enemy = enemies[i]

        if self:checkShipEnemyCollision(ship, enemy) then
            self:shipAndEnemyCollided(ship, enemy)
            break
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

function CollisionManager:bulletAndEnemyCollided(bullet, enemy)
    local isEnemyDead = enemy:takeDamage()
    if isEnemyDead then
        createExplosion(enemy.x, enemy.y)
        local collectable = spawnCollectable(enemy.x, enemy.y)
        if collectable.type == "regular" then
            GameController.instance:addPoints(enemy.points)
        end
    end
    BulletSpawner.instance:delete(bullet)
end

function CollisionManager:shipAndEnemyCollided(ship, enemy)
    ship:takeDamage()
    if GameController.instance:getLives() <= 0 then
        createExplosion(enemy.x, enemy.y)
    end
    enemy.isDead = true
end

function spawnCollectable(x, y) -- when enemy is defeated spawn random collectable with 10% chance of power up
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

        if distance < (ship.collectingRadius + collectable.radius) then
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