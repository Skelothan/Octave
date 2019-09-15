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
}

}