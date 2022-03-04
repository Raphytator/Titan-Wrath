local jeu = {}

--[[
██╗███╗   ██╗██╗████████╗
██║████╗  ██║██║╚══██╔══╝
██║██╔██╗ ██║██║   ██║   
██║██║╚██╗██║██║   ██║   
██║██║ ╚████║██║   ██║   
╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   
                         
]]
local stats = require("stats")
local shockwave = require("shockwave")

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
local soldats = {}

local shake = { actif = false, cx = 0, cy = 0 }


local timerShader = 0
local activeShader = false

function jeu.init()
    shockwave.init()
    --sprite.terrain = newSprite(love.graphics.newImage("img/terrain.png"), -100, -50)
    sprite.terrain = newSprite(love.graphics.newImage("img/terrain.png"), 0, 0)
    

    img.boutonCompetence = love.graphics.newImage("img/btnCompetence.png")
    
    local yBtnComp = (212 - (64 + 5)*3) / 2
    sprite.competence = {}
    sprite.competence[1] = newSprite(love.graphics.newImage("img/Competence1.png"), 5, yBtnComp)
    sprite.competence[2] = newSprite(love.graphics.newImage("img/Competence2.png"), 5, sprite.competence[1].y + 64 + 5)
    sprite.competence[3] = newSprite(love.graphics.newImage("img/Competence3.png"), 5, sprite.competence[2].y + 64 + 5)

    img.mouseLeft = love.graphics.newImage("img/mouseLeft.png")
    img.mouseRight = love.graphics.newImage("img/mouseRight.png")
    img.spacebar = love.graphics.newImage("img/spacebar.png")

    sprite.commandes = {}
    sprite.commandes[1] = newSprite(img.mouseLeft, sprite.competence[1].x + 75 + (img.spacebar:getWidth() - img.mouseLeft:getWidth()) / 2, sprite.competence[1].y + (sprite.competence[1].img:getHeight() - img.mouseLeft:getHeight()) / 2)
    sprite.commandes[2] = newSprite(img.mouseRight, sprite.competence[2].x + 75 + (img.spacebar:getWidth() - img.mouseRight:getWidth()) / 2, sprite.competence[2].y + (sprite.competence[2].img:getHeight() - img.mouseRight:getHeight()) / 2)
    sprite.commandes[3] = newSprite(img.spacebar, sprite.competence[3].x + 75, sprite.competence[3].y + (sprite.competence[3].img:getHeight() - img.spacebar:getHeight()) / 2)
    txt.spacebar = newTxt("barreEspace", _fonts.mini, sprite.commandes[3].x, sprite.commandes[3].y + (img.spacebar:getHeight() - _fonts.mini:getHeight("W")) / 2, {0,0,0,1}, sprite.commandes[3].img:getWidth(), "center")


    img.receptacleSante = love.graphics.newImage("img/receptacleSante.png")
    sprite.receptacleSante = newSprite(img.receptacleSante, (_ecran.w - img.receptacleSante:getWidth()) / 2, 15)
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
    
    img.titanIdle = {
        love.graphics.newImage("img/Titan1.png"),        
        love.graphics.newImage("img/Titan2.png"),        
        love.graphics.newImage("img/Titan3.png")
    }

    img.titanCompetencesFrame2 = love.graphics.newImage("img/CompetencesFrame1.png")

    img.titanCompetences = {
        [1] = {
            [1] = love.graphics.newImage("img/Titan1Competence1Frame2.png"),
            [2] = love.graphics.newImage("img/Titan2Competence1Frame2.png"),
            [3] = love.graphics.newImage("img/Titan3Competence1Frame2.png")
        },
        [2] = {
            [1] = love.graphics.newImage("img/Titan1Competence2Frame2.png"),
            [2] = love.graphics.newImage("img/Titan2Competence2Frame2.png"),
            [3] = love.graphics.newImage("img/Titan3Competence2Frame2.png")
        }
    }

    img.titan = {}
    img.titan[titan.etats.STAND] = {
        [1] = { img.titanIdle[3] },
        [2] = { img.titanIdle[2] },
        [3] = { img.titanIdle[1] },
        [4] = { img.titanIdle[2] },
        [5] = { img.titanIdle[3] }
    }

    img.titan[titan.etats.POING] = {
        [1] = { img.titanCompetencesFrame2, img.titanCompetences[1][3]},
        [2] = { img.titanCompetencesFrame2, img.titanCompetences[1][2] },
        [3] = { img.titanCompetencesFrame2, img.titanCompetences[1][1] },
        [4] = { img.titanCompetencesFrame2, img.titanCompetences[1][2] },
        [5] = { img.titanCompetencesFrame2, img.titanCompetences[1][3] }
    }

    img.titan[titan.etats.VAGUE] = {
        [1] = { img.titanCompetencesFrame2, img.titanCompetences[2][3]},
        [2] = { img.titanCompetencesFrame2, img.titanCompetences[2][2] },
        [3] = { img.titanCompetencesFrame2, img.titanCompetences[2][1] },
        [4] = { img.titanCompetencesFrame2, img.titanCompetences[2][2] },
        [5] = { img.titanCompetencesFrame2, img.titanCompetences[2][3] }
    }

    img.titan[titan.etats.QUAKE] = {
        [1] = { img.titanCompetencesFrame2, love.graphics.newImage("img/Competence3Frame2.png")}
    }

    img.titan[titan.etats.DEAD] = {
        [1] = {
            love.graphics.newImage("img/TitanDead1.png"),
            love.graphics.newImage("img/TitanDead2.png")
        }
    }

    img.trouTerrain = love.graphics.newImage("img/trouTerrain.png")
    sprite.trouTerrain = newSprite(img.trouTerrain, (_ecran.w - img.trouTerrain:getWidth()) / 2, 40)

    sprite.titan = newSprite(img.titan[1][1][1], sprite.trouTerrain.x + img.titan[1][1][1]:getWidth() / 2, sprite.trouTerrain.y + img.titan[1][1][1]:getHeight() / 2, 1, true)

    

    titan.cooldown = {
        [titan.etats.POING] = { actu = 0, max = 1.5, y = 0, h = 64},
        [titan.etats.VAGUE] = { actu = 0, max = 5, y = 0, h = 64},
        [titan.etats.QUAKE] = { actu = 0, max = 10, y = 0, h = 64},
    }
   
    initSoldats()

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
            
            shockwave.update(dt)

            -- Direction du Titan
            local angleMouse
            local pi5 = math.pi / 5
            local posY = 265
            if _mouse.y >= posY then 

                angleMouse = math.abs(math.angle(mid, posY, _mouse.x, _mouse.y))

                if not titan.competenceActive then 
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
                if _toucheTitan then 
                    _toucheTitan = false
                    titan.pv = titan.pv - _degatsTitan
                    if titan.pv < 0 then titan.pv = 0 end
                end

                spriteQuad.barreSante:update((spriteQuad.barreSante.img:getWidth() / stats.pvMaxTitan) * titan.pv)

                -- Gameover
                if titan.pv <= 0 then 
                    changeEtat("gameOver")
                    jeu.resetShake()
                    titan.etat = titan.etats.DEAD
                    titan.frame = 1
                    titan.direction = 1
                    titan.vitesseFrame = 3
                end         
                
                -- Compétences 
                if titan.competenceActive then
                    if titan.frame > #img.titan[titan.etat][titan.direction] then 
                        
                        titan.timerFinCompetence = titan.timerFinCompetence + dt 
                        if titan.timerFinCompetence > .2 then 
                            titan.timerFinCompetence = 0
                            titan.nbCoups = titan.nbCoups + 1 
                            titan.frame = 1
                            jeu.effetCompetence(titan.etat)
                            if titan.nbCoups >= titan.nbCoupsMax then   
                                titan.cooldown[titan.etat].actu = titan.cooldown[titan.etat].max                
                                titan.competenceActive = false                                
                                titan.etat = titan.etats.STAND                              
                            end
                        end                        
                    end 
                end 

                if activeShader then 
                    timerShader = timerShader + dt
                    if timerShader >= .8 then 
                        timerShader = 0
                        activeShader = false
                        
                    end
                end

                -- Cooldowns
                jeu.updateCooldown(titan.etats.POING, dt)
                jeu.updateCooldown(titan.etats.VAGUE, dt)
                jeu.updateCooldown(titan.etats.QUAKE, dt)
                
                -- Shakes
                jeu.updateShake(dt)

                -- Vagues de soldats
                if vague.spawnedSoldiers < stats.nbSoldats[vague.actu] then 
                    vague.spawnSoldiersTimer = vague.spawnSoldiersTimer + dt 
                    if vague.spawnSoldiersTimer >= vague.spawnSoldiersTimerMax then 
                        jeu.spawnSoldiers()
                    end 
                end 
 
                -- Soldats
                for i=1, #soldats do 
                    soldats[i]:update(dt)
                end 

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

        if titan.frame <= #img.titan[titan.etat][titan.direction] then titan.frame = titan.frame + dt * titan.vitesseFrame end
        if math.floor(titan.frame) <= #img.titan[titan.etat][titan.direction] then
            sprite.titan.img = img.titan[titan.etat][titan.direction][math.floor(titan.frame)]
        end

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

    love.graphics.push()
    love.graphics.translate(shake.cx, shake.cy)
    
    shockwave.draw()    
    sprite.terrain:draw()
    love.graphics.setShader()
    sprite.trouTerrain:draw()
    sprite.titan:draw()

    -- Soldats
    for i=1, #soldats do 
        soldats[i]:draw()
    end 

    love.graphics.pop()

    -- Affichage de la santé
    sprite.receptacleSante:draw()
    spriteQuad.barreSante:draw()

    -- Affichage des compétences
    for i=1, #sprite.competence do 
        local sp = sprite.competence[i]
        love.graphics.draw(img.boutonCompetence, sp.x, sp.y)
        sp:draw()
        sprite.commandes[i]:draw()
    end
    txt.spacebar:print()

    -- Affichage des cooldown
    if titan.cooldown[titan.etats.POING].actu > 0 then drawRectangle("fill", sprite.competence[1].x, titan.cooldown[titan.etats.POING].y, 64, titan.cooldown[titan.etats.POING].h, {0,0,0,.6}) end 
    if titan.cooldown[titan.etats.VAGUE].actu > 0 then drawRectangle("fill", sprite.competence[2].x, titan.cooldown[titan.etats.VAGUE].y, 64, titan.cooldown[titan.etats.VAGUE].h, {0,0,0,.6}) end 
    if titan.cooldown[titan.etats.QUAKE].actu > 0 then drawRectangle("fill", sprite.competence[3].x, titan.cooldown[titan.etats.QUAKE].y, 64, titan.cooldown[titan.etats.QUAKE].h, {0,0,0,.6}) end 

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
            if titan.cooldown[titan.etats.QUAKE].actu == 0 then 
                jeu.activeCompetence(titan.etats.QUAKE)
            end
        end
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
        if button == 1 then 
            if titan.cooldown[titan.etats.POING].actu == 0 then 
                jeu.activeCompetence(titan.etats.POING)
            end
        elseif button == 2 then 
            if titan.cooldown[titan.etats.VAGUE].actu == 0 then 
                jeu.activeCompetence(titan.etats.VAGUE)
            end
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
    titan.pv = stats.pvMaxTitan
    titan.cooldown[titan.etats.POING].actu = 0
    titan.cooldown[titan.etats.VAGUE].actu = 0
    titan.cooldown[titan.etats.QUAKE].actu = 0
    titan.flip = 1
    titan.etat = titan.etats.STAND
    titan.frame = 1
    titan.vitesseFrame = 1.5
    titan.timerFinCompetence = 0
    titan.competenceActive = false
    sprite.titan.img = img.titan[titan.etat][titan.direction][titan.frame]
    spriteQuad.barreSante:update((spriteQuad.barreSante.img:getWidth() / stats.pvMaxTitan) * titan.pv) -- Santé Titan

    tween.gameOver:reset()
    txt.gameOver.y = departGameOver

    for i=1, #sprite.commandes do sprite.commandes[i].alpha = 1 end 
    txt.spacebar.color = {0,0,0,1}

    vague.actu = 1
    soldats = {}

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

    vague.spawnSoldiersTimer = 0
    vague.spawnSoldiersTimerMax = 0
    vague.spawnedSoldiers = 0
end 

function jeu.spawnSoldiers()
    vague.spawnSoldiersTimer = 0
    vague.spawnSoldiersTimerMax = love.math.random(3, 6)
    vague.spawnedSoldiers = vague.spawnedSoldiers + 1

    local nb = love.math.random(0, 100)
    local nbSpawn
    if nb <= 55 then nbSpawn = 1
    elseif nb <= 75 then nbSpawn = 2
    else nbSpawn = 3 end 
    
    for i=1, nbSpawn do 
        local soldatsTMP = newSoldats()
        table.insert(soldats, soldatsTMP)
    end
end 

function jeu.activeCompetence(pComp)

    titan.competenceActive = true
    titan.etat = pComp
    titan.frame = 1
    titan.nbCoups = 0
    titan.nbCoupsMax = 1

    if pComp == titan.etats.POING then
        titan.vitesseFrame = 7   
    elseif pComp == titan.etats.VAGUE then
        titan.vitesseFrame = 5  
    elseif pComp == titan.etats.QUAKE then
        titan.vitesseFrame = 5
        titan.nbCoupsMax = 4
        titan.direction = 1        
    end

    titan.cooldown[pComp].y = sprite.competence[pComp - 1].y + 64
    titan.cooldown[pComp].h = -64
end 

function jeu.effetCompetence(pComp)
    local titanX = _ecran.w / 2
    local titanY = 265
    local tabDirection = { titan.direction }

    shake.actif = true
    if pComp == titan.etats.POING then        
        shake.val = 1
    elseif pComp == titan.etats.VAGUE then
        shake.val = 2
        shockwave.launch(false, titan.direction)        
        activeShader = true
    elseif pComp == titan.etats.QUAKE then
        shake.val = 3
        txt.spacebar.color = {0,0,0,.3}
        tabDirection = {1,2,3,4,5}
        shockwave.launch(true)
        activeShader = true
    end

    sprite.commandes[pComp - 1].alpha = .3

    -- Dégats aux soldats
    for i=#soldats, 1, -1 do 
        local s = soldats[i]
        if inArray(tabDirection, s.direction) then 
            local distanceSoldats = distance(titanX, titanY, s.position.x, s.position.y)
            
            if distanceSoldats < 450 then 

                -- TESTS POUR DEBUG
                table.remove(soldats, i)

                if #soldats == 0 then jeu.vagueSuivante() end 
            end 
        end 
    end 
end 

function jeu.vagueSuivante()
    vague.actu = vague.actu + 1
    if vague.actu <= 10 then 
        jeu.lancementVague()
    else 
        -- VICTOIRE
        
    end 
end 

function jeu.updateCooldown(pComp, dt)
    if titan.cooldown[pComp].actu > 0 then 
        titan.cooldown[pComp].actu = titan.cooldown[pComp].actu - dt
        local pourcentage =  dt / titan.cooldown[pComp].max * 100
        local v = 64 / 100 * pourcentage
        titan.cooldown[pComp].h = titan.cooldown[pComp].h + v
    elseif titan.cooldown[pComp].actu < 0 then 
        titan.cooldown[pComp].actu = 0
        sprite.commandes[pComp - 1].alpha = 1

        if pComp == titan.etats.QUAKE then txt.spacebar.color = {0,0,0,1} end
    end 
end 

function jeu.updateShake()
    if shake.actif then 
        shake.val = shake.val * .75
        local x = 5 - love.math.random(25)
        local y = 5 - love.math.random(25)
        shake.cx = x * shake.val
        shake.cy = y * shake.val

        if shake.val < .05 then jeu.resetShake() end 
    end 
end 

function jeu.resetShake()
    shake.val = 0            
    shake.cx = 0
    shake.cy = 0
    shake.actif = false
    shockwave.reload()
end

return jeu