GameOverState = {}
GameOverState.__index = GameOverState

function GameOverState:init(params)
	local o = o or {}  
	setmetatable(o, self)
	self.__index = self
	setmetatable(GameOverState, BaseState)
	return table.deepcopy(o)
end

function GameOverState:enter(params)
	self.score = params.score or 0;
	self.backgroundColor = params.backgroundColor or {0, 0, 0, 1}
	self.textColor = params.textColor or {1, 1, 1, 1}
	self.isWon = params.isWon or false
end

function GameOverState:update(dt)
	if love.keyboard.wasInput("topArrow") then
		gStateMachine:change("menu", {})
	end
end

function GameOverState:render()
	love.graphics.setBackgroundColor(self.backgroundColor)
	love.graphics.setColor(self.textColor)
	
	if self.isWon then
		love.graphics.printf("You Win!", gFonts["AvenirLight64"], 0, love.graphics.getHeight() / 3, love.graphics.getWidth(), "center")
	else
		love.graphics.printf("Game Over", gFonts["AvenirLight64"], 0, love.graphics.getHeight() / 3, love.graphics.getWidth(), "center")
	end
	love.graphics.printf("Your Score: " .. self.score, gFonts["AvenirLight32"], 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")

end