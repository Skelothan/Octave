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

currentPalette = "standard"

gBackgroundDefs = {
	["oscCircle"] = {
			init2 = function(self) 
						self.x = love.graphics.getWidth()/2
						self.y = love.graphics.getHeight()/2
						gBackgroundImage = nil
						love.graphics.setBackgroundColor(gPalette[currentPalette].background)
						self.timer = 0
					end,
			update = function(self, dt) 
						self.timer = (self.timer + dt) % (2 * math.pi)
						self.x = self.x + math.cos(self.timer) * love.graphics.getWidth()/200
					end,
			render = function(self)
						love.graphics.setColor(gPalette[currentPalette].background2)
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
						love.graphics.setBackgroundColor(gPalette[currentPalette].background)
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
						love.graphics.setColor(gPalette[currentPalette].bgObjects)
						for i, v in ipairs(allpoints) do
							love.graphics.polygon("line", v)
						end
						love.graphics.resetColor()
					end
	},
	["shearSquares"] = {
			init2 = function(self)
						gBackgroundImage = nil
						self.timer1 = 0
						self.timer2 = math.pi/2
						love.graphics.setBackgroundColor(gPalette[currentPalette].background)
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
						love.graphics.setColor(gPalette[currentPalette].bgObjects)
						love.graphics.translate(margin,love.graphics.getHeight()/2 + margin)
						love.graphics.shear(math.tan(self.timer1), 0)
						for i=1,4 do
							for j=1,4 do
								love.graphics.rectangle("fill", self.bounds*((i-1)/4)+1/8, self.bounds*((j-3)/4)+1/8, size, size)
							end
						end
						love.graphics.pop()
						love.graphics.push()
						love.graphics.setColor(gPalette[currentPalette].background2)
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
