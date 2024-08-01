local Model = require("Model")
local EnemySpawner = classes.class()

function EnemySpawner:init(params)
    print("Enemies init!")
    self.speed = params.speed
    self.radius = params.radius
    self.asset = params.asset
    self.spawnRate = params.spawnRate
    self.timeSinceLastSpawn = 0 
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    local maxNumEnemies = params.maxNumEnemies
    local stageWidth = Model.stage.stageWidth
    local stageHeight = Model.stage.stageHeight
    
    self.maxNumEnemies = maxNumEnemies
    self.enemiesArr = {}
    
end


function EnemySpawner:update(dt)
    local maxNumEnemies = self.maxNumEnemies
    local enemiesArr = self.enemiesArr
    local stageWidth = Model.stage.stageWidth
    local stageHeight = Model.stage.stageHeight
    
    for i=#enemiesArr, 1, -1 do
        local enemy = enemiesArr[i]
        enemy.y = enemy.y + self.speed * dt
        if enemy.y > stageHeight then
            table.remove(enemiesArr, i)
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
        local enemy = {x = x, y = y, asset = self.asset}
        table.insert(self.enemiesArr, enemy)
    end
end

function EnemySpawner:draw()
    local enemiesArr = self.enemiesArr
    
    for _, enemy in ipairs(enemiesArr) do
        love.graphics.draw(enemy.asset, enemy.x, enemy.y)
    end
end

return EnemySpawner