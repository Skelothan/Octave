winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()

centerRadius = math.min(love.graphics.getHeight(), love.graphics.getWidth())/8

gSpawnDistance = math.max(love.graphics.getHeight(), love.graphics.getWidth())/2

rootTwo = math.sqrt(2)

noteSpawnCoords = {
	--First Pad (bottom right)
	{ --1
		love.graphics.getWidth()/2 + centerRadius/rootTwo + gSpawnDistance, 
		love.graphics.getHeight()/2 + centerRadius/rootTwo
	},
	{ --2
		love.graphics.getWidth()/2 + centerRadius/rootTwo + gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 + centerRadius/rootTwo+ gSpawnDistance/rootTwo
	},
	{ --3
		love.graphics.getWidth()/2 + centerRadius/rootTwo, 
		love.graphics.getHeight()/2 + centerRadius/rootTwo + gSpawnDistance
	},
	--Second Pad (bottom)
	{ --4
		love.graphics.getWidth()/2 + gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 + centerRadius+ gSpawnDistance/rootTwo
	},
	{ --5
		love.graphics.getWidth()/2, 
		love.graphics.getHeight()/2 + centerRadius + gSpawnDistance
	},
	{ --6
		love.graphics.getWidth()/2 - gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 + centerRadius + gSpawnDistance/rootTwo
	},
	--Third Pad (bottom left)
	{ --7
		love.graphics.getWidth()/2 - centerRadius/rootTwo, 
		love.graphics.getHeight()/2 + centerRadius/rootTwo + gSpawnDistance
	},
	{ --8
		love.graphics.getWidth()/2 - centerRadius/rootTwo - gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 + centerRadius/rootTwo+ gSpawnDistance/rootTwo
	},
	{ --9
		love.graphics.getWidth()/2 - centerRadius/rootTwo - gSpawnDistance, 
		love.graphics.getHeight()/2 + centerRadius/rootTwo 
	},
	--Fourth Pad (left)
	{ --10
		love.graphics.getWidth()/2 - centerRadius - gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 + gSpawnDistance/rootTwo
	},
	{ --11
		love.graphics.getWidth()/2 - centerRadius - gSpawnDistance, 
		love.graphics.getHeight()/2
	},
	{ --12
		love.graphics.getWidth()/2 - centerRadius - gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 - gSpawnDistance/rootTwo
	},
	--Fifth Pad (top left)
	{ --13
		love.graphics.getWidth()/2 - centerRadius/rootTwo - gSpawnDistance, 
		love.graphics.getHeight()/2 - centerRadius/rootTwo
	},
	{ --14
		love.graphics.getWidth()/2 - centerRadius/rootTwo - gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 - centerRadius/rootTwo- gSpawnDistance/rootTwo
	},
	{ --15
		love.graphics.getWidth()/2 - centerRadius/rootTwo, 
		love.graphics.getHeight()/2 - centerRadius/rootTwo - gSpawnDistance
	},
	--Sixth Pad (top)
	{ --16
		love.graphics.getWidth()/2 - gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 - centerRadius - gSpawnDistance/rootTwo
	},
	{ --17
		love.graphics.getWidth()/2, 
		love.graphics.getHeight()/2 - centerRadius - gSpawnDistance
	},
	{ --18
		love.graphics.getWidth()/2 + gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 - centerRadius - gSpawnDistance/rootTwo
	},
	--Seventh Pad (top right)
	{ --19
		love.graphics.getWidth()/2 + centerRadius/rootTwo , 
		love.graphics.getHeight()/2 - centerRadius/rootTwo- gSpawnDistance
	},
	{ --20
		love.graphics.getWidth()/2 + centerRadius/rootTwo + gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 - centerRadius/rootTwo- gSpawnDistance/rootTwo
	},
	{ --21
		love.graphics.getWidth()/2 + centerRadius/rootTwo + gSpawnDistance, 
		love.graphics.getHeight()/2 - centerRadius/rootTwo 
	},
	--Eighth Pad (right)
	{ --10
		love.graphics.getWidth()/2 + centerRadius + gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 - gSpawnDistance/rootTwo
	},
	{ --11
		love.graphics.getWidth()/2 + centerRadius + gSpawnDistance, 
		love.graphics.getHeight()/2
	},
	{ --12
		love.graphics.getWidth()/2 + centerRadius + gSpawnDistance/rootTwo, 
		love.graphics.getHeight()/2 + gSpawnDistance/rootTwo
	},
}








