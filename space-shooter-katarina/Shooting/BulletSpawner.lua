local Model = require("Model")
local BulletSpawner = classes.class()

local GameController = require("GameController")
local Bullet = require("Shooting.Bullet")

function BulletSpawner:init()
    print("BulletSpawner init!")
    
    if BulletSpawner.instance then
        return BulletSpawner.instance
    end
    
    self.bulletQueue = {}
    self:initBulletQueue(60)
    
    gameController.instance:addListener(function(newState)
        if newState == "start" then
            self:removeAllBullets()
        end
    end)
  
    BulletSpawner.instance = self
    return self
end

function BulletSpawner:initBulletQueue(size)
    for i = 1, size do
        local bullet = Bullet:new(0, 0, 90, Model.bulletParams)
        table.insert(self.bulletQueue, bullet)
    end
end

function BulletSpawner:update(dt)
  for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet:update(dt)
        if bullet.y < 0 then
        self:delete(bullet)
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
        table.insert(self.bulletQueue, bullet)
        table.remove(bullets, i)
  end
end

function BulletSpawner:shoot(x, y, angle)
    if #self.bulletQueue == 0 then
        return
    end
    local bullet = table.remove(self.bulletQueue, 1)
    bullet:reset(x, y, angle)
    table.insert(bullets, bullet)
end

function BulletSpawner:delete(bullet)
    for i, activeBullet in ipairs(bullets) do
        if activeBullet == bullet then
            table.insert(self.bulletQueue, activeBullet)
            table.remove(bullets, i)
            break
        end
    end
end

return BulletSpawner