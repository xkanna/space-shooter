local classes = require("classes")
local Ship = classes.class()
local Model = require("Model")

function Ship:init(params)
    print("Ship init!")
    self.speed = params.speed
    self.asset = params.asset
    self.x = Model.stage.stageWidth / 2
    self.y = Model.stage.stageHeight / 2
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
end

function Ship:update(dt)

    local left = Model.movement.left
    local right = Model.movement.right
    local up = Model.movement.up
    local down = Model.movement.down
    local stageWidth = Model.stage.stageWidth
    local stageHeight = Model.stage.stageHeight
    

    local x = 0
    local y = 0

    if left then
        if(self.x > self.w / 2) then
          x = x + -1
        end
    end
    if right then
      if(self.x < stageWidth - (self.w / 2)) then
          x = x + 1
        end
    end

    if up then
      if(self.y > self.h / 2) then
          y = y + -1
        end
    end
    if down then
      if(self.y < stageHeight - (self.h / 2)) then
          y = y + 1
        end
    end

    self.x = self.x + (x * self.speed * dt)
    self.y = self.y + (y * self.speed * dt)

end

function Ship:draw()
    local newX = self.x - (self.w/2)
    local newY = self.y - (self.h/2)
    love.graphics.draw(self.asset, newX,newY )
end

return Ship