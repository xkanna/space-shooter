local classes = require("classes")
local GameController = require("GameController")
local AssetsManager = require("AssetsManager")
local Ship = classes.class()
local Model = require("Model")
local BulletSpawner = require("BulletSpawner")
local PowerUpManager = require("PowerUpManager")
local powerUpManager = nil

function Ship:init(params)
    print("Ship init!")
    self.speed = params.speed
    self.asset = params.asset
    self.maxHealth = params.health
    self.currentHealth = params.health
    self.x = Model.stage.stageWidth / 2
    self.y = Model.stage.stageHeight / 1.5
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    self.fireRate = params.fireRate
    self.timeSinceLastShot = 0 
    self.radius = self.w / 2
    self.coinRadius = self.w / 2
    self.isDamaged = false
    self.tripleShot = false
    self.tripleShotWide = false
    self.shieldActive = false
    self.magnetActive = false
    self.shieldSprites = {} 
    
    GameController.instance:addListener(function(newState)
        if newState == "playing" then
            self:activate()
        elseif newState == "start" then
            self:deactivate()
            powerUpManager:removeAllPowerUps()
        end
    end)
  
    powerUpManager = PowerUpManager.new()
end

function Ship:update(dt)
    local left = Model.movement.left
    local right = Model.movement.right
    local up = Model.movement.up
    local down = Model.movement.down
    local space = Model.movement.space
    local stageWidth = Model.stage.stageWidth
    local stageHeight = Model.stage.stageHeight

    local x = 0
    local y = 0

    if left and self.x > self.w / 2 then
        x = x - 1
    end
    if right and self.x < stageWidth - self.w / 2 then
        x = x + 1
    end
    if up and self.y > self.h / 2 then
        y = y - 1
    end
    if down and self.y < stageHeight - self.h / 2 then
        y = y + 1
    end
    
    self.x = self.x + x * self.speed * dt
    self.y = self.y + y * self.speed * dt
    
    self.timeSinceLastShot = self.timeSinceLastShot + dt
    if space and self.timeSinceLastShot >= self.fireRate then
        self:shoot()
        self.timeSinceLastShot = 0
    end
    self:checkIfDamaged(dt)
    
    if self.shieldActive then
        self:updateShield(dt)
    end
    
    powerUpManager:update(dt)
end

function Ship:checkIfDamaged(dt)
  if self.isDamaged then
        self.redTimer = self.redTimer - dt
        if self.redTimer <= 0 then
            self.isDamaged = false
            self.redTimer = 0
        end
    end
end

function Ship:shoot()
    if not self.active then
        return
    end
    
    if self.tripleShot then
        BulletSpawner:shoot(self.x, self.y - (self.h / 2), 90)
        BulletSpawner:shoot(self.x - 20, self.y - (self.h / 2), 90)
        BulletSpawner:shoot(self.x + 20, self.y - (self.h / 2), 90)
    elseif self.tripleShotWide then
        BulletSpawner:shoot(self.x - 20, self.y - (self.h / 2), 120)
        BulletSpawner:shoot(self.x , self.y - (self.h / 2), 90)
        BulletSpawner:shoot(self.x + 20, self.y - (self.h / 2), 60)
    else
        BulletSpawner:shoot(self.x, self.y - (self.h / 2), 90)
    end
end

function Ship:takeDamage()
  if self.shieldActive then
    return
  end
  self.isDamaged = true
  self.redTimer = 0.3
  GameController.instance:removeLife()
end

function Ship:collect(collectable)
    if collectable.type == "triple_shot" then
        powerUpManager:activatePowerUp(self, "triple_shot", collectable.duration)
    elseif collectable.type == "fire_rate_boost" then
        powerUpManager:activatePowerUp(self, "fire_rate_boost", collectable.duration)
    elseif collectable.type == "shield" then
        powerUpManager:activatePowerUp(self, "shield", collectable.duration)
    elseif collectable.type == "magnet" then
        powerUpManager:activatePowerUp(self, "magnet", collectable.duration) 
    end
end

function Ship:deactivate()
  self.active = false
end

function Ship:activate()
  self.active = true
  self.x = Model.stage.stageWidth / 2
  self.y = Model.stage.stageHeight / 1.5
  self.currentHealth = self.maxHealth
end

function Ship:draw()
    if not self.active then
        return
    end
    if self.isDamaged then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(1, 1, 1)
    end
    
    love.graphics.draw(self.asset, self.x - self.w / 2, self.y - self.h / 2)
    
    if self.shieldActive then
        self:drawShield()
    end
    
    love.graphics.setColor(1, 1, 1) -- this resets color after drawing the ship
end

function Ship:updateShield(dt)
    local shieldSpeed = 2 * math.pi 
    local numShields = 3 
    local shieldRadius = self.w 

    self.shieldSprites = {}
    for i = 1, numShields do
        local angle = (i - 1) * (2 * math.pi / numShields) + love.timer.getTime() * shieldSpeed
        local shieldX = self.x + math.cos(angle) * shieldRadius
        local shieldY = self.y + math.sin(angle) * shieldRadius
        table.insert(self.shieldSprites, {x = shieldX, y = shieldY})
    end
end

function Ship:drawShield()
    local shieldAsset = AssetsManager.sprites.shield
    for _, shield in ipairs(self.shieldSprites) do
        love.graphics.draw(shieldAsset, shield.x - shieldAsset:getWidth() / 2, shield.y - shieldAsset:getHeight() / 2)
    end
end

return Ship