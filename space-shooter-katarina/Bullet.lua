local classes = require("classes")
local Bullet = classes.class()

function Bullet:init(x, y, params)
    self.x = x
    self.y = y
    self.speed = params.speed
    self.asset = params.asset
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    self.radius = self.w / 2
end

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
    love.graphics.draw(self.asset, self.x, self.y)
end

return Bullet