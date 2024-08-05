local classes = require("classes")
local Collectable = classes.class()

function Collectable:init(x, y, asset)
    
    local collectable = {
      x = x,
      y = y,
      asset = asset,
      radius = asset:getWidth() / 2,
      speed = 100
    }
    setmetatable(collectable, { __index = Collectable })
    return collectable
end

function Collectable:update(dt)
    self.y = self.y + self.speed * dt
end

function Collectable:draw()
    love.graphics.draw(self.asset, self.x - self.radius, self.y - self.radius)
end

return Collectable