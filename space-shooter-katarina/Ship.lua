local classes = require("classes")
local Ship = classes.class()
local Model = require("Model")
local BulletSpawner = require("BulletSpawner")

function Ship:init(params)
    print("Ship init!")
    self.speed = params.speed
    self.asset = params.asset
    self.health = params.health
    self.x = Model.stage.stageWidth / 2
    self.y = Model.stage.stageHeight / 2
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    self.fireRate = params.fireRate
    self.timeSinceLastShot = 0 
    self.radius = self.w / 2
    self.isDamaged = false
    self.active = true
end

function Ship:update(dt)
    if not self.active then
        return
    end
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
    BulletSpawner:shoot(self.x, self.y - (self.h / 2))
end

function Ship:takeDamage(damage)
  self.health = self.health - damage
  self.isDamaged = true
  self.redTimer = 0.3
  if(self.health <= 0) then
    self.active = false
  end
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
    love.graphics.draw(self.asset, self.x, self.y)
    love.graphics.setColor(1, 1, 1) -- this resets color after drawing the ship
end

return Ship