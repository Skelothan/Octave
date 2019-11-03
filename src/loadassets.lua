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
		["back"] = love.audio.newSource("sfx/back.mp3", "static"),
		["noteHit"] = love.audio.newSource("sfx/note_hit.wav", "static"),
		["noteMiss"] = love.audio.newSource("sfx/note_miss.wav", "static"),
		["scroll"] =  love.audio.newSource("sfx/scroll.wav", "static"),
		["select"]= love.audio.newSource("sfx/select.wav", "static"),
		["start"] = love.audio.newSource("sfx/start.wav", "static"),
		["startExt"] = love.audio.newSource("sfx/start_ext.mp3", "static")
	}
end 

function loadImages()
	gImages = {
		["damage"] = love.graphics.newImage("graphics/damageVignette.png")
	
	
	
	
	}
end
-- TODO: functions for frames, sfx, etc