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
    {speed = 120, points = 2, health = 2},
    {speed = 120, points = 3, health = 3},
    {speed = 120, points = 1, health = 1}
}

Model.powerUpTypes = {
    --{assetName = "fireAngles", name = "triple_shot"},
    --{assetName = "fireRate", name = "fire_rate_boost"},
    {assetName = "shield", name = "shield"},
    {assetName = "magnet", name = "magnet"}
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