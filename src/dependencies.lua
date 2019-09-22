-- A non-recursive deep copy function.
require "lib/deepcopy"

-- A class library. I don't think we'll use it, but it's here just in case.
-- Class = require "lib/class"

-- Contains asset-loading functions used in love.load().
require "src/loadassets"

-- State machine stuff
require "src/states/BaseState"
require "src/states/StateMachine"
require "src/states/TitleState"
require "src/states/MenuState"

-- Backgrounds
require "src/backgrounddefs"
require "src/Background"

require "src/AudioPlayer"