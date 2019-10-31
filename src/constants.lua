winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()

centerRadius = math.min(love.graphics.getHeight(), love.graphics.getWidth())/8

spawnDistance = math.max(love.graphics.getHeight(), love.graphics.getWidth())/2

noteSpawnCoords = {
	--First Pad (bottom right)
	{ --1
		love.graphics.getWidth()/2 + centerRadius/math.sqrt(2) + spawnDistance, 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2)
	},
	{ --2
		love.graphics.getWidth()/2 + centerRadius/math.sqrt(2) + spawnDistance/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2)+ spawnDistance/math.sqrt(2)
	},
	{ --3
		love.graphics.getWidth()/2 + centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2) + spawnDistance
	},
	--Second Pad (bottom)
	{ --4
		love.graphics.getWidth()/2 + spawnDistance/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius+ spawnDistance/math.sqrt(2)
	},
	{ --5
		love.graphics.getWidth()/2, 
		love.graphics.getHeight()/2 + centerRadius + spawnDistance
	},
	{ --6
		love.graphics.getWidth()/2 - spawnDistance/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius + spawnDistance/math.sqrt(2)
	},
	--Third Pad (bottom left)
	{ --7
		love.graphics.getWidth()/2 - centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2) + spawnDistance
	},
	{ --8
		love.graphics.getWidth()/2 - centerRadius/math.sqrt(2) - spawnDistance/math.sqrt(2), 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2)+ spawnDistance/math.sqrt(2)
	},
	{ --9
		love.graphics.getWidth()/2 - centerRadius/math.sqrt(2) - spawnDistance, 
		love.graphics.getHeight()/2 + centerRadius/math.sqrt(2) 
	},
	--Fourth Pad (left)
	{ --10
		love.graphics.getWidth()/2 - centerRadius - spawnDistance/math.sqrt(2), 
		love.graphics.getHeight()/2 + spawnDistance/math.sqrt(2)
	},
	{ --11
		love.graphics.getWidth()/2 - centerRadius - spawnDistance, 
		love.graphics.getHeight()/2
	},
	{ --12
		love.graphics.getWidth()/2 - centerRadius - spawnDistance/math.sqrt(2), 
		love.graphics.getHeight()/2 - spawnDistance/math.sqrt(2)
	},
	--Fifth Pad (top left)
	{ --13
		love.graphics.getWidth()/2 - centerRadius/math.sqrt(2) - spawnDistance, 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2)
	},
	{ --14
		love.graphics.getWidth()/2 - centerRadius/math.sqrt(2) - spawnDistance/math.sqrt(2), 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2)- spawnDistance/math.sqrt(2)
	},
	{ --15
		love.graphics.getWidth()/2 - centerRadius/math.sqrt(2), 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2) - spawnDistance
	},
	--Sixth Pad (top)
	{ --16
		love.graphics.getWidth()/2 - spawnDistance/math.sqrt(2), 
		love.graphics.getHeight()/2 - centerRadius - spawnDistance/math.sqrt(2)
	},
	{ --17
		love.graphics.getWidth()/2, 
		love.graphics.getHeight()/2 - centerRadius - spawnDistance
	},
	{ --18
		love.graphics.getWidth()/2 + spawnDistance/math.sqrt(2), 
		love.graphics.getHeight()/2 - centerRadius - spawnDistance/math.sqrt(2)
	},
	--Seventh Pad (top right)
	{ --19
		love.graphics.getWidth()/2 + centerRadius/math.sqrt(2) , 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2)- spawnDistance
	},
	{ --20
		love.graphics.getWidth()/2 + centerRadius/math.sqrt(2) + spawnDistance/math.sqrt(2), 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2)- spawnDistance/math.sqrt(2)
	},
	{ --21
		love.graphics.getWidth()/2 + centerRadius/math.sqrt(2) + spawnDistance, 
		love.graphics.getHeight()/2 - centerRadius/math.sqrt(2) 
	},
	
}








