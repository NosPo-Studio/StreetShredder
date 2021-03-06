--[[
    This file is a GameObject example for the NosGa Engine.
	
	NosGa Engine Copyright (c) 2019-2020 NosPo Studio

    The NosGa Engine is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    The NosGa Engine is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with the NosGa Engine.  If not, see <https://www.gnu.org/licenses/>.
]]

local global = ... --Here we get global.

GameObjectsTemplate = {}
GameObjectsTemplate.__index = GameObjectsTemplate

--Called once when the class is loaded by the engine.
function GameObjectsTemplate.init(this) 
	
end


--Calles on the bject creation of the class. Here you define/initiate the class.
function GameObjectsTemplate.new(args) 
	--===== gameObject definition =====--
	--Take given GameObject args if present and prevents it from being nil if not.
	args = args or {} 
	args.sizeX = 10
	args.sizeY = 7
	args.components = { --Define the GameObjects components.
		{"Sprite", 
			x = 0, 
			y = 0, 
			texture = global.animation.test,
		},
		{"RigidBody", 
			g = 0,
			stiffness = 2,
		},
	}
	
	--===== default stuff =====--
	--Inheritance from the GameObject main class.
	local this = global.parent.Background.new(args) 
	
	--[[Not sure to be honest, 
		I only know that this is necessary to declare a class/create an object (.^.)
	]]
	this = setmetatable(this, GameObjectsTemplate) 
	
	--===== init =====--
	--this.anim = args.oclrl.Animation.new(args.oclrl, global.texture.player.right)
	--this.anim2 = args.oclrl.Animation.new(args.oclrl, global.texture.player.right)
	
	--this.to1 = global.parent.Test.new(args.posX)
	
	--===== custom functions =====--
	--[[Same as the function equevalent in the stateTemplate
		but called with the additionally conditions as "this.update()".
	]]
	this.key_down = function(this, signal) 
		
	end
	
	--===== default functions =====--
	--Called when this GameObject is added to a RenderArea.
	this.start = function(this) 
		
	end
	
	--Called up to once a frame.
	this.update = function(this, dt, ra) 
		--this.anim:draw(args.posX -90, 10)
		--this.anim2:draw(args.posX -90, 5)
	end
	
	--[[Called every time the GameObject is drawed. 
		That can happen multiple times a frame if the GameObject is visible in multiple RenderAreas.
	]]
	this.draw = function(this) 
	
	end
	
	--[[Called every time the GameObject graphics are removed from the screen. 
		That can happen multiple times a frame if the GameObject is visible in multiple RenderAreas.
	]]
	this.clear = function(this, acctual) 
		
	end
	
	--Called when this GameObject is removed from a RenderArea.
	this.stop = function(this) 
		
	end
	
	return this
end

return GameObjectsTemplate