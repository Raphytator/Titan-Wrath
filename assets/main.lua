local _WIDTH, _HEIGHT = love.graphics.getWidth(), love.graphics.getHeight()
local ox, oy = _WIDTH/2, _HEIGHT/2

local PI = math.pi
local COS = math.cos
local SIN = math.sin

local radius = 200

local nbSoldier = 10

local soldiers = {}

love.draw = function()
  love.graphics.circle("fill", ox, oy, )
end