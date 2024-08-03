local classes = require("classes")
local Model = require("Model")
local Bullet = require("Bullet")

local CollisionManager = classes.class()

function CollisionManager:checkCollisions(bullets, enemies, ship)
    if not ship.active then
        return
    end
    
    local bulletsToRemove = {}
    local enemiesToRemove = {}
    
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            
            if self:checkBulletEnemyCollision(bullet, enemy) then
                table.insert(bulletsToRemove, i)
                table.insert(enemiesToRemove, j)
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
            ship:takeDamage(enemy.attackDamage)
            table.remove(enemies, i)
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

return CollisionManager