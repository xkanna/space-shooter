local Model = require("Model")
local EnemySpawner = classes.class()
local GameController = require("GameController")
local Enemy = require("Enemies.Enemy")
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
    self.radius = self.w / 2
    self.waveConfig = levels[GameController.instance:getCurrentLevel()].waves
    self.currentWave = 1
    self.isPaused = false
    
    self.enemyQueue = {}
    self:initEnemyQueue(30)
    
    gameController.instance:addListener(function(newState)
        if newState == "start" then
            self:resetSpawner()
        end
    end)
end

function EnemySpawner:initEnemyQueue(size)
    for i = 1, size do
        local enemy = Enemy:new(0, 0, self.asset, self.radius, self:getRandomEnemyType())
        table.insert(self.enemyQueue, enemy)
    end
end


function EnemySpawner:update(dt)
    if gameController.instance:getGameState() ~= "playing" then
        return
    end
    
    if self.isPaused then
      self:updatePauseTimer(dt) -- When all enemies are spawned we have some time left before we can win the level
    else
      self:spawnWave(dt)
    end
    
    self:updateEnemies(dt)
end

function EnemySpawner:updatePauseTimer(dt)
    timer = timer + dt
    if timer >= waitTime then
      gameController.instance:winGame()
      timer = 0
    end
end

function EnemySpawner:spawnWave(dt)
    self.timeSinceLastSpawn = self.timeSinceLastSpawn + dt
    if self.timeSinceLastSpawn >= self.spawnRate then
        self:spawnEnemies(self.currentWave)
        self.timeSinceLastSpawn = 0
        self.currentWave = self.currentWave + 1
        if self.currentWave > #self.waveConfig then
            self.isPaused = true
            self.currentWave = 1
        end
    end
end

function EnemySpawner:updateEnemies(dt)
    for i=#enemies, 1, -1 do
      local enemy = enemies[i]
      enemy:update(dt)
      enemy.y = enemy.y + enemy.speed * dt
      if enemy.y > self.stageHeight or enemy:IsDead() then
        table.insert(self.enemyQueue, enemy)
        table.remove(enemies, i)
      end
    end
end

function EnemySpawner:resetSpawner()
    self:removeAllEnemies()
    self.currentWave = 1
    local level = gameController.instance:getCurrentLevel()
    if(level > #levels) then
        level = 1
    end
    self.waveConfig = levels[level].waves
    self.isPaused = false
end

function EnemySpawner:spawnEnemies(waveIndex)
    local lines = self.waveConfig[waveIndex].lines
    local count = #lines
    for i=1, count do
        local position = lines[i].position
        local x = self:getSpawnX(position)
        local y = -self.h
        local enemyType = self:getRandomEnemyType()
        local enemy = table.remove(self.enemyQueue, 1)
        enemy:reset(x, y, self.asset, self.radius, enemyType)
        table.insert(enemies, enemy)
    end
end

function EnemySpawner:getSpawnX(position) -- random x from the position place
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

function EnemySpawner:getRandomEnemyType() -- enemies have random types based on their health and points
    local enemyTypes = Model.enemyTypes
    local randomIndex = math.random(1, #enemyTypes)
    return enemyTypes[randomIndex]
end

function EnemySpawner:removeAllEnemies()
    for i=#enemies, 1, -1 do
        table.insert(self.enemyQueue, enemies[i])
        table.remove(enemies, i)
    end
end

function EnemySpawner:draw()
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end
end

return EnemySpawner