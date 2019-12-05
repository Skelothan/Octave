function loadFonts()
	gFonts = {
		["AvenirLight16"] = love.graphics.newFont("fonts/Avenir-Light-07.ttf", 16),
		["AvenirMedium16"] = love.graphics.newFont("fonts/Avenir-Medium-09.ttf", 16),
		["AvenirLight24"] = love.graphics.newFont("fonts/Avenir-Light-07.ttf", 24),
		["AvenirLight32"] = love.graphics.newFont("fonts/Avenir-Light-07.ttf", 32),
		["AvenirLight64"] = love.graphics.newFont("fonts/Avenir-Light-07.ttf", 64)
	}
	love.graphics.setFont(gFonts["AvenirLight32"])
end

function loadSounds()
	gSounds = {
		["back"] = love.audio.newSource("sfx/back.mp3", "static"),
		["damage"] = love.audio.newSource("sfx/hurt.wav", "static"),
		["noteHitPerfect"] = love.audio.newSource("sfx/note_hit_5.wav", "static"),
		["noteHitGreat"] = love.audio.newSource("sfx/note_hit_2.wav", "static"),
		["noteHitGood"] = love.audio.newSource("sfx/note_hit_3.wav", "static"),
		["noteHitOk"] = love.audio.newSource("sfx/note_hit_1.wav", "static"),
		["noteMiss"] = love.audio.newSource("sfx/note_miss.wav", "static"),
		["scroll"] =  love.audio.newSource("sfx/scroll.wav", "static"),
		["select"]= love.audio.newSource("sfx/select.wav", "static"),
		["start"] = love.audio.newSource("sfx/start.wav", "static"),
		["startExt"] = love.audio.newSource("sfx/start_ext.mp3", "static"),
		["victory"] = love.audio.newSource("sfx/you_win.wav", "static")
	}
end 

function loadMenuMusic()
	gMenuMusic = love.audio.newSource("sfx/Welcome_to_Octave.wav", "stream")
end

-- TODO: functions for images, frames, sfx, etc
