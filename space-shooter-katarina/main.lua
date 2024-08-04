--EXAMPLES
----------------------
--for debugging in zero brane
--require("mobdebug").start()

--this is to make prints appear right away in zerobrane
io.stdout:setvbuf("no")

----EXAMPLES: INSTANTIARING A CLASS

local GameControllerCls = require("GameController")
local gameController = nil

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
    gameController = GameControllerCls.new( Model.gameParams )
    stars = StarsCls.new( Model.starsParams)
    ship = ShipCls.new( Model.shipParams )
    enemySpawner = EnemySpawnerCls.new( Model.enemiesParams )
    bulletSpawner = BulletSpawnerCls.new()
    collisionManager = CollisionManagerCls.new()
    uiManager = UiManager:new()
end

function love.update(dt)
   -- print("update")
    gameController:update(dt)
    uiManager:update(dt)
    stars:update(dt)
    collisionManager:checkCollisions(bullets, enemies, ship, dt)
    
    if gameController:getGameState() ~= "playing" then
        return
    end
    
    ship:update(dt)
    bulletSpawner:update(dt)
    enemySpawner:update(dt)
    
  
end


function love.draw()
    --love.graphics.draw(AssetsManager.sprites.fireAngles, 0,0 )
    gameController:draw()
    stars:draw()
    bulletSpawner:draw()
    enemySpawner:draw()
    collisionManager:draw()
    uiManager:draw()
    ship:draw()
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



