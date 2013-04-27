--[[
(C) Copyright 2013 
William Dyce, Maxime Ailloud, Alex Verbrugghe, Julien Deville

All rights reserved. This program and the accompanying materials
are made available under the terms of the GNU Lesser General Public License
(LGPL) version 2.1 which accompanies this distribution, and is available at
http://www.gnu.org/licenses/lgpl-2.1.html

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.
--]]

--[[------------------------------------------------------------
IMPORTS
--]]------------------------------------------------------------

local useful = require("useful")
local Class = require("hump/class")

--[[------------------------------------------------------------
TARGETS
--]]------------------------------------------------------------

local Target = Class
{
  init = function(self)
    self.x = math.random()*love.graphics.getWidth()
    self.y = 0
    self.heartrate = math.random()
    self.wobble = 0
  end,
      
  INTERVAL = 10,
  
  SPEED = 16,
  
  SIZE = 32,
  
  DAMAGE_THRESHOLD = 0.2
}

function Target:draw()
  
  local circle_size = self.SIZE * (1 + 0.3*useful.signedRand(self.wobble))
  
  love.graphics.push()
    love.graphics.setColor(255 * self.heartrate, 0, 255 * (1 - self.heartrate))
    love.graphics.circle("fill", self.x, self.y, circle_size)
  love.graphics.pop()
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle("line", self.x, self.y, circle_size )
end

function Target:update(dt, destroyer_heartrate)
  
  -- move
  self.y = self.y + dt*self.SPEED
  
  -- destroy
  local drate = math.abs(destroyer_heartrate - self.heartrate)
  if drate < self.DAMAGE_THRESHOLD then
    self.wobble = 1 - drate/self.DAMAGE_THRESHOLD
  end
  
  -- destroy at end
  if self.y > love.graphics.getHeight() + 100 then
    self.purge = true
  end
end

--[[------------------------------------------------------------
GAME GAMESTATE
--]]------------------------------------------------------------

local state = GameState.new()

function state:init()
  self.heartrate = 0.3
  
  self.timer = 0
  
  self.targets = {}
end

function state:enter()
end


function state:leave()
end


function state:keypressed(key, uni)
  -- exit
  if key=="escape" then
    love.event.push("quit")
  end
end

function state:update(dt)
  
  -- change heartrate
  local delta = 0
  if love.keyboard.isDown("up") then
    delta = delta + 1
  end
  if love.keyboard.isDown("down") then
    delta = delta - 1
  end
  self.heartrate = useful.clamp(self.heartrate + delta*dt*0.3, 0, 1)
  
  -- create targets
  self.timer = self.timer - dt
  if self.timer < 0 then
    self.timer = Target.INTERVAL 
    table.insert(self.targets, Target())
  end
  
  -- update targets
  for i,v in ipairs(self.targets) do
    v:update(dt, self.heartrate)
  end
  
end


function state:draw()

  love.graphics.push()
    love.graphics.setColor(255 * self.heartrate, 0, 255 * (1 - self.heartrate))
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.pop()
  
  for i,v in ipairs(self.targets) do
    v:draw()
  end
  
end

return state