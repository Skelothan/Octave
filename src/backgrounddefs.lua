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

gBackgroundDefs = {
	["oscCircle"] = {
			init2 = function(self) 
						self.x = love.graphics.getWidth()/2
						self.y = love.graphics.getHeight()/2
						gBackgroundImage = nil
						love.graphics.setBackgroundColor(currentPalette.background)
						self.timer = 0
					end,
			update = function(self, dt) 
						self.timer = (self.timer + dt) % (2 * math.pi)
						self.x = self.x + math.cos(self.timer) * love.graphics.getWidth()/200
					end,
			render = function(self)
						love.graphics.setColor(currentPalette.background2)
						love.graphics.circle("fill", self.x, self.y, love.graphics.getHeight()*0.8) 
						love.graphics.resetColor()
					end
	},
	["spinTriangle"] = {
			init2 = function(self)
						self.x = love.graphics.getWidth()/2
						self.y = love.graphics.getHeight()/2
						gBackgroundImage = love.graphics.newImage("graphics/menubackground.png")
						self.triangles = {{0, math.sqrt(3)*self.y/4, -self.y/2,-math.sqrt(3)*self.y/4,self.y/2,-math.sqrt(3)*self.y/4},
							{0, math.sqrt(3)*self.y/4, -self.y/2,-math.sqrt(3)*self.y/4,self.y/2,-math.sqrt(3)*self.y/4},
							{0, math.sqrt(3)*self.y/4, -self.y/2,-math.sqrt(3)*self.y/4,self.y/2,-math.sqrt(3)*self.y/4},}
						self.angle = 0
					end,
			update = function(self, dt)
						self.angle = (self.angle + dt) % (2 * math.pi)/20
						for j, u in ipairs(self.triangles) do
							self.triangles[j] = rotate_object(self.triangles[j],self.angle*j/4)
						end 
					end,
			render = function(self)
						love.graphics.setLineWidth(10)
						love.graphics.setBackgroundColor(currentPalette.background)
						love.graphics.resetColor()
						--love.graphics.draw(self.backImage,0,0,0,self.x*2/1920, self.y*2/1080)
						allpoints = {}
						for j, u in ipairs(self.triangles) do
							points = {}
							for i, v in ipairs(u) do
								if (i%2) == 1 then
									table.insert(points, v+self.x)
								else
									table.insert(points, v+self.y)
								end 
							end
							table.insert(allpoints,points)
						end
						love.graphics.setColor(currentPalette.bgObjects)
						for i, v in ipairs(allpoints) do
							love.graphics.polygon("line", v)
						end
						love.graphics.resetColor()
					end
	},
	["squares"] = {
			init2 = function(self) 
						self.x = love.graphics.getWidth()/2
						self.y = love.graphics.getHeight()/2
						gBackgroundImage = love.graphics.newImage("graphics/menubackground2.png")
						love.graphics.setBackgroundColor(currentPalette.background)
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
						for j, u in ipairs(self.squares) do
							points = {}
							for i, v in ipairs(u) do
								if (i%2) == 1 then
									table.insert(points, v+self.x)
								else
									table.insert(points, v+self.y)
								end 
							end
							table.insert(allpoints,points)
						end
						love.graphics.setColor(currentPalette.bgObjects)
						for i, v in ipairs(allpoints) do
							love.graphics.polygon("line", v)
							for k, w in ipairs(v) do
								if (k%2) == 1 and (i < 3) then
									love.graphics.circle("line",v[k], v[k+1], self.circleRad)
								end
							end 
						end
						love.graphics.resetColor()
					end
	}
}
