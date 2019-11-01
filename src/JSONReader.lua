-- JSON File Format
-- {
--   "difficulty" : 3,
--   "background" : "artsy",
--   "palette" : {
--     "background" : [R, G, B, Alpha],
--     "background2" : [R, G, B, Alpha],
--     "gradient" : [R, G, B, Alpha],
--     "bgObjects" : [R, G, B, Alpha],
--     "menuText" : [R, G, B, Alpha],	
--     "scoreText" : [R, G, B, Alpha],
--     "laneColor" : [R, G, B, Alpha],
--     "pad1" : [R, G, B, Alpha],
--     "pad2" : [R, G, B, Alpha],
--     "menuColor" : [R, G, B, Alpha],
--     "healthColor" : [R, G, B, Alpha],
--     "noteColor" : [R, G, B, Alpha]
--   },
--   "title" : "Drop In, Flip Out",
--   "artist" : "Skelothan",
--   "album" : "Octave OST Vol. 1",
--   "source" : "Flip Flop",
--   "year" : 2019,
-- }
-- 
-- JSONReader converts JSON file to following format under self.data
-- Items left of = are table keys e.g. json.data[difficulty], json.data["palette"]["background"]
-- Palette Items stored as {R, G, B, Alpha}
-- {
--   palette = {
--     background2 = {
--     },
--     menuColor = {
--     },
--     healthColor = {
--     },
--     pad2 = {
--     },
--     noteColor = {
--     },
--     scoreText = {
--     },
--     pad1 = {
--     },
--     background = {
--     },
--     gradient = {
--     },
--     menuText = {
--       0,
--       0,
--       0,
--       1
--     },
--     laneColor = {
--     },
--     bgObjects = {
--     }
--   },
--   source = "Flip Flop",
--   title = "Drop In, Flip Out",
--   background = "artsy",
--   artist = "Skelothan",
--   album = "Octave OST Vol. 1",
--   difficulty = 3,
--   year = 2019
-- }

JSONReader = {}
JSONReader.__index = JSONReader

function JSONReader:init(filename)
  local o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

  assert(io.input(filename))
  self.data = json.decode(io.read("*all"))

  return table.deepcopy(o)
end

------------
-- This can be refactored
------------

-- Perhaps it should also take in the current file path, see comment below
function JSONReader:addScore(name, score)
  for i=1, #self.data.highscores do
    if self.data.highscores[i].score <= score then
      table.insert( self.data.highscores, i, { name = name, score = score} )
      break
    end
  end
  table.insert( self.data.highscores, { name = name, score = score })
  -- This should be rewritten to save to the current song's highscore json file
  io.output("highscores.json")
  io.write(json.encode(self.data))
end

return JSONReader