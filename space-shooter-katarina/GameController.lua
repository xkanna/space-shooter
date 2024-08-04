local classes = require("classes")
local Model = require("Model")
local GameController = classes.class()

function GameController:init(params)
    if GameController.instance then
        return GameController.instance
    end

    self.gameState = "start"
    self.playerScore = 0
    self.winningScore = params.winningScore
    self.lives = params.lives
    self.currentLives = params.lives
    self.listeners = {}
    
    GameController.instance = self
    return self
end

function GameController:update(dt)
    if self.gameState == "playing" then
        if self.playerScore >= self.winningScore then
            self.gameState = "won"
            self:notifyListeners("won")
            self:resetGame()
        elseif self.currentLives <= 0 then
            self.gameState = "lost"
            self:notifyListeners("lost")
            self:resetGame()
        end
    end
end

function GameController:draw()
    if self.gameState == "playing" then
        love.graphics.print("Score: " .. math.floor(self.playerScore), 10, 30)
    elseif self.gameState == "won" then
        love.graphics.print("You won! Final Score: " .. math.floor(self.playerScore), Model.stage.stageWidth / 2 - 100, Model.stage.stageHeight / 2 -100)
    elseif self.gameState == "lost" then
        love.graphics.print("You lost! Final Score: " .. math.floor(self.playerScore), Model.stage.stageWidth / 2 - 100, Model.stage.stageHeight / 2- 100)
    end
end

function GameController:resetGame()
    self:notifyListeners("start")
end

function GameController:startGame()
    self.gameState = "playing"
    self.playerScore = 0
    self.currentLives = self.lives
    self:notifyListeners("playing")
end

function GameController:removeLife()
    self.currentLives = self.currentLives - 1
end

function GameController:getLives()
    return self.currentLives
end

function GameController:getGameState()
    return self.gameState
end

function GameController:addPoints(points)
    self.playerScore = self.playerScore + points
end

function GameController:notifyListeners(newState)
    for _, listener in ipairs(self.listeners) do
        listener(newState)
    end
end

function GameController:addListener(listener)
    table.insert(self.listeners, listener)
end

return GameController