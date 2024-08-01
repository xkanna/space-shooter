local classes = require("classes")
local Model = require("Model")
local Bullet = require("Bullet")

local CollisionManager = classes.class()

function CollisionManager:checkCollisions(bullets, enemies)
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]

            if self:checkBulletEnemyCollision(bullet, enemy) then
                table.remove(bullets, i)
                table.remove(enemies, j)
                break 
            end
        end
    end
end

function CollisionManager:checkBulletEnemyCollision(bullet, enemy)
    return bullet.x < enemy.x + enemy.radius and
           bullet.x + bullet.w > enemy.x - enemy.radius and
           bullet.y < enemy.y + enemy.radius and
           bullet.y + bullet.h > enemy.y - enemy.radius
end

return CollisionManager