local Model = require("Model")
local EnemySpawner = classes.class()

function EnemySpawner:init(params)
    print("Enemies init!")
    self.asset = params.asset
    self.spawnRate = params.spawnRate
    self.timeSinceLastSpawn = 0 
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    local maxNumEnemies = params.maxNumEnemies
    local stageWidth = Model.stage.stageWidth
    local stageHeight = Model.stage.stageHeight
    self.maxNumEnemies = maxNumEnemies
    
end


function EnemySpawner:update(dt)
    local maxNumEnemies = self.maxNumEnemies
    local stageWidth = Model.stage.stageWidth
    local stageHeight = Model.stage.stageHeight
    
    for i=#enemies, 1, -1 do
        local enemy = enemies[i]
        enemy.y = enemy.y + enemy.speed * dt
        if enemy.y > stageHeight then
            table.remove(enemies, i)
        end
    end

    self.timeSinceLastSpawn = self.timeSinceLastSpawn + dt
    if self.timeSinceLastSpawn >= self.spawnRate then
        self:spawnEnemies()
        self.timeSinceLastSpawn = 0
    end
end

function EnemySpawner:spawnEnemies()
    local stageWidth = Model.stage.stageWidth
    local numEnemiesToSpawn = math.random(0, self.maxNumEnemies)

    for i=1, numEnemiesToSpawn do
        local x = math.random() * (stageWidth - self.w)
        local y = - self.h
        local enemyType = self:getRandomEnemyType()
        local enemy = {x = x, y = y, asset = self.asset, speed = enemyType.speed, radius = self.w / 2, attackDamage = enemyType.attackDamage}
        table.insert(enemies, enemy)
    end
end

function EnemySpawner:getRandomEnemyType()
    local enemyTypes = Model.enemyTypes
    local randomIndex = math.random(1, #enemyTypes)
    return enemyTypes[randomIndex]
end

function EnemySpawner:draw()
  
    for _, enemy in ipairs(enemies) do
        love.graphics.draw(enemy.asset, enemy.x, enemy.y)
    end
end

return EnemySpawner