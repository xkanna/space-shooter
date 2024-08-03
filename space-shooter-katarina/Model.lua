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

Model.shipParams = {
    assetName = "ship",
    speed = 500,
    fireRate = 0.1,
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
    {speed = 100, attackDamage = 35},
    {speed = 120, attackDamage = 40},
    {speed = 80, attackDamage = 20}
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