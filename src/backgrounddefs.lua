gBackgroundDefs = {

["oscCircle"] = {
		init2 = function(self) 
					self.x = love.graphics.getWidth()/2
					self.y = love.graphics.getHeight()/2
					self.timer = 0
				end,
		update = function(self, dt) 
					self.timer = (self.timer + dt) % (2 * math.pi)
					self.x = self.x + math.cos(self.timer) * love.graphics.getWidth()/200
				end,
		render = function(self)
					love.graphics.setBackgroundColor(0/255, 0/255, 80/255, 255/255)
					love.graphics.setColor(0/255, 255/255, 255/255, 40/255)
					love.graphics.circle("fill", self.x, self.y, love.graphics.getHeight()*0.8) 
					love.graphics.resetColor()
				end
},
["spinTriangle"] = {
	init2 = function(self)
					self.x = love.graphics.getWidth()/2
					self.y = love.graphics.getHeight()/2
					self.backImage = love.graphics.newImage("graphics/menubackground.png")
					self.triangles = {[1] = {0, math.sqrt(3)*self.y/4, -self.y/2,-math.sqrt(3)*self.y/4,self.y/2,-math.sqrt(3)*self.y/4},
						[2] = {0, math.sqrt(3)*self.y/4, -self.y/2,-math.sqrt(3)*self.y/4,self.y/2,-math.sqrt(3)*self.y/4},
						[3] = {0, math.sqrt(3)*self.y/4, -self.y/2,-math.sqrt(3)*self.y/4,self.y/2,-math.sqrt(3)*self.y/4},}
					self.angle = 0
				end,
	update = function(self, dt)
					self.angle = (self.angle + dt) % (2 * math.pi)/20
					for j, u in ipairs(self.triangles) do
						for i, v in ipairs(u) do
							if (i % 2) == 1 then
								u[i] = u[i]*math.cos(self.angle * j/4) - u[i+1]*math.sin(self.angle * j/4)
							else
								u[i] = u[i-1]*math.sin(self.angle * j/4) + u[i]*math.cos(self.angle * j/4)
							end
						end
					end 
				end,
	render=function(self)
					love.graphics.setLineWidth(10)
					love.graphics.setBackgroundColor(0/255, 0/255, 160/255, 255/255)
					love.graphics.setColor(s)	
					love.graphics.draw(self.backImage,0,0,0,self.x*2/1920, self.y*2/1080)
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

					for i, v in ipairs(allpoints) do
						love.graphics.polygon("line", v)
					end
					love.graphics.resetColor()
				end
}
}
-- these aren't quite working as I want them to -> once working we can improve upon rotating objects
function rotate(x,y,angle)
	newX = x*math.cos(angle) - y*math.sin(angle)
	newY = x*math.sin(angle) + y*math.cos(angle)
	return tuple(newX, newY)
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