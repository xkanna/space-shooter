--EXAMPLES
----------------------
--for debugging in zero brane
--require("mobdebug").start()

--this is to make prints appear right away in zerobrane
io.stdout:setvbuf("no")

----EXAMPLES: INSTANTIARING A CLASS

local ShipCls = require("Ship")
local ship = nil

local StarsCls = require("Stars")
local stars = nil

local EnemySpawnerCls = require("EnemySpawner")
local enemySpawner = nil

local BulletSpawnerCls = require("BulletSpawner")
local bulletSpawner = nil

local AssetsManager = require("AssetsManager")
local Model = require("Model")

local CollisionManagerCls = require("CollisionManager")
local collisionManager = nil

local UiManager = require("UiClasses.UiManager")

local LEFT_KEY = "left"
local RIGHT_KEY = "right"
local UP_KEY = "up"
local DOWN_KEY = "down"
local SPACE_KEY = "space"

bullets = {}
enemies = {}


function love.load()
    print("love.load")
    AssetsManager.init()
    Model.init()
    stars = StarsCls.new( Model.starsParams)
    ship = ShipCls.new( Model.shipParams )
    enemySpawner = EnemySpawnerCls.new( Model.enemiesParams )
    bulletSpawner = BulletSpawnerCls.new()
    collisionManager = CollisionManagerCls.new()
    uiManager = UiManager:new()
    lives = 3
    setupUi()
end

function setupUi()
  local playButton = uiManager:addButton{
        uiManager = uiManager,
        x = 100,
        y = 400,
        width = 200,
        height = 50,
        text = "Play"
    }
    
    playButton.onClick = function()
      ship.active = true
      playButton.y = -500 
      levelLabel.y = -500
    end
    
    livesLabel = uiManager:addLabel{
        x = 10,
        y = 10,
        text = "Lives: " .. lives,
    }
    
    levelLabel = uiManager:addLabel{
        x = Model.stage.stageWidth / 2 - 50,
        y = Model.stage.stageHeight / 2 - 50,
        text = "Level: " .. 1,
    }
end

function love.update(dt)
   -- print("update")
    uiManager:update(dt)
    stars:update(dt)
    collisionManager:checkCollisions(bullets, enemies, ship, dt)
    
    if not ship.active then
        return
    end
    ship:update(dt)
    bulletSpawner:update(dt)
    enemySpawner:update(dt)
end


function love.draw()
    --love.graphics.draw(AssetsManager.sprites.fireAngles, 0,0 )
    stars:draw()
    ship:draw()
    bulletSpawner:draw()
    enemySpawner:draw()
    collisionManager:draw()
    uiManager:draw()
    --love.graphics.print("You Win!", 180, 350)
end


function love.keypressed(key)
    print(key)
    if key == LEFT_KEY then
        Model.movement.left = true
    elseif key == RIGHT_KEY then
        Model.movement.right = true
    end
    
    if key == UP_KEY then
        Model.movement.up = true
    elseif key == DOWN_KEY then
        Model.movement.down = true
    end
    
    if key == SPACE_KEY then
        Model.movement.space = true
    end

end

function love.keyreleased(key)
    if key == LEFT_KEY then
        Model.movement.left = false
    elseif key == RIGHT_KEY then
        Model.movement.right = false
    end
    
    if key == UP_KEY then
        Model.movement.up = false
    elseif key == DOWN_KEY then
        Model.movement.down = false
    end
    
    if key == SPACE_KEY then
        Model.movement.space = false
    end
    
end

function love.mousepressed(x, y, button, istouch, presses)
    uiManager:mousepressed(x, y, button)
end

--
--



