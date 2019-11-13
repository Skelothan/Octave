Background = {}
Background.__index = Background

function Background:init(backgroundName)
	-- print(funcs)
	
	local o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	
	self:setFunctions(backgroundName or "oscCircle")
	self:init2()
	
	return table.deepcopy(o)
	--return o
end

function Background:setFunctions(backgroundName)
	self.init2 = gBackgroundDefs[backgroundName].init2 or gBackgroundDefs["oscCircle"].init2
	self.update = gBackgroundDefs[backgroundName].update or gBackgroundDefs["oscCircle"].update
	self.render = gBackgroundDefs[backgroundName].render or gBackgroundDefs["oscCircle"].render
end


function Background:init2() end
function Background:update(dt) end
function Background:render() end