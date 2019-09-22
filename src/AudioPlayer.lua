AudioPlayer = {}
AudioPlayer.__index = AudioPlayer

function AudioPlayer:init()
    local o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end