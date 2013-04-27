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


--[[------------------------------------------------------------
GAME GAMESTATE
--]]------------------------------------------------------------

local state = GameState.new()

function state:init()
  self.heartrate = 0.3
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
  
end


function state:draw()
  love.graphics.push()
    love.graphics.setColor(255 * self.heartrate, 0, 255 * (1 - self.heartrate))
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.pop()
  
end

return state