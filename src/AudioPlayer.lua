AudioPlayer = {}
AudioPlayer.__index = AudioPlayer

function AudioPlayer:init(audio)
    local o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self.audio = audio:clone()
    self.filteredAudio = audio:clone()

    self.filteredAudio:setFilter{
        type = "lowpass",
        volume = 1,
        highgain = .5,
    }
    return o
end

function AudioPlayer:playAudio()
    self.audio:play()
end

function AudioPlayer:playFilteredAudio()
    self.filteredAudio:play()
end