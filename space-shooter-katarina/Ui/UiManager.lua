local classes = require("classes")
local UiManager = classes.class()
local Model = require("Model")
local Button = require("Ui.Button")
local Label = require("Ui.Label")
local GameController = require("GameController")

function UiManager:init()
    self.elements = {}
    self:setupUi()
end

function UiManager:setupUi()
    playButton = self:addButton{
        x = 100,
        y = 400,
        width = 200,
        height = 50,
        text = "Play"
    }
    
    playButton.onClick = function()
      GameController.instance:startGame()
      playButton.active = false
      levelLabel.active = false
    end
    
    livesLabel = self:addLabel{
        x = 10,
        y = 10,
        text = "Lives: " .. GameController.instance:getLives()
    }
    
    levelLabel = self:addLabel{
        x = Model.stage.stageWidth / 2 - 50,
        y = Model.stage.stageHeight / 2 - 50,
        text = "Level: " .. GameController.instance:getCurrentLevel(),
    }
    
    goldLabel = self:addLabel{
        x = 10,
        y = 30,
        text = "Gold: " .. GameController.instance:getGold()
    }
    
    GameController.instance:addListener(function(newState)
        if newState == "start" then
            playButton.active = true
            levelLabel.active = true
            local level = GameController.instance:getCurrentLevel()
            levelLabel:setText("Level: " .. level)
        end
    end)
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
    livesLabel:setText("Lives: " .. GameController.instance:getLives())
    goldLabel:setText("Gold: " .. GameController.instance:getGold())
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