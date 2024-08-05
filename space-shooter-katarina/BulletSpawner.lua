local Model = require("Model")
local GameController = require("GameController")
local Bullet = require("Bullet")
local BulletSpawner = classes.class()

function BulletSpawner:init()
  GameController.instance:addListener(function(newState)
        if newState == "start" then
            self:removeAllBullets()
        end
    end)
end

function BulletSpawner:update(dt)
  for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet:update(dt)
        if bullet.y < 0 then
        BulletSpawner:delete(bullet)
        end 
    end
end

function BulletSpawner:draw()
  for _, bullet in ipairs(bullets) do
        bullet:draw()
    end
end

function BulletSpawner:removeAllBullets()
  for i, activeBullet in ipairs(bullets) do
        table.remove(bullets, i)
  end
end

function BulletSpawner:shoot(x, y)
  table.insert(bullets, Bullet:new(x, y, Model.bulletParams))
end

function BulletSpawner:delete(bullet)
    for i, activeBullet in ipairs(bullets) do
        if activeBullet == bullet then
            table.remove(bullets, i)
            break
        end
    end
end

return BulletSpawner