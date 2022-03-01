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
local spriteQuad = {}
local txt = {}

local titan = {}
local mid = _ecran.w / 2

function jeu.init()
    sprite.terrain = newSprite(love.graphics.newImage("img/terrain.png"), 0, 0)
    img.trouTerrain = love.graphics.newImage("img/trouTerrain.png")
    sprite.trouTerrain = newSprite(img.trouTerrain, (_ecran.w - img.trouTerrain:getWidth()) / 2, 235)

    img.boutonCompetence = love.graphics.newImage("img/btnCompetence.png")
    
    local yBtnComp = (212 - (64 + 5)*3) / 2
    sprite.competence = {}
    sprite.competence[1] = newSprite(love.graphics.newImage("img/Competence1.png"), 5, yBtnComp)
    sprite.competence[2] = newSprite(love.graphics.newImage("img/Competence2.png"), 5, sprite.competence[1].y + 64 + 5)
    sprite.competence[3] = newSprite(love.graphics.newImage("img/Competence3.png"), 5, sprite.competence[2].y + 64 + 5)

    txt.competences = {}
    txt.competences[1] = newTxt("clicGauche", _fonts.texte, sprite.competence[1].x + 75, sprite.competence[1].y + 10)
    txt.competences[2] = newTxt("clicDroit", _fonts.texte, sprite.competence[2].x + 75, sprite.competence[2].y + 10)
    txt.competences[3] = newTxt("barreEspace", _fonts.texte, sprite.competence[3].x + 75, sprite.competence[3].y + 10)

    img.receptacleSante = love.graphics.newImage("img/receptacleSante.png")
    sprite.receptacleSante = newSprite(img.receptacleSante, (_ecran.w - img.receptacleSante:getWidth()) / 2, 25)
    spriteQuad.barreSante = newQuadSprite(love.graphics.newImage("img/barreSante.png"), sprite.receptacleSante.x, sprite.receptacleSante.y)


    -- =====
    -- TITAN
    -- =====
    
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
    titan.pvMax = 500
    

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
        local posY = 265
        if _mouse.y >= posY then 

            angleMouse = math.abs(math.angle(mid, posY, _mouse.x, _mouse.y))

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

        -- Santé Titan
        spriteQuad.barreSante:update((spriteQuad.barreSante.img:getWidth() / titan.pvMax) * titan.pv)
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


    sprite.receptacleSante:draw()
    spriteQuad.barreSante:draw()

    for i=1, #sprite.competence do 
        local sp = sprite.competence[i]
        love.graphics.draw(img.boutonCompetence, sp.x, sp.y)
        sp:draw()
        txt.competences[i]:print()
    end
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
    if key == "up" then 
        if titan.pv < titan.pvMax then titan.pv = titan.pv + 10 end 
    elseif key == "down" then 
        if titan.pv > 0 then titan.pv = titan.pv - 10 end
    end 

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