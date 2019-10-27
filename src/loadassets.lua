function loadFonts()
	gFonts = {
		["AvenirLight16"] = love.graphics.newFont("fonts/Avenir-Light-07.ttf", 16),
		["AvenirLight32"] = love.graphics.newFont("fonts/Avenir-Light-07.ttf", 32),
		["AvenirLight64"] = love.graphics.newFont("fonts/Avenir-Light-07.ttf", 64)
	}
	love.graphics.setFont(gFonts["AvenirLight32"])
end

function loadSounds()
	gSounds = {
		["scroll"] =  love.audio.newSource("sfx/scroll.wav", "static"),
		["select"]= love.audio.newSource("sfx/select.wav", "static"),
		["start"] = love.audio.newSource("sfx/start.wav", "static"),
		["startExt"] = love.audio.newSource("sfx/start_ext.mp3", "static"),
		["back"] = love.audio.newSource("sfx/back.mp3", "static")
	}
end 
-- TODO: functions for images, frames, sfx, etc