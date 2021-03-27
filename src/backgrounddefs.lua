function loadBackgroundNames()
	gBackgroundNames = {}
	
	for k, v in pairs(gBackgroundDefs) do
		gBackgroundNames[k] = true
	end
end

gBackgroundDefs = {
	["nothing"] = {
			init2 = function(self) 
						
					end,
			update = function(self, dt) 
						
					end,
			render = function(self)
						
					end
	},
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
						self.triangle = {self.x, self.y/2+self.y, -self.y/2 * math.sqrt(3)/2+self.x,-self.y/2 * 1/2+self.y,self.y/2 * math.sqrt(3)/2+self.x,-self.y/2 * 1/2+self.y}
						self.angle = 0
						love.graphics.resetColor()
					end,
			update = function(self, dt)
						self.angle = (self.angle + dt)
					end,
			render = function(self)
						love.graphics.setLineWidth(10)
						love.graphics.setColor(gCurrentPalette.gradient)
						love.graphics.draw(gBackgroundImage,0,0,0,self.x*2/1920, self.y*2/1080)
						love.graphics.setColor(gCurrentPalette.bgObjects)

						love.graphics.push()
						love.graphics.translate(self.x,self.y)
						love.graphics.rotate(self.angle/15)
						love.graphics.translate(-self.x,-self.y)

						for i=1,6 do 
							love.graphics.push()
							love.graphics.translate(self.x,self.y)
							love.graphics.rotate(math.cos(self.angle)/4*(i-1)/4)
							love.graphics.translate(-self.x,-self.y)

							love.graphics.polygon("line", self.triangle)
							love.graphics.pop()
						end 

						love.graphics.pop()

						love.graphics.resetColor()
					end
	},
	["squares"] = {
			init2 = function(self) 
						self.x = love.graphics.getWidth()/2
						self.y = love.graphics.getHeight()/2
						gBackgroundImage = love.graphics.newImage("graphics/radialGradient.png")
						love.graphics.setBackgroundColor(gCurrentPalette.background)
						self.squares = {{-self.y/4+self.x,-self.y/4+self.y, self.y/4+self.x,-self.y/4+self.y, self.y/4+self.x,self.y/4+self.y,-self.y/4+self.x,self.y/4+self.y},
										{-self.y/4*math.sqrt(2)+self.x,self.y, self.x,-self.y/4*math.sqrt(2)+self.y, self.y/4*math.sqrt(2)+self.x,self.y,self.x,self.y/4*math.sqrt(2)+self.y},
										{-self.y/2+self.x,-self.y/2+self.y, self.y/2+self.x,-self.y/2+self.y, self.y/2+self.x,self.y/2+self.y,-self.y/2+self.x,self.y/2+self.y},
										{-self.y/2*math.sqrt(2)+self.x,self.y, self.x,-self.y/2*math.sqrt(2)+self.y, self.y/2*math.sqrt(2)+self.x,self.y,self.x,self.y/2*math.sqrt(2)+self.y}}
						self.circleRad = self.y/16
						self.angle = 9
						love.graphics.resetColor()
					end,
			update = function(self, dt) 
						self.angle = self.angle + dt
					end,
			render = function(self)
						love.graphics.setLineWidth(10)

						love.graphics.setColor(gCurrentPalette.gradient)
						love.graphics.draw(gBackgroundImage,0,0,0,self.x*2/1920, self.y*2/1080)
						love.graphics.resetColor()
						love.graphics.setColor(gCurrentPalette.bgObjects)

						for i = 1,2 do 
							j = 1 - 2 * ((i+1)%2)
							love.graphics.push()
							love.graphics.translate(self.x,self.y)
							love.graphics.rotate(self.angle/15 * j)
							love.graphics.translate(-self.x,-self.y)

							love.graphics.polygon("line",self.squares[2*i-1])
							love.graphics.polygon("line",self.squares[2*i])

							for l=1,2 do
								for k, w in ipairs(self.squares[l]) do
									if (k%2) == 1 and (i == 1) then
										love.graphics.circle("line",self.squares[l][k], self.squares[l][k+1], self.circleRad)
									end
								end
							end 

							love.graphics.pop()
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
						gBackgroundImage = love.graphics.newImage("graphics/linearGradientBottom.png")
						self.bounds = math.max(love.graphics.getHeight(), love.graphics.getWidth())
					end,
			update = function(self, dt)
						self.timer1 = (self.timer1 + dt * 1/4) % (2 * math.pi)
						self.timer2 = (self.timer2 + dt * 1/4) % (2 * math.pi)
						
					end,
			render = function(self)
						local margin = self.bounds * 1/4 * 1/8
						local size = self.bounds*1/4*3/4
						love.graphics.setColor(gCurrentPalette.gradient)
						love.graphics.draw(gBackgroundImage,0,0,0,self.x*2/1920, self.y*2/1080)
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
	},
	["pulseCircles"] = {
			init2 = function(self)
						gBackgroundImage = love.graphics.newImage("graphics/linearGradientBottom.png")
						self.timer1 = 0
						self.timer2 = 0
						self.cirPos = 0
						self.cirPos2 = math.pi
						self.cx = winWidth / 2
						self.cy = winHeight / 2
						self.circleSize = love.graphics.getHeight()*0.2
						self.dist = math.min(winWidth, winHeight) / 4
						love.graphics.setBackgroundColor(gCurrentPalette.background)
					end,
			update = function(self, dt)
						self.timer1 = (self.timer1 + dt * 3/4) % (2 * math.pi)
						self.cirPos = math.sin(self.timer1)
						self.cirPos2 = math.cos(self.timer1)
						self.timer2 = (self.timer2 + dt * 1/7) % (2 * math.pi)
					end,
			render = function(self)
						love.graphics.setColor(gCurrentPalette.gradient)
						love.graphics.draw(gBackgroundImage,0,0,0,self.x*2/1920, self.y*2/1080)
						love.graphics.push()
						-- rotate around center
						love.graphics.translate(self.cx, self.cy)
						love.graphics.rotate(self.timer2)
						love.graphics.translate(-self.cx, -self.cy)
						
						love.graphics.setColor(gCurrentPalette.bgObjects)
						love.graphics.circle("fill", self.cx + self.dist * self.cirPos, self.cy, self.circleSize)
						love.graphics.circle("fill", self.cx - self.dist * self.cirPos, self.cy, self.circleSize)
						love.graphics.circle("fill", self.cx, self.cy + self.dist * (self.cirPos2), self.circleSize)
						love.graphics.circle("fill", self.cx, self.cy - self.dist * (self.cirPos2), self.circleSize)
						love.graphics.pop()
					end
	},
	["scrollSquares"] = {
			init2 = function(self)
						self.timer1 = 0
						self.cx = winWidth
						self.cy = winHeight / 2
						self.circleSize = love.graphics.getHeight()*0.2
						self.dist = math.min(winWidth, winHeight) / 4
						gBackgroundImage = love.graphics.newImage("graphics/linearGradientBottom.png")
						love.graphics.setBackgroundColor(gCurrentPalette.background)
						self.margin = winHeight * 1/16
						self.size = winHeight * 1/4 - self.margin
					end,
			update = function(self, dt)
						self.timer1 = (self.timer1 - 100 * dt)
					end,
			render = function(self)
						love.graphics.push()
						-- rotate around center
						--love.graphics.translate(self.cx, self.cy)
						--love.graphics.rotate(self.timer2)
						--love.graphics.translate(-self.cx, -self.cy)
						love.graphics.translate(self.timer1, 0)
						
						love.graphics.setColor(gCurrentPalette.bgObjects)
						for i=1,7,2 do
							love.graphics.rectangle("fill", self.cx, winHeight * i/8 - self.margin, self.size, self.size)
						end
						love.graphics.pop()
					end
	},
	["waveRectangles"] = {
			init2 = function(self)
						gBackgroundImage = nil
						self.timer1 = 0
						self.y = winHeight /2
						gBackgroundImage = love.graphics.newImage("graphics/linearGradientBottom.png")
						love.graphics.setBackgroundColor(gCurrentPalette.background)
						self.margin = winWidth * 1/16
						self.size = winHeight * 1/4 - self.margin
					end,
			update = function(self, dt)
						self.timer1 = (self.timer1 + dt)
					end,
			render = function(self)
						love.graphics.setColor(gCurrentPalette.gradient)
						love.graphics.draw(gBackgroundImage,0,0,0,winWidth/1920, winHeight*2/1080)
						love.graphics.resetColor()

						love.graphics.setColor(gCurrentPalette.bgObjects2)
						for i=1,7 do
							love.graphics.rectangle("fill", winWidth * i/8 - self.margin +self.size/2, self.y-self.size/2 + 100*math.cos(self.timer1+math.pi/2*i), self.size/2, 2*self.y)
						end
					end
	},
	["dualWaveRectangles"] = {
			init2 = function(self)
						gBackgroundImage = nil
						self.timer1 = 0
						self.x = winWidth / 2
						self.y = winHeight /2
						gBackgroundImage = love.graphics.newImage("graphics/linearGradientBottom.png")
						love.graphics.setBackgroundColor(gCurrentPalette.background)
						self.margin = winWidth * 1/16
						self.size = winHeight * 1/4 - self.margin
					end,
			update = function(self, dt)
						self.timer1 = (self.timer1 + dt)
					end,
			render = function(self)
						love.graphics.setColor(gCurrentPalette.gradient)
						love.graphics.draw(gBackgroundImage,0,0,0,self.x*2/1920, self.y*2/1080)

						love.graphics.setColor(gCurrentPalette.bgObjects2)
						for i=1,15 do
							love.graphics.rectangle("fill", winWidth * i/15 - 5*self.margin/6, self.y-self.size/2 + 100*math.cos(self.timer1+math.pi/4*i), self.size/2, 2*self.y)
						end
					end
	},
	["orbitSphere"] = {
			init2 = function(self)
						gBackgroundImage = nil
						self.timer1 = 0
						self.x = winWidth / 2
						self.y = winHeight /2
						gBackgroundImage = love.graphics.newImage("graphics/radialGradient.png")
						love.graphics.setBackgroundColor(gCurrentPalette.background)
						self.radius = self.y/3
						self.orbitcenters = {0,0,0,0,0,0,0,0}
					end,
			update = function(self, dt)
						self.timer1 = (self.timer1 + dt)
						self.orbitcenters[1] = (2*self.radius*(math.cos(self.timer1))+1/2*self.radius*(math.sin(self.timer1)))
						self.orbitcenters[2] =(1/4*self.radius*(math.sin(self.timer1))-2*self.radius*(math.cos(self.timer1)))
						self.orbitcenters[3] = (2*math.sqrt(2)* self.radius*(math.cos(self.timer1)))
						self.orbitcenters[4] = (1/4*math.sqrt(2)*self.radius*(math.sin(self.timer1)))
						self.orbitcenters[5] = (2*self.radius*(math.cos(self.timer1))-1/2*self.radius*(math.sin(self.timer1)))
						self.orbitcenters[6] = (1/4*self.radius*(math.sin(self.timer1))+2*self.radius*(math.cos(self.timer1)))
					end,
 					
			render = function(self)
						love.graphics.setColor(gCurrentPalette.gradient)
						love.graphics.draw(gBackgroundImage,0,0,0,self.x*2/1920, self.y*2/1080)

						love.graphics.setLineWidth(10)
						love.graphics.setColor(gCurrentPalette.bgObjects)

						love.graphics.circle("line",self.x,self.y, self.radius)

						love.graphics.ellipse("line",self.x,self.y,self.radius,1/4*self.radius)

						for i=1,3 do
							love.graphics.circle("line",self.orbitcenters[2*i-1]+self.x,self.orbitcenters[2*i]+self.y,self.radius/8)
						end 
					end

	},
	["orbitCircles"] = {
		init2 = function(self)
						gBackgroundImage = nil
						self.timer1 = 0
						self.x = winWidth / 2
						self.y = winHeight /2
						gBackgroundImage = love.graphics.newImage("graphics/radialGradient.png")
						love.graphics.setBackgroundColor(gCurrentPalette.background)
						self.radius = self.y/2
					end,
			update = function(self, dt)
						self.timer1 = (self.timer1 + dt/5)
					end,
			render = function(self)
						love.graphics.setColor(gCurrentPalette.gradient)
						love.graphics.draw(gBackgroundImage,0,0,0,self.x*2/1920, self.y*2/1080)

						love.graphics.setLineWidth(10)
						love.graphics.setColor(gCurrentPalette.bgObjects)
						love.graphics.circle("line",self.x,self.y,self.radius*2/3)
	
						for i=1,8 do
							love.graphics.circle("fill",math.cos(self.timer1+math.pi/4*i)*self.radius*1.25+self.x, math.sin(self.timer1+math.pi/4*i)*self.radius*1.25+self.y,self.radius/6)
						end 
					end
	},
	["healthGlow"] = {
		init2 = function(self)
						gBackgroundImage = nil
						self.timer1 = 0
						self.x = winWidth / 2
						self.y = winHeight /2
						love.graphics.setBackgroundColor(gCurrentPalette.background)
						self.radius = math.min(love.graphics.getHeight(), love.graphics.getWidth()) / 12
					end,
		update = function(self, dt)
						self.timer1 = self.timer1 + dt
					end,
		render = function(self)
						love.graphics.setLineWidth(15)
						love.graphics.setColor(gCurrentPalette.bgObjects)
						love.graphics.circle("line",self.x,self.y,self.radius+math.cos(self.timer1)*self.radius/8*2/3)
					end
	},
	-- New in 1.1
	["twinBubbles"] = {
		init2 = function(self)
						self.x1 = winWidth / 4
						self.x2 = winWidth * 3 / 4
						self.maxY = winHeight * 3/9
						self.tripleWinHeight = winHeight * 3
						self.oneThird = 1/3

						-- Speed at which the whole animation plays
						self.bubbleSpeed = 1/1024

						-- Rate at which the size of the bubbles decreases.
						-- Strictly linear wasn't as aesthetically pleasing.
						self.bubbleSizeDecay = 2/3

						-- Bubbles: {"timer", radius, y-position}
						self.bubbles = {
							{3/9, winHeight * math.pow(3/9, self.bubbleSizeDecay), 0},
							{2/9, winHeight * math.pow(2/9, self.bubbleSizeDecay), 0},
							{1/9, winHeight * math.pow(1/9, self.bubbleSizeDecay), 0},
							{0, 0, 0}
						}

						-- Constants used to calculate the y-position of each bubble based on radius.
						self.yIntercept = winHeight * 0.10
						self.ySlope = ((winHeight + self.bubbles[1][2]) - self.yIntercept) * 3

						-- Fix initial y position of bubbles
						for i=1,3 do
							self.bubbles[i][3] = self.ySlope * self.bubbles[i][1] + self.yIntercept
						end
						
						gBackgroundImage = love.graphics.newImage("graphics/linearGradientBottom.png")
						love.graphics.setBackgroundColor(gCurrentPalette.background)
					end,
		update = function(self, dt)
						for k,bubble in ipairs(self.bubbles) do
							bubble[1] = (bubble[1] - self.bubbleSpeed) % self.oneThird
							bubble[2] = winHeight * math.pow(bubble[1], self.bubbleSizeDecay)
							bubble[3] = self.ySlope * bubble[1] + self.yIntercept
						end
					end,
		render = function(self)
						love.graphics.setColor(gCurrentPalette.gradient)
						love.graphics.draw(gBackgroundImage,0,0,0,self.x*2/1920, self.y*2/1080)
						
						love.graphics.setColor(gCurrentPalette.bgObjects)
						
						for k,bubble in ipairs(self.bubbles) do
							love.graphics.push()
							love.graphics.translate(0, bubble[3])
							love.graphics.circle("fill", self.x1, 0, bubble[2])
							love.graphics.circle("fill", self.x2, 0, bubble[2])
							love.graphics.pop()
						end
					end
	}
	
}
