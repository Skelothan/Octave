AudioPlayer = {}
AudioPlayer.__index = AudioPlayer

function AudioPlayer:init(audio)
    local o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self.audio = audio:clone()

    self.highgain = 1
    self.highgainRate = 9
    self.highgainMin = .001
    
    self.alpha = 0
    self.alphaRate = 0.75
    self.damageColor = table.deepcopy(gCurrentPalette.menuText)
    return o
end

function AudioPlayer:update(dt)
	self.alpha = math.max(self.alpha - dt * self.alphaRate, 0)
	self.highgain = math.min(self.highgain + self.highgain * self.highgainRate * dt, 1)
	self.audio:setFilter{
		type = "lowpass",
		volume = 1,
		highgain = self.highgain,
	}
end

function AudioPlayer:setLooping(loop)
	self.audio:setLooping(loop)
end

function AudioPlayer:takeDamage()
	self.highgain = self.highgainMin
	self.alpha = 1
	-- following five lines probably unnecessary
	self.audio:setFilter{
		type = "lowpass",
		volume = 1,
		highgain = self.highgain,
	}
end

function AudioPlayer:changeAudio(newAudio)
	self.audio:stop()
	self.audio = newAudio:clone()
	self.damageColor = table.deepcopy(gCurrentPalette.menuText)
end

function AudioPlayer:playAudio()
    self.audio:play()
end

function AudioPlayer:stopAudio()
	self.audio:stop()
end

function AudioPlayer:pauseAudio()
	self.audio:pause()
end

function AudioPlayer:isPlaying()
	return self.audio:isPlaying()
end

function AudioPlayer:render()
	self.damageColor[4] = self.alpha
	love.graphics.setColor(self.damageColor)
	love.graphics.draw(gImages["damage"], 0, 0, 0, winWidth/960, winHeight/540)
end