-- A non-recursive deep copy function.
require "lib/deepcopy"

require "src/helpers"
require "src/collision"
require "lib/comma_value"

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

-- Submenu system
require "src/Submenu"

-- Palette
require "src/palettedefs"

-- Menu State menu system
require "src/Song"

-- Play State things
require "src/states/PlayStateObjects/Pad"
require "src/states/PlayStateObjects/Lane"
require "src/states/PlayStateObjects/Note"
require "src/states/PlayStateObjects/HealthBar"
require "src/states/PlayStateObjects/TextEffect"

-- State machine stuff
require "src/states/BaseState"
require "src/states/StateMachine"
require "src/states/TitleState"
require "src/states/MenuState"
require "src/states/PlayState"
require "src/states/GameOverState"
require "src/states/CreditsState"
require "src/states/PlayDemoState"

-- Backgrounds
require "src/backgrounddefs"
require "src/Background"
