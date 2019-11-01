-- A non-recursive deep copy function.
require "lib/deepcopy"

require "src/helpers"
require "src/collision"

-- A class library. I don't think we'll use it, but it's here just in case.
-- Class = require "lib/class"

-- The MIDI library
MIDI = require 'lib/MIDI'

-- The JSON library
json = require 'lib/json'

-- Contains asset-loading functions used in love.load().
require "src/loadassets"

-- Audio player
require "src/AudioPlayer"

-- MIDI Reader
require "src/MidiReader"

-- JSON Reader
require "src/JSONReader"

-- Palette
require "src/palettedefs"

-- Menu State things
require "src/Song"

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
require "src/states/GameOverState"

-- Backgrounds
require "src/backgrounddefs"
require "src/Background"
