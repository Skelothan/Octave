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
	
	if not gBackgroundNames[backgroundName] then backgroundName = "spinTriangle" end
	
	self.init2 = gBackgroundDefs[backgroundName].init2 or function() end
	self.update = gBackgroundDefs[backgroundName].update or function() end
	self.render = gBackgroundDefs[backgroundName].render or function() end
end


function Background:init2() end
function Background:update(dt) end
function Background:render() end