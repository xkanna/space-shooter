local classes = require("classes")

local Button = classes.class()

function Button:new(params)
    local button = {
      x = params.x,
      y = params.y,
      width = params.width,
      height = params.height,
      text = params.text,
      onClick = params.onClick,
      isHovered = false
    }
    setmetatable(button, { __index = Button })
    return button
end

function Button:isMouseOver(mx, my)
    return mx >= self.x and mx <= self.x + self.width and my >= self.y and my <= self.y + self.height
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    self.isHovered = self:isMouseOver(mx, my)
end

function Button:draw()
    if self.isHovered then
        love.graphics.setColor(0.8, 0.8, 0.8)
    else
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height,5,5)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(self.text, self.x, self.y + self.height / 2 - 10, self.width, "center")
end

function Button:mousepressed(mx, my, button)
    if button == 1 and self:isMouseOver(mx, my) and self.onClick then
        self.onClick()
    end
end

return Button