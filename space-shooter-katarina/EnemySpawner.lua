local Model = require("Model")
local GameController = require("GameController")
local EnemySpawner = classes.class()
local Enemy = require("Enemy")
local levels = require("Levels")

local timer = 0
local waitTime = 7 

function EnemySpawner:init(params)
    print("Enemies init!")
    self.asset = params.asset
    self.spawnRate = params.spawnRate
    self.timeSinceLastSpawn = 0 
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    self.x = 0
    self.maxNumEnemies = params.maxNumEnemies
    self.stageWidth = Model.stage.stageWidth
    self.stageHeight = Model.stage.stageHeight
    self.maxNumEnemies = maxNumEnemies
    self.enemies = enemies
    self.radius = self.w / 2
    self.waveConfig = levels[GameController.instance:getCurrentLevel()].waves
    self.currentWave = 1
    self.isPaused = false
    
    GameController.instance:addListener(function(newState)
        if newState == "start" then
            self:removeAllEnemies()
            self.currentWave = 1
            local level = GameController.instance:getCurrentLevel()
            if(level > #levels) then
              level = 1
            end
            self.waveConfig = levels[level].waves
            self.isPaused = false
        end
    end)
end


function EnemySpawner:update(dt)
    if GameController.instance:getGameState() ~= "playing" then
        return
    end
    
    if self.isPaused then
      timer = timer + dt
      if timer >= waitTime then
        GameController.instance:winGame()
        timer = 0
      end
    else
      self.timeSinceLastSpawn = self.timeSinceLastSpawn + dt
      if self.timeSinceLastSpawn >= self.spawnRate then
          self:spawnWave(self.currentWave)
          self.timeSinceLastSpawn = 0
          self.currentWave = self.currentWave + 1
          if self.currentWave > #self.waveConfig then
              self.isPaused = true
              self.currentWave = 1
          end
      end
    end
    
    for i=#self.enemies, 1, -1 do
        local enemy = self.enemies[i]
        enemy:update(dt)
        enemy.y = enemy.y + enemy.speed * dt
        if enemy.y > self.stageHeight then
            table.remove(self.enemies, i)
        end
    end
end

function EnemySpawner:spawnWave(waveIndex)
  
    local lines = self.waveConfig[waveIndex].lines
    local count = #lines
    for i=1, count do
        local position = lines[i].position
        local x = self:getSpawnX(position)
        local y = -self.h
        local enemyType = self:getRandomEnemyType()
        table.insert(self.enemies, Enemy:new(x, y, self.asset, self.radius, enemyType))
    end
end

function EnemySpawner:getSpawnX(position)
    if position == "left" then
        return math.random(self.w, self.stageWidth / 3)
    elseif position == "right" then
        return math.random(2 * self.stageWidth / 3, self.stageWidth - self.w)
    elseif position == "center" then
        return math.random(self.stageWidth / 3, 2 * self.stageWidth / 3)
    else
        return math.random(0, self.stageWidth)
    end
end


function EnemySpawner:getRandomEnemyType()
    local enemyTypes = Model.enemyTypes
    local randomIndex = math.random(1, #enemyTypes)
    return enemyTypes[randomIndex]
end

function EnemySpawner:removeAllEnemies()
    for i=#enemies, 1, -1 do
        local enemy = enemies[i]
        table.remove(enemies, i)
    end
end

function EnemySpawner:draw()
  
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end
end

return EnemySpawner