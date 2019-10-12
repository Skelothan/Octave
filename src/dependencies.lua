-- A non-recursive deep copy function.
require "lib/deepcopy"

require "src/helpers"
require "src/collision"

-- A class library. I don't think we'll use it, but it's here just in case.
-- Class = require "lib/class"

-- Contains asset-loading functions used in love.load().
require "src/loadassets"

-- Contains constants
require "src/constants"

-- Audio player
require "src/AudioPlayer"

-- Play State things
require "src/states/PlayStateObjects/Pad"
require "src/states/PlayStateObjects/Lane"
require "src/states/PlayStateObjects/Note"
require "src/states/PlayStateObjects/HealthBar"

-- State machine stuff
require "src/states/BaseState"
require "src/states/StateMachine"
require "src/states/TitleState"
require "src/states/MenuState"
require "src/states/PlayState"

-- Backgrounds
require "src/backgrounddefs"
require "src/Background"