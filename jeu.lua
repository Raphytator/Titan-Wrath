local jeu = {}

--[[
██╗███╗   ██╗██╗████████╗
██║████╗  ██║██║╚══██╔══╝
██║██╔██╗ ██║██║   ██║   
██║██║╚██╗██║██║   ██║   
██║██║ ╚████║██║   ██║   
╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   
                         
]]

local img = {}
local sprite = {}
local txt = {}

local titan = {}
local mid = _ecran.w / 2

function jeu.init()
    sprite.terrain = newSprite(love.graphics.newImage("img/terrain.png"), 0, 0)
    img.trouTerrain = love.graphics.newImage("img/trouTerrain.png")
    sprite.trouTerrain = newSprite(img.trouTerrain, (_ecran.w - img.trouTerrain:getWidth()) / 2, 235)

    
    img.titan = {}
    img.titan[1] = love.graphics.newImage("img/Titan2.png")
    img.titan[2] = love.graphics.newImage("img/Titan3.png")
    img.titan[3] = love.graphics.newImage("img/Titan1.png")
    img.titan[4] = img.titan[2]
    img.titan[5] = img.titan[1]

    sprite.titan = newSprite(img.titan[3], sprite.trouTerrain.x + img.titan[3]:getWidth() / 2, 40 + img.titan[3]:getHeight() / 2, 1, true)


    titan.cooldown1Max = 2.5
    titan.cooldown2Max = 5
    titan.cooldown3Max = 10
    titan.pvMax = 100
    

end 

--[[
██╗      ██████╗  █████╗ ██████╗ 
██║     ██╔═══██╗██╔══██╗██╔══██╗
██║     ██║   ██║███████║██║  ██║
██║     ██║   ██║██╔══██║██║  ██║
███████╗╚██████╔╝██║  ██║██████╔╝
╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
                                 
]]

function jeu.load()
    jeu.nouveauJeu()
end 

--[[
██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗
██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  
██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  
╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗
 ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
                                                  
]]

function jeu.update(dt)
    if not _fade.fadeIn and not _fade.fadeOut then
        local angleMouse
        local pi5 = math.pi / 5
        if _mouse.y >= 240 then 

            angleMouse = math.abs(math.angle(mid, 240, _mouse.x, _mouse.y))

            if angleMouse < pi5 then
                titan.direction = 1
            elseif angleMouse >= pi5 and angleMouse < pi5 * 2 then
                titan.direction = 2
            elseif angleMouse >= pi5 * 2 and angleMouse < pi5 * 3 then
                titan.direction = 3
            elseif angleMouse >= pi5 * 3 and angleMouse < pi5 * 4 then
                titan.direction = 4
            else 
                titan.direction = 5
            end
                        
        end 

        if titan.direction == 1 then
            titan.flip = -1
        elseif titan.direction == 2 then
            titan.flip = -1
        elseif titan.direction == 3 then
            titan.flip = 1
        elseif titan.direction == 4 then
            titan.flip = 1
        elseif titan.direction == 5 then
            titan.flip = 1
        end

        sprite.titan.img = img.titan[titan.direction]
        sprite.titan.sx = titan.flip
    end 
end 

--[[
██████╗ ██████╗  █████╗ ██╗    ██╗
██╔══██╗██╔══██╗██╔══██╗██║    ██║
██║  ██║██████╔╝███████║██║ █╗ ██║
██║  ██║██╔══██╗██╔══██║██║███╗██║
██████╔╝██║  ██║██║  ██║╚███╔███╔╝
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ 
                                  
]]

function jeu.draw()

    drawRectangle("fill", 0, 0, _ecran.w, _ecran.h, {.1, .5, .8, 1})
    sprite.terrain:draw()
    sprite.trouTerrain:draw()
    sprite.titan:draw()

end 

--[[
██╗  ██╗███████╗██╗   ██╗██████╗ ██████╗ ███████╗███████╗███████╗███████╗██████╗ 
██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██╔══██╗
█████╔╝ █████╗   ╚████╔╝ ██████╔╝██████╔╝█████╗  ███████╗███████╗█████╗  ██║  ██║
██╔═██╗ ██╔══╝    ╚██╔╝  ██╔═══╝ ██╔══██╗██╔══╝  ╚════██║╚════██║██╔══╝  ██║  ██║
██║  ██╗███████╗   ██║   ██║     ██║  ██║███████╗███████║███████║███████╗██████╔╝
╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═════╝ 
                                    
]]


function jeu.keypressed(key)

end

--[[
███████╗ ██████╗ ███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
██╔════╝██╔═══██╗████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
█████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
                                                                          
]]

function jeu.nouveauJeu()

    titan.direction = 3
    titan.pv = titan.pvMax
    titan.cooldown1 = 0
    titan.cooldown2 = 0
    titan.cooldown3 = 0
    titan.flip = 1

    fadeIn()
end

return jeu