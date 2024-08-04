local classes = require("classes")

local Label = classes.class()

function Label:new(params)
    local label = {
      x = params.x,
      y = params.y,
      text = params.text,
      active = true
    }
    setmetatable(label, { __index = Label })
    return label
end

function Label:setText(text)
    self.text = text
end

function Label:draw()
    if not self.active then
        return
    end
    local font = love.graphics.newFont(18)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.text, self.x, self.y)
end

return Label