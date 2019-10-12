Background = {}
Background.__index = Background

function Background:init(backgroundName, paletteName)
	-- print(funcs)
	
	local o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	
	print(type(o))
	self:setFunctions(backgroundName or "oscCircle")
	self:setPalette(paletteName or "standard")
	self:init2()
	print(type(o))
	
	return table.deepcopy(o)
	--return o
end

function Background:setFunctions(backgroundName)
	self.init2 = gBackgroundDefs[backgroundName].init2 or gBackgroundDefs["oscCircle"].init2
	self.update = gBackgroundDefs[backgroundName].update or gBackgroundDefs["oscCircle"].update
	self.render = gBackgroundDefs[backgroundName].render or gBackgroundDefs["oscCircle"].render
end

function Background:setPalette(paletteName)
	currentPalette = paletteName
end 

function Background:init2() end
function Background:update(dt) end
function Background:render() end