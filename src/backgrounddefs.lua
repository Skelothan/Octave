	-- these aren't quite working as I want them to -> once working we can improve upon rotating objects
function rotate(x,y,angle)
	newX = x*math.cos(angle) - y*math.sin(angle)
	newY = x*math.sin(angle) + y*math.cos(angle)
	return {newX, newY}
end 

function rotate_object(objCoords, angle)
	rotatedCoords = {}
	for i, coord in ipairs(objCoords) do
		if (i % 2) == 1 then
			rotatedCoord = rotate(objCoords[i], objCoords[i+1], angle)
			table.insert(rotatedCoords, rotatedCoord[1])
			table.insert(rotatedCoords, rotatedCoord[2])
		end 
	end 
	return rotatedCoords
end 

function center_points(x, y, points)
	allpoints = {}
	for j, u in ipairs(points) do
		points = {}
		for i, v in ipairs(u) do
			if (i%2) == 1 then
				table.insert(points, v+x)
			else
				table.insert(points, v+y)
			end
		end					
		table.insert(allpoints,points)				
	end
	return allpoints
end 


gBackgroundDefs = {
	["oscCircle"] = {
			init2 = function(self) 
						self.x = love.graphics.getWidth()/2
						self.y = love.graphics.getHeight()/2
						gBackgroundImage = nil
						love.graphics.setBackgroundColor(gCurrentPalette.background)
						self.timer = 0
					end,
			update = function(self, dt) 
						self.timer = (self.timer + dt) % (2 * math.pi)
						self.x = self.x + math.cos(self.timer) * love.graphics.getWidth()/200
					end,
			render = function(self)
						love.graphics.setColor(gCurrentPalette.background2)
						love.graphics.circle("fill", self.x, self.y, love.graphics.getHeight()*0.8) 
						love.graphics.resetColor()
					end
	},
	["spinTriangle"] = {
			init2 = function(self)
						self.x = love.graphics.getWidth()/2
						self.y = love.graphics.getHeight()/2
						gBackgroundImage = love.graphics.newImage("graphics/linearGradientBottom.png")
						love.graphics.setBackgroundColor(gCurrentPalette.background)
						self.triangles = {{0, self.y/2, -self.y/2 * math.sqrt(3)/2,-self.y/2 * 1/2,self.y/2 * math.sqrt(3)/2,-self.y/2 * 1/2},
							{0, self.y/2, -self.y/2 * math.sqrt(3)/2,-self.y/2 * 1/2,self.y/2 * math.sqrt(3)/2,-self.y/2 * 1/2},
							{0, self.y/2, -self.y/2 * math.sqrt(3)/2,-self.y/2 * 1/2,self.y/2 * math.sqrt(3)/2,-self.y/2 * 1/2},
							{0, self.y/2, -self.y/2 * math.sqrt(3)/2,-self.y/2 * 1/2,self.y/2 * math.sqrt(3)/2,-self.y/2 * 1/2},
							{0, self.y/2, -self.y/2 * math.sqrt(3)/2,-self.y/2 * 1/2,self.y/2 * math.sqrt(3)/2,-self.y/2 * 1/2}}
						self.angle = 0
						love.graphics.resetColor()
					end,
			update = function(self, dt)
						self.angle = (self.angle + dt) % (2 * math.pi)
						for j, u in ipairs(self.triangles) do
							self.triangles[j] = rotate_object(self.triangles[j],math.cos(self.angle)/40*(j-1)/5 + 1/40*1/5 )
						end 
					end,
			render = function(self)
						love.graphics.setLineWidth(10)
						love.graphics.setColor(gCurrentPalette.gradient)
						love.graphics.draw(gBackgroundImage,0,0,0,self.x*2/1920, self.y*2/1080)
						love.graphics.resetColor()
						love.graphics.setColor(gCurrentPalette.bgObjects)
						centeredTriangles = center_points(self.x, self.y, self.triangles)
						love.graphics.setColor(gCurrentPalette.bgObjects)
						for i, v in ipairs(centeredTriangles) do
							love.graphics.polygon("line", v)
						end
						love.graphics.resetColor()
					end
	},
	["squares"] = {
			init2 = function(self) 
						self.x = love.graphics.getWidth()/2
						self.y = love.graphics.getHeight()/2
						gBackgroundImage = love.graphics.newImage("graphics/radialGradient.png")
						love.graphics.setBackgroundColor(gCurrentPalette.background)
						self.squares = {{-self.y/4,-self.y/4, self.y/4,-self.y/4, self.y/4,self.y/4,-self.y/4,self.y/4},
										rotate_object({-self.y/4,-self.y/4, self.y/4,-self.y/4, self.y/4,self.y/4,-self.y/4,self.y/4}, math.pi/4),
										{-self.y/2,-self.y/2, self.y/2,-self.y/2, self.y/2,self.y/2,-self.y/2,self.y/2},
										rotate_object({-self.y/2,-self.y/2, self.y/2,-self.y/2, self.y/2,self.y/2,-self.y/2,self.y/2}, math.pi/4)}
						self.circleRad = self.y/16
						self.angle = math.pi/2048
						love.graphics.resetColor()
					end,
			update = function(self, dt) 
						for j, u in ipairs(self.squares) do
							if (j < 3) then
								self.squares[j] = rotate_object(self.squares[j],self.angle)
							else
								self.squares[j] = rotate_object(self.squares[j],-self.angle)
							end 
						end 
					end,
			render = function(self)
						allpoints = {}
						love.graphics.setLineWidth(10)
						centeredSquares = center_points(self.x, self.y, self.squares)
						love.graphics.setColor(gCurrentPalette.gradient)
						love.graphics.draw(gBackgroundImage,0,0,0,self.x*2/1920, self.y*2/1080)
						love.graphics.resetColor()
						love.graphics.setColor(gCurrentPalette.bgObjects)
						for i, v in ipairs(centeredSquares) do
							love.graphics.polygon("line", v)
							for k, w in ipairs(v) do
								if (k%2) == 1 and (i < 3) then
									love.graphics.circle("line",v[k], v[k+1], self.circleRad)
								end
							end 
						end
						love.graphics.resetColor()
					end
	},
	["shearSquares"] = {
			init2 = function(self)
						gBackgroundImage = nil
						self.timer1 = 0
						self.timer2 = math.pi/2
						love.graphics.setBackgroundColor(gCurrentPalette.background)
						self.bounds = math.max(love.graphics.getHeight(), love.graphics.getWidth())
					end,
			update = function(self, dt)
						self.timer1 = (self.timer1 + dt * 3/4) % (2 * math.pi)
						self.timer2 = (self.timer2 + dt * 3/4) % (2 * math.pi)
						
					end,
			render = function(self)
						local margin = self.bounds * 1/4 * 1/8
						local size = self.bounds*1/4*3/4
						love.graphics.push()
						love.graphics.setColor(gCurrentPalette.bgObjects)
						love.graphics.translate(margin,love.graphics.getHeight()/2 + margin)
						love.graphics.shear(math.tan(self.timer1), 0)
						for i=1,4 do
							for j=1,4 do
								love.graphics.rectangle("fill", self.bounds*((i-1)/4)+1/8, self.bounds*((j-3)/4)+1/8, size, size)
							end
						end
						love.graphics.pop()
						love.graphics.push()
						love.graphics.setColor(gCurrentPalette.background2)
						love.graphics.translate(margin,love.graphics.getHeight()/2 + margin)
						love.graphics.shear(-math.tan(self.timer2), 0)
						for i=1,4 do
							for j=1,4 do
								love.graphics.rectangle("fill", self.bounds*((i-1)/4)+5/8, self.bounds*((j-3)/4)+5/8, size, size)
							end
						end
						love.graphics.pop()
						love.graphics.resetColor()
					end
	}
}
