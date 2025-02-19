local AssetsManager = require("AssetsManager")
local Model = {
    movement = {
        up = false,
        down = false,
        left = false,
        right = false,
        space = false
    }
}

Model.gameParams = {
    lives = 3,
    winningScore = 50
}

Model.shipParams = {
    assetName = "ship",
    speed = 500,
    fireRate = 0.2,
    attackDamage = 10,
    health = 100
}

Model.starsParams = {
    radius = 1,
    speed = 60,
    numStars = 200
}

Model.bulletParams = {
    assetName = "bullet",
    speed = 500
}

Model.enemiesParams = {
    assetName = "enemy",
    maxNumEnemies = 2,
    spawnRate = 1
}

 Model.enemyTypes = {
    {speed = 120, points = 3, health = 3},
    {speed = 120, points = 4, health = 4},
    {speed = 120, points = 2, health = 2}
}

Model.powerUpTypes = {
    {assetName = "fireAngles", name = "triple_shot", duration = 6},
    {assetName = "fireRate", name = "fire_rate_boost", duration = 5},
    {assetName = "shield", name = "shield", duration = 5},
    {assetName = "magnet", name = "magnet", duration = 4}
}
    

Model.init = function()
    Model.stage = {
        stageHeight = love.graphics.getHeight(),
        stageWidth = love.graphics.getWidth()
    }
    
    
    --init assets dynamically
    Model.shipParams.asset = AssetsManager.sprites[Model.shipParams.assetName]
    Model.bulletParams.asset = AssetsManager.sprites[Model.bulletParams.assetName]
    Model.enemiesParams.asset = AssetsManager.sprites[Model.enemiesParams.assetName]
    --define enemies here

end


return Model