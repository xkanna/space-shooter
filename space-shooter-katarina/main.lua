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

local AssetsManager = require("AssetsManager")
local Model = require("Model")

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
end

function love.update(dt)
   -- print("update")
    ship:update(dt)
    stars:update(dt)
    for i = #bullets, 1, -1 do
        bullets[i]:update(dt)
    end
    enemySpawner:update(dt)
end


function love.draw()
    --love.graphics.draw(AssetsManager.sprites.fireAngles, 0,0 )
    stars:draw()
    ship:draw()
    for _, bullet in ipairs(bullets) do
        bullet:draw()
    end
    enemySpawner:draw()
    
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

--
--



