local classes = require("classes")
local PowerUpManager = classes.class()

local powerUps = {}

function PowerUpManager:activatePowerUp(ship, powerUpType, duration)
    local powerUp = {
        type = powerUpType,
        timer = duration,
        ship = ship
    }
    table.insert(powerUps, powerUp)
    self:applyPowerUp(ship, powerUpType)
end

function PowerUpManager:applyPowerUp(ship, powerUpType)
    if powerUpType == "triple_shot" then
        ship.tripleShotWide = true
    elseif powerUpType == "fire_rate_boost" then
        ship.fireRate = 0.09
        ship.tripleShot = true
    elseif powerUpType == "shield" then
        ship.shieldActive = true
    elseif powerUpType == "magnet" then
        ship.collectingRadius = ship.collectingRadius * 5
        ship.magnetActive = true
    end
end

function PowerUpManager:removePowerUp(ship, powerUpType)
    if powerUpType == "triple_shot" then
        ship.tripleShotWide = false
    elseif powerUpType == "fire_rate_boost" then
        ship.fireRate = 0.1 
        ship.tripleShot = false
    elseif powerUpType == "shield" then
        ship.shieldActive = false
    elseif powerUpType == "magnet" then
        ship.collectingRadius = ship.collectingRadius / 5
        ship.magnetActive = false
    end
end

function PowerUpManager:update(dt)
    for i = #powerUps, 1, -1 do
        local powerUp = powerUps[i]
        powerUp.timer = powerUp.timer - dt
        if powerUp.timer <= 0 then
            self:removePowerUp(powerUp.ship, powerUp.type)
            table.remove(powerUps, i)
        end
    end
end

function PowerUpManager:removeAllPowerUps()
  for i = #powerUps, 1, -1 do
    local powerUp = powerUps[i]
    self:removePowerUp(powerUp.ship, powerUp.type)
    table.remove(powerUps, i)
  end
end

return PowerUpManager