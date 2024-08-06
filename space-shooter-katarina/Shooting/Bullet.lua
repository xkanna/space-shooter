local classes = require("classes")
local Bullet = classes.class()

function Bullet:new(x, y, angle, params)
    local bullet = {
        x = x,
        y = y,
        speed = params.speed,
        asset = params.asset,
        w = params.asset:getWidth(),
        h = params.asset:getHeight(),
        radius = params.asset:getWidth() / 2,
        angle = math.rad(angle)
    }
    setmetatable(bullet, { __index = Bullet })
    return bullet
end

function Bullet:reset(x, y, angle)
    self.x = x
    self.y = y
    self.angle = math.rad(angle)
end

function Bullet:update(dt)
    self.x = self.x + math.cos(self.angle) * self.speed * dt
    self.y = self.y - math.sin(self.angle) * self.speed * dt
end

function Bullet:draw()
    love.graphics.draw(self.asset, self.x - self.w / 2, self.y - self.h / 2)
end

return Bullet