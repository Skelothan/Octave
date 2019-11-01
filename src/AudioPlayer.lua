AudioPlayer = {}
AudioPlayer.__index = AudioPlayer

function AudioPlayer:init(audio)
    local o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self.audio = audio:clone()

    self.highgain = 1
    self.highgainRate = 6
    self.highgainMin = .0001
    return o
end

function AudioPlayer:update(dt)
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