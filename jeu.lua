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
local tween = {}
local btn = {}

local titan = {}
local mid = _ecran.w / 2
local alphaVoile
local departGameOver
local vague = {}



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

    txt.vague = newTxt("vague", _fonts.gameOver, 0, 300, {.1, .1, .1, 0}, _ecran.w, "center")

    -- =====
    -- TITAN
    -- =====

    titan.etats = {
        STAND = 1,
        POING = 2,
        VAGUE = 3,
        QUAKE = 4,
        DEAD = 5
    }
    
    img.titan = {}
    img.titan[titan.etats.STAND] = {
        [1] = { love.graphics.newImage("img/Titan2.png") },
        [2] = { love.graphics.newImage("img/Titan3.png") },
        [3] = { love.graphics.newImage("img/Titan1.png") },
        [4] = { love.graphics.newImage("img/Titan3.png") },
        [5] = { love.graphics.newImage("img/Titan2.png") }
    }

    img.titan[titan.etats.POING] = {
        [1] = { love.graphics.newImage("img/Titan2Competence1Frame1.png"), love.graphics.newImage("img/Titan2Competence1Frame2.png")},
        [2] = { love.graphics.newImage("img/Titan3Competence1Frame1.png"), love.graphics.newImage("img/Titan3Competence1Frame2.png") },
        [3] = { love.graphics.newImage("img/Titan1Competence1Frame1.png"), love.graphics.newImage("img/Titan1Competence1Frame2.png") },
        [4] = { love.graphics.newImage("img/Titan3Competence1Frame1.png"), love.graphics.newImage("img/Titan3Competence1Frame2.png") },
        [5] = { love.graphics.newImage("img/Titan2Competence1Frame1.png"), love.graphics.newImage("img/Titan2Competence1Frame2.png") }
    }

    img.titan[titan.etats.VAGUE] = {
        [1] = { love.graphics.newImage("img/Titan2Competence2Frame1.png"), love.graphics.newImage("img/Titan2Competence2Frame2.png")},
        [2] = { love.graphics.newImage("img/Titan3Competence2Frame1.png"), love.graphics.newImage("img/Titan3Competence2Frame2.png") },
        [3] = { love.graphics.newImage("img/Titan1Competence2Frame1.png"), love.graphics.newImage("img/Titan1Competence2Frame2.png") },
        [4] = { love.graphics.newImage("img/Titan3Competence2Frame1.png"), love.graphics.newImage("img/Titan3Competence2Frame2.png") },
        [5] = { love.graphics.newImage("img/Titan2Competence2Frame1.png"), love.graphics.newImage("img/Titan2Competence2Frame2.png") }
    }

    img.titan[titan.etats.QUAKE] = {
        [1] = { love.graphics.newImage("img/Titan1Competence3Frame1.png"), love.graphics.newImage("img/Titan1Competence3Frame2.png")}
    }

    img.titan[titan.etats.DEAD] = {
        [1] = {
            love.graphics.newImage("img/TitanDead1.png"),
            love.graphics.newImage("img/TitanDead2.png")
        }
    }

    sprite.titan = newSprite(img.titan[1][1][1], sprite.trouTerrain.x + img.titan[1][1][1]:getWidth() / 2, 40 + img.titan[1][1][1]:getHeight() / 2, 1, true)

    titan.cooldown1Max = 2.5
    titan.cooldown2Max = 5
    titan.cooldown3Max = 10
    titan.pvMax = 500
    

    -- =========
    -- Game over
    -- =========
    departGameOver = 0 - _fonts.gameOver:getHeight("W") - 10
    txt.gameOver = newTxt("gameOver", _fonts.gameOver, 0, departGameOver, {.8,.8,.8,1}, _ecran.w, "center")
    tween.gameOver = newTween(departGameOver, 400, 2)
    local xBtn = (_ecran.w - _img.btn:getWidth()) / 2
    local yBtn = 400
    btn.rejouer = newBtn("img", xBtn, yBtn, _img.btn, _img.btnHover, _img.btnPressed, "recommencer")
    btn.menuPrincipal = newBtn("img", xBtn, btn.rejouer.y + _img.btn:getHeight() + 10, _img.btn, _img.btnHover, _img.btnPressed, "menuPrincipal")

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
        if _etatActu == "jeu" then 

            -- Direction du Titan
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

            sprite.titan.sx = titan.flip
             
            if vague.affichage then 
                local vitesseAlpha = .5
                if vague.etat == "apparition" then
                    if vague.alpha < 1 then 
                        vague.alpha = vague.alpha + dt / vitesseAlpha
                        txt.vague.color[4] = vague.alpha
                    else 
                        vague.etat = "standBy"
                    end 
                elseif vague.etat == "standBy" then 
                    if vague.timer < 2.5 then 
                        vague.timer = vague.timer + dt
                    else 
                        vague.etat = "disparition"
                    end 
                elseif vague.etat == "disparition" then 
                    if vague.alpha > 0 then 
                        vague.alpha = vague.alpha - dt / vitesseAlpha
                        txt.vague.color[4] = vague.alpha
                    else 
                        vague.affichage = false
                    end 
                end                
            else 

                -- Santé Titan
                spriteQuad.barreSante:update((spriteQuad.barreSante.img:getWidth() / titan.pvMax) * titan.pv)

                -- Gameover
                if titan.pv <= 0 then 
                    changeEtat("gameOver")
                    titan.etat = titan.etats.DEAD
                    titan.frame = 1
                    titan.direction = 1
                    titan.vitesseFrame = 3
                end             

                -- Compétences 
                if titan.competenceActive then
                    if titan.frame > #img.titan[titan.direction][titan.etat] then 
                        titan.competenceActive = false 
                        titan.frame = 1
                        titan.etat = titan.etats.STAND
                    end 
                end 

                -- Vagues de soldats

                -- Comportement soldats 

                -- Vaches 


            end 

        elseif _etatActu == "gameOver" then 
            tween.gameOver:update(dt)
            txt.gameOver.y = tween.gameOver.actu

            

            if alphaVoile < .7 then 
                alphaVoile = alphaVoile + dt / tween.gameOver.duree * .7
            end

            if tween.gameOver.finished then 
                btn.rejouer:update(fadeOut, {"restart"})
                btn.menuPrincipal:update(fadeOut, {"menuPrincipal"})
            end
        end

        if titan.frame < #img.titan[titan.etat][titan.direction] then titan.frame = titan.frame + dt * titan.vitesseFrame end
        sprite.titan.img = img.titan[titan.etat][titan.direction][math.floor(titan.frame)]
    end 

    if _fade.fadeEnd then 
        _fade.fadeEnd = false 
        _fade.alphaTransition = 0

        if _fade.sortie == "restart" then 
            jeu.nouveauJeu()
        elseif _fade.sortie == "menuPrincipal" then
            changeScene(_scenes.menuPrincipal)
            changeEtat("menuPrincipal")
        elseif _fade.sortie == "victory" then
            
        end 
        fadeIn()
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

    if vague.affichage then 
        txt.vague:print()
    end 

    if _etatActu == "gameOver" then 
        drawVoile(alphaVoile)
        txt.gameOver:print()

        if tween.gameOver.finished then 
            btn.rejouer:draw()
            btn.menuPrincipal:draw()
        end
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
    if key == "space" then 

        if not vague.affichage and not titan.competenceActive and _etatActu == "jeu" then
            titan.competenceActive = true
            jeu.activeCompetence(titan.etats.QUAKE)
        end

    elseif key == "down" then 
        titan.pv = titan.pv - 250
    end 
end

--[[
███╗   ███╗ ██████╗ ██╗   ██╗███████╗███████╗██████╗ ██████╗ ███████╗███████╗███████╗███████╗██████╗ 
████╗ ████║██╔═══██╗██║   ██║██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██╔══██╗
██╔████╔██║██║   ██║██║   ██║███████╗█████╗  ██████╔╝██████╔╝█████╗  ███████╗███████╗█████╗  ██║  ██║
██║╚██╔╝██║██║   ██║██║   ██║╚════██║██╔══╝  ██╔═══╝ ██╔══██╗██╔══╝  ╚════██║╚════██║██╔══╝  ██║  ██║
██║ ╚═╝ ██║╚██████╔╝╚██████╔╝███████║███████╗██║     ██║  ██║███████╗███████║███████║███████╗██████╔╝
╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═════╝ 
                                                                                                     
]]

function jeu.mousepressed(x, y, button, istouch, presses)

    if not vague.affichage and not titan.competenceActive and _etatActu == "jeu" then
        titan.competenceActive = true
        
        if button == 1 then 
            jeu.activeCompetence(titan.etats.POING)
        elseif button == 2 then 
            jeu.activeCompetence(titan.etats.VAGUE)
        end
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
    titan.etat = titan.etats.STAND
    titan.frame = 1
    titan.vitesseFrame = 1.5
    titan.competenceActive = false
    sprite.titan.img = img.titan[titan.etat][titan.direction][titan.frame]
    spriteQuad.barreSante:update((spriteQuad.barreSante.img:getWidth() / titan.pvMax) * titan.pv) -- Santé Titan

    tween.gameOver:reset()
    txt.gameOver.y = departGameOver

    vague.actu = 1

    jeu.lancementVague()

    alphaVoile = 0
    changeEtat("jeu")
    fadeIn()
end

function jeu.lancementVague()
    vague.affichage = true
    vague.etat = "apparition"
    vague.alpha = 0
    vague.timer = 0
    txt.vague.txtSup = " "..vague.actu
    txt.vague.color[4] = 0
end 

function jeu.activeCompetence(pComp)

    titan.etat = pComp
    titan.frame = 1

end 

return jeu