local classes = require("classes")
local Bullet = classes.class()

function Bullet:init(x, y, params)
    self.x = x
    self.y = y
    self.speed = params.speed
    self.asset = params.asset
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
end

function Bullet:new(x, y, params)
    local bullet = {
        x = x,
        y = y,
        speed = params.speed,
        asset = params.asset,
        w = params.asset:getWidth(),
        h = params.asset:getHeight()
    }
    setmetatable(bullet, { __index = Bullet })
    return bullet
end

function Bullet:update(dt)
    self.y = self.y - self.speed * dt
    if self.y < 0 then
        self:delete()
    end
end

function Bullet:delete()
    for i, bullet in ipairs(bullets) do
        if bullet == self then
            table.remove(bullets, i)
            break
        end
    end
end

function Bullet:draw()
    local newX = self.x - (self.w / 2)
    local newY = self.y - (self.h / 2)
    love.graphics.draw(self.asset, newX, newY)
end

return Bullet