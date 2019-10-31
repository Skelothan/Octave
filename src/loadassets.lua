function loadFonts()
	gFonts = {
		["AvenirLight16"] = love.graphics.newFont("fonts/Avenir-Light-07.ttf", 16),
		["AvenirLight24"] = love.graphics.newFont("fonts/Avenir-Light-07.ttf", 24),
		["AvenirLight32"] = love.graphics.newFont("fonts/Avenir-Light-07.ttf", 32),
		["AvenirLight64"] = love.graphics.newFont("fonts/Avenir-Light-07.ttf", 64)
	}
	love.graphics.setFont(gFonts["AvenirLight32"])
end

-- TODO: functions for images, frames, sfx, etc