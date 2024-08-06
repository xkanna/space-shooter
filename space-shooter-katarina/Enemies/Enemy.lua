local classes = require("classes")
local Enemy = classes.class()

function Enemy:new(x, y, asset, radius, enemyType)
    local enemy = {
        x = x,
        y = y,
        w = asset:getWidth(),
        h = asset:getHeight(),
        asset = asset,
        radius = radius,
        speed = enemyType.speed,
        maxHealth = enemyType.health,
        health = enemyType.health,
        points = enemyType.points,
        isDamaged = false
    }
    setmetatable(enemy, { __index = Enemy })
    return enemy
end

function Enemy:update(dt)
  self:checkIfDamaged(dt)
end

function Enemy:takeDamage()
  self.isDamaged = true
  self.redTimer = 0.3
  self.health = self.health - 1
  local isDead = false
  if self.health <= 0 then
    isDead = true
  end
  return isDead
end

function Enemy:checkIfDamaged(dt)
  if self.isDamaged then
        self.redTimer = self.redTimer - dt
        if self.redTimer <= 0 then
            self.isDamaged = false
            self.redTimer = 0
        end
    end
end

function Enemy:draw()
  if self.isDamaged then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(1, 1, 1)
    end
    
    love.graphics.draw(self.asset, self.x - self.w / 2, self.y - self.h / 2)
    
     self:drawHealthBar()
     
    love.graphics.setColor(1, 1, 1)
end

function Enemy:drawHealthBar()
  local barWidth = self.w / 2
  local barHeight = 5
  local barX = self.x - barWidth / 2
  local barY = self.y - self.h / 2 - barHeight - 2
  
  local healthWidth = barWidth * (self.health / self.maxHealth)
  
  love.graphics.setColor(0.5, 0.5, 0.5)
  love.graphics.rectangle("fill", barX, barY, barWidth, barHeight)
  
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("fill", barX, barY, healthWidth, barHeight)
  
  love.graphics.setColor(1, 1, 1)
end

return Enemy