AudioPlayer = {}
AudioPlayer.__index = AudioPlayer

function AudioPlayer:init(audio)
    local o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self.audio = audio:clone()

    highgain_ = 1
    highgain_rate = 6
    highgain_min = .0001
    return o
end

function AudioPlayer:update(dt)
	highgain_ = math.min(highgain_+highgain_*highgain_rate*dt, 1)
	self.audio:setFilter{
		type = "lowpass",
		volume = 1,
		highgain = highgain_,
	}
end

function AudioPlayer:setLooping(loop)
	self.audio:setLooping(loop)
end

function AudioPlayer:takeDamage()
	highgain_ = highgain_min
	self.audio:setFilter{
		type = "lowpass",
		volume = 1,
		highgain = highgain_,
	}
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
