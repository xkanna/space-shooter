local classes = require("classes")
local Button = require("UiClasses.Button")
local Label = require("UiClasses.Label")

local UiManager = classes.class()

function UiManager:init()
    self.elements = {}
end

function UiManager:addButton(params)
    local button = Button:new(params)
    table.insert(self.elements, button)
    return button
end

function UiManager:addLabel(params)
    local label = Label:new(params)
    table.insert(self.elements, label)
    return label
end

function UiManager:removeElement(element)
  for i, e in ipairs(self.elements) do
        if e == element then
            table.remove(self.elements, i)
            break
        end
    end
end

function UiManager:update(dt)
    for _, element in ipairs(self.elements) do
        if element.update then
            element:update(dt)
        end
    end
end

function UiManager:draw()
    for _, element in ipairs(self.elements) do
        element:draw()
    end
end

function UiManager:mousepressed(mx, my, button)
    for _, element in ipairs(self.elements) do
        if element.mousepressed then
            element:mousepressed(mx, my, button)
        end
    end
end

return UiManager