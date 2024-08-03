local classes = require("classes")
local Bullet = classes.class()

function Bullet:new(x, y, params)
    local bullet = {
        x = x,
        y = y,
        speed = params.speed,
        asset = params.asset,
        w = params.asset:getWidth(),
        h = params.asset:getHeight(),
        radius = params.asset:getWidth() / 2
    }
    setmetatable(bullet, { __index = Bullet })
    return bullet
end

function Bullet:update(dt)
    self.y = self.y - self.speed * dt
end


function Bullet:draw()
    love.graphics.draw(self.asset, self.x, self.y)
end

return Bullet