local classes = require("classes")
local Ship = classes.class()
local Model = require("Model")
local Bullet = require("Bullet")

function Ship:init(params)
    print("Ship init!")
    self.speed = params.speed
    self.asset = params.asset
    self.x = Model.stage.stageWidth / 2
    self.y = Model.stage.stageHeight / 2
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    self.fireRate = params.fireRate
    self.timeSinceLastShot = 0 
end

function Ship:update(dt)
    local left = Model.movement.left
    local right = Model.movement.right
    local up = Model.movement.up
    local down = Model.movement.down
    local space = Model.movement.space
    local stageWidth = Model.stage.stageWidth
    local stageHeight = Model.stage.stageHeight

    local x = 0
    local y = 0

    if left and self.x > self.w / 2 then
        x = x - 1
    end
    if right and self.x < stageWidth - self.w / 2 then
        x = x + 1
    end
    if up and self.y > self.h / 2 then
        y = y - 1
    end
    if down and self.y < stageHeight - self.h / 2 then
        y = y + 1
    end
    
    self.x = self.x + x * self.speed * dt
    self.y = self.y + y * self.speed * dt
    
    self.timeSinceLastShot = self.timeSinceLastShot + dt
    if space and self.timeSinceLastShot >= self.fireRate then
        self:shoot()
        self.timeSinceLastShot = 0
    end
end

function Ship:shoot()
    table.insert(bullets, Bullet:new(self.x, self.y - (self.h / 2), Model.bulletParams))
end

function Ship:draw()
    local newX = self.x - (self.w / 2)
    local newY = self.y - (self.h / 2)
    love.graphics.draw(self.asset, newX, newY)
end

return Ship