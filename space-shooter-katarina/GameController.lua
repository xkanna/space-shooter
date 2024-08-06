local classes = require("classes")
local Model = require("Model")
local GameController = classes.class()

function GameController:init(params)
    if GameController.instance then
        return GameController.instance
    end

    self.gameState = "start"
    self.playerScore = 0
    self.goldCollected = 0
    self.currentLevel = 1
    self.winningScore = params.winningScore
    self.lives = params.lives
    self.currentLives = params.lives
    self.listeners = {}
    
    GameController.instance = self
    return self
end

function GameController:update(dt)
    if self.gameState == "playing" and self.currentLives <= 0 then
        self:loseGame()
    end
end

function GameController:draw()
    local scoreText = "Score: " .. math.floor(self.playerScore)
    local centerX, centerY = Model.stage.stageWidth / 2, Model.stage.stageHeight / 2

    if self.gameState == "playing" then
        love.graphics.print(scoreText, 10, 50)
    elseif self.gameState == "won" then
        love.graphics.print("You won! Final " .. scoreText, centerX - 120, centerY - 100)
    elseif self.gameState == "lost" then
        love.graphics.print("You lost! Final " .. scoreText, centerX - 120, centerY - 100)
    end
end

function GameController:winGame()
    self.gameState = "won"
    self.currentLevel = self.currentLevel + 1
    self:notifyListeners("won")
    self:resetGame()
end

function GameController:loseGame()
    self.gameState = "lost"
    self:notifyListeners("lost")
    self:resetGame()
end

function GameController:resetGame()
    self:notifyListeners("start") --on start screen
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

function GameController:getGold()
    return self.goldCollected
end

function GameController:getGameState()
    return self.gameState
end

function GameController:getCurrentLevel()
    return self.currentLevel
end

function GameController:addPoints(points)
    self.playerScore = self.playerScore + points
end

function GameController:addGold(amount)
    self.goldCollected = self.goldCollected + amount
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