--[[
State Machine

Code taken and modified from Harvard CS50's Game Development course
which in turn was taken and modified from http://howtomakeanrpg.com 

]]

StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine:init(states)
	local stmchn = {}
	setmetatable(stmchn, self)
	self.__index = self
	
	self.empty = BaseState:init()
	self.states = states or {}
	self.current = self.empty
	return stmchn
end

function StateMachine:change(stateName, params)
	print("Changing to state " .. stateName)
	assert(self.states[stateName])
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(params)
end

function StateMachine:update()
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end
