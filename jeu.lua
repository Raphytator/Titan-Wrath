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
local victoire = {}

local shake = { actif = false, cx = 0, cy = 0 }

local shaderActif = false
local timerShader = 0
local origineTitanY = 265

local cloud_layer_01, cloud_layer_02, cloud_layer_03, cloud_layer_04
local moveCloudToLeft, moveCloudToRight, moveCloud

local particules = {}
local vache = { active = false, vitesse = stats.vaches.vitesse, timerShader = 0, touche = false }

local shaderRouge = love.graphics.newShader[[
    vec4 effect(vec4 color, Image texture, vec2 textureCoord, vec2 screenCoord) {
        vec4 texColor = Texel(texture, textureCoord);
        if (texColor.a != 0) {
            texColor.r = 1;
            texColor.g = 0;
            texColor.b = 0;
            return texColor;
        }
    }
]]


function jeu.init()
    shockwave.init()
    sprite.ciel = newSprite(love.graphics.newImage("img/sky.png"), 0, 0)

    img.backgroundFixe = love.graphics.newImage("img/background_fixe.png")
    sprite.backgroundFixe = newSprite(img.backgroundFixe, (_ecran.w - img.backgroundFixe:getWidth()) / 2, 0)

    img.background = love.graphics.newImage("img/background.png")
    local bgx = (_ecran.w - img.background:getWidth())/2
    sprite.terrain = newSprite(img.background, bgx, 0)

    cloud_layer = {}
    cloud_layer[1] = {
        img = love.graphics.newImage("img/cloud_layer_01.png"),
        x = 820,
        y = -50,
        vx = 0,
        vy = 0,
        spd = {acceleration = 2, max = 15}
    }

    cloud_layer[2] = {
        img = love.graphics.newImage("img/cloud_layer_02.png"),
        x = -450,
        y = -50,
        vx = 0,
        vy = 0,
        spd = {acceleration = 2, max = 7}
    }

    cloud_layer[3] = {
        img = love.graphics.newImage("img/cloud_layer_03.png"),
        x = 150,
        y = 62,
        vx = 0,
        vy = 0,
        spd = {acceleration = 2, max = 4}
    }

    cloud_layer[4] = {
        img = love.graphics.newImage("img/cloud_layer_04.png"),
        x = 800,
        y = 86,
        vx = 0,
        vy = 0,
        spd = {acceleration = 2, max = 10}
    }
    
    sprite.cloud = {}
    for i=1, 4 do 
        sprite.cloud[i] = newSprite(cloud_layer[i].img, cloud_layer[i].x, cloud_layer[i].y)
    end 


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
    txt.victoire = newTxt("victoire", _fonts.victoire, 0, 300, {.8,.8,.8,0}, _ecran.w, "center")

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
        [titan.etats.POING] = { actu = 0, max = stats.cooldown[1], y = 0, h = 64},
        [titan.etats.VAGUE] = { actu = 0, max = stats.cooldown[2], y = 0, h = 64},
        [titan.etats.QUAKE] = { actu = 0, max = stats.cooldown[3], y = 0, h = 64},
    }
   
    initSoldats()

    sprite.vache = newSprite(love.graphics.newImage("img/cow.png"), 0, 0, 1, true)

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

    -- =====
    -- Pause
    -- =====
    
    btn.reprendre = newBtn("img", xBtn, yBtn, _img.btn, _img.btnHover, _img.btnPressed, "reprendre")

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

    if not _fade.fadeIn and not _fade.fadeOut and _etatActu ~= "pause" then
        
        

        if inArray({"victoire", "jeu"}, _etatActu) then 
            
            if shaderActif then 
                shockwave.update(dt)

                timerShader = timerShader + dt 
                if timerShader >= .8 then 
                    timerShader = 0
                    shockwave.reload()
                    shaderActif = false
                end
            end

            -- Direction du Titan
            local angleMouse
            local pi5 = math.pi / 5

            if _mouse.y >= origineTitanY then 

                angleMouse = math.abs(math.angle(mid, origineTitanY, _mouse.x, _mouse.y))

                if not titan.competenceActive and _etatActu == "jeu" then 
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
                    _musiqueActu:stop()
                    _musiqueActu = nil
                    playMusic(_music.gameOver)
                    jeu.resetShake()
                    titan.etat = titan.etats.DEAD
                    titan.frame = 1
                    titan.direction = 1
                    titan.vitesseFrame = 3
                end         
                
                -- Cooldowns
                jeu.updateCooldown(titan.etats.POING, dt)
                jeu.updateCooldown(titan.etats.VAGUE, dt)
                jeu.updateCooldown(titan.etats.QUAKE, dt)
            
                -- Vagues de soldats
                if _etatActu == "jeu" then 
                    if vague.spawnedSoldiers < stats.nbSoldats[vague.actu] then 
                        vague.spawnSoldiersTimer = vague.spawnSoldiersTimer + dt 
                        if vague.spawnSoldiersTimer >= vague.spawnSoldiersTimerMax then 
                            jeu.spawnSoldiers()
                        end 
                    end
                end 
 
                -- Soldats
                for i=1, #soldats do 
                    soldats[i]:update(dt)
                end 

            end 

            -- Compétences 
            if titan.competenceActive then
                if titan.frame > #img.titan[titan.etat][titan.direction] then 
                    
                    titan.timerFinCompetence = titan.timerFinCompetence + dt 
                    if titan.timerFinCompetence > .1 then 
                        titan.timerFinCompetence = 0
                        titan.nbCoups = titan.nbCoups + 1 
                        titan.frame = 1
                        jeu.effetCompetence(titan.etat)

                        if titan.nbCoups >= titan.nbCoupsMax then
                            titan.cooldown[titan.etat].actu = titan.cooldown[titan.etat].max 
                            titan.competenceActive = false                                
                            titan.etat = titan.etats.STAND   
                            titan.frame = 1 
                            titan.direction = 3                  
                        end
                    end                        
                end 
            end 

            -- Shakes
            jeu.updateShake(dt)

            if _etatActu == "victoire" then 

                if victoire.etat == "apparition" then 
                    local vitesse = 6
                    if alphaVoile < .7 then alphaVoile = alphaVoile + dt / vitesse * .7 end
                    if victoire.alpha < 1 then 
                        victoire.alpha = victoire.alpha + dt / vitesse
                        txt.victoire.color = {1,1,1,victoire.alpha}
                    else 
                        victoire.etat = "standby"
                        victoire.timer = 0
                    end 
                elseif victoire.etat == "standby" then
                    if victoire.timer < 1.8 then 
                        victoire.timer = victoire.timer + dt
                    else 
                        victoire.voileFinal = 0
                        victoire.etat = "disparition"
                    end 
                elseif victoire.etat == "disparition" then 
                    local vitesse = 2
                    if victoire.voileFinal < 1 then 
                        victoire.voileFinal = victoire.voileFinal + dt / vitesse
                        victoire.alpha = victoire.alpha - dt / vitesse
                        txt.victoire.color = {1,1,1,victoire.alpha}
                    else 
                        fadeOut("victory")
                    end 
                end 
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

        -- Vache
        if vache.active then 
            sprite.vache.x = sprite.vache.x + vache.vx * dt
            if vache.touche then 
                vache.timerShader = vache.timerShader + dt 
                if vache.timerShader > .1 then 
                    vache.timerShader = 0
                    vache.touche = false 
                end
            end 
        end

        -- Clouds layer back
        moveCloudToLeft(cloud_layer[1], -1, dt)
        moveCloudToRight(cloud_layer[2], 1, dt)
        -- Clouds layer middle
        moveCloudToRight(cloud_layer[3], 1, dt)
        moveCloudToLeft(cloud_layer[4], -1, dt) 
        moveCloud(cloud_layer[1], dt)
        moveCloud(cloud_layer[2], dt)
        moveCloud(cloud_layer[3], dt)
        moveCloud(cloud_layer[4], dt)

        for i=1, 4 do sprite.cloud[i].x = cloud_layer[i].x end 

        -- Particules de sang
        for i=#particules, 1, -1 do 
            local p = particules[i]
            
            if p.vx > 0 then p.vx = p.vx - p.vitesseX * dt 
            else p.vx = p.vx - p.vitesseX * dt end

            p.vy = p.vy + p.vitesseY * dt 

            p.x = p.x + p.vx 
            p.y = p.y + p.vy 

            p.vie = p.vie - dt 

            if p.vie > 0 then p.color[4] = p.vie / p.vieMax
            else p.color[4] = 0 end

            if p.vie < 0 then table.remove(particules, i) end             
        end

    end 

    if _etatActu == "pause" then 
        btn.reprendre:update(jeu.resumeJeu)
        btn.menuPrincipal:update(fadeOut, {"menuPrincipal"})
    end 

    if _fade.fadeEnd then 
        _fade.fadeEnd = false 
        _fade.alphaTransition = 0

        if _fade.sortie == "restart" then 
            jeu.nouveauJeu()
        elseif _fade.sortie == "menuPrincipal" then
            changeScene(_scenes.menuPrincipal)
            changeEtat("menuPrincipal")
            _musiqueActu = _music.menu
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

    sprite.ciel:draw()

    for i=1, 4 do sprite.cloud[i]:draw() end 

    love.graphics.push()
    love.graphics.translate(shake.cx, shake.cy)

    sprite.backgroundFixe:draw()
    
    if shaderActif then
        shockwave.send(shake.cx, shake.cy)
        shockwave.draw()
    end

    sprite.terrain:draw()
    love.graphics.setShader()
    sprite.trouTerrain:draw()
    sprite.titan:draw()


    if vache.active then 
        if vache.touche then love.graphics.setShader(shaderRouge) end
        sprite.vache:draw() 
        love.graphics.setShader()
    end

    -- Soldats
    for i=1, #soldats do 
        soldats[i]:draw()
    end 

    for i=#particules, 1, -1 do 
        local p = particules[i]
        drawCercle("fill", p.x, p.y, p.size, p.color)
    end 

    love.graphics.pop()


    -- ===
    -- HUD
    -- === 

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
    elseif _etatActu == "pause" then 
        drawVoile()
        btn.reprendre:draw()
        btn.menuPrincipal:draw()
    elseif _etatActu == "victoire" then 
        drawVoile(alphaVoile)
        txt.victoire:print()

        if victoire.etat == "disparition" then 
            drawVoile(victoire.voileFinal)
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
    if _etatActu == "jeu" then 
        if key == "space" then
            if not vague.affichage and not titan.competenceActive and _etatActu == "jeu" then
                if titan.cooldown[titan.etats.QUAKE].actu == 0 then 
                    jeu.activeCompetence(titan.etats.QUAKE)
                end
            end
        elseif key == "escape" then 
            playSound(_sfx.pause)
            _musiqueActu:setVolume(.3)
            changeEtat("pause")
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

function jeu.resumeJeu()
    _musiqueActu:setVolume(1)
    changeEtat("jeu")
end 

function jeu.nouveauJeu()
    _musiqueActu = _music.jeu


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
    if vague.actu < stats.nbVagues then
        txt.vague.txtSup = " "..vague.actu
        playMusic(_music.wave)
    else 
        txt.vague.txtSup = ""
        txt.vague.txt = "vagueFinale"
        playMusic(_music.finalWave)        
    end 
    txt.vague.color[4] = 0

    vague.spawnSoldiersTimer = 0
    vague.spawnSoldiersTimerMax = 0
    vague.spawnedSoldiers = 0

    vache.vague = math.ceil(stats.nbSoldats[vague.actu] / 2)
end 

function jeu.spawnSoldiers()
    vague.spawnSoldiersTimer = 0
    vague.spawnSoldiersTimerMax = love.math.random(3, 6)
    vague.spawnedSoldiers = vague.spawnedSoldiers + 1

    -- Vache 
    if vache.vague == vague.spawnedSoldiers then 
        jeu.spawnVache()
    end

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

function jeu.spawnVache()
    playSound(_sfx.vache)
    sprite.vache.y = love.math.random(400, 600)
    vache.pv = stats.vaches.pv 
    vache.active = true
    if love.math.random(0, 100) <= 50 then -- Droite à gauche        
        sprite.vache.x = _ecran.w + sprite.vache.img:getWidth() / 2 + 1
        vache.vx = -stats.vaches.vitesse
        sprite.vache.sx = -1
    else -- Gauche à droite
        sprite.vache.x = -sprite.vache.img:getWidth() / 2 - 1
        sprite.vache.sx = 1
        vache.vx = stats.vaches.vitesse
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
    local titanY = origineTitanY
    local tabDirection = { titan.direction }
    local zones = stats.degatsZones[pComp - 1] -- Dégats en fonction des zones
    local fall = false
    local dgtVache

    playSound(_sfx.poing)

    shake.actif = true
    if pComp == titan.etats.POING then        
        shake.val = 1      
        dgtVache = 4  
    elseif pComp == titan.etats.VAGUE then
        shake.val = 2
        shockwave.launch(false, titan.direction)        
        shaderActif = true
        timerShader = 0
        fall = true
        dgtVache = 6
    elseif pComp == titan.etats.QUAKE then
        shake.val = 3
        txt.spacebar.color = {0,0,0,.3}
        tabDirection = {1,2,3,4,5}
        shockwave.launch(true)
        shaderActif = true
        timerShader = 0
        fall = true
        dgtVache = 2
    end

    sprite.commandes[pComp - 1].alpha = .3

    -- Dégats aux soldats
    for i=#soldats, 1, -1 do 
        local s = soldats[i]
        if inArray(tabDirection, s.direction) then 
            local distanceSoldats = distance(titanX, titanY, s.position.x, s.position.y)
            

            if distanceSoldats < 780 then 
                local zoneDegats

                if distanceSoldats <= 180 then zoneDegats = 1                    
                elseif distanceSoldats <= 380 then zoneDegats = 2                
                elseif distanceSoldats <= 580 then zoneDegats = 3                
                else zoneDegats = 4 end 

                s:recoitDegats(zones[zoneDegats], fall)
                
                if not s.live then table.remove(soldats, i) end
            end 
        end         
    end 

    if #soldats == 0 and vague.spawnedSoldiers == stats.nbSoldats[vague.actu] then jeu.vagueSuivante() end 

    -- Vache
    if vache.active then 
        local angleVache = math.angle(titanX, titanY, sprite.vache.x, sprite.vache.y)
        local zoneVache
        local pi5 = math.pi / 5

        if angleVache < pi5 then zoneVache = 1
        elseif angleVache >= pi5 and angleVache < pi5 * 2 then zoneVache = 2
        elseif angleVache >= pi5 * 2 and angleVache < pi5 * 3 then zoneVache = 3
        elseif angleVache >= pi5 * 3 and angleVache < pi5 * 4 then zoneVache = 4
        else zoneVache = 5 end

        if pComp == titan.etats.QUAKE then zoneVache = titan.direction end
        
        if zoneVache == titan.direction then 
            if sprite.vache.x > 0 and sprite.vache.x < _ecran.w then 
                vache.pv = vache.pv - dgtVache
                vache.touche = true
                vache.timerShader = 0
                if vache.pv <= 0 then 
                    vache.active = false 
                    titan.pv = titan.pv + stats.vaches.gain
                    if titan.pv > stats.pvMaxTitan then titan.pv = stats.pvMaxTitan end
                    ajoutParticules(sprite.vache)
                    playSound(_sfx.heal)
                end 
            end
        end
    end 
end 

function jeu.vagueSuivante()
    jeu.resetShake()    

    vague.actu = vague.actu + 1
    if vague.actu <= stats.nbVagues then 
        jeu.lancementVague()
    else 
        -- VICTOIRE
        alphaVoile = 0
        victoire.alpha = 0
        victoire.etat = "apparition"
        changeEtat("victoire")
        playMusic(_music.victoire)
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
    
end

-- MAJ des coordonnées parallaxe des nuage vers la gauche
moveCloudToLeft = function(cloud, direction, dt)
    if cloud.x > -cloud.img:getWidth() then
        cloud.vx = math.max(-cloud.spd.max, cloud.vx + direction * (cloud.spd.acceleration + dt))
    else
        cloud.x = _ecran.w
    end
end

-- MAJ des coordonnées paralaxe des nuage vers la droite
moveCloudToRight = function(cloud, direction, dt)
    if cloud.x < _ecran.w then
        cloud.vx = math.min(cloud.spd.max, cloud.vx + direction * (cloud.spd.acceleration + dt))
    else
        cloud.x = -cloud.img:getWidth()
    end
end

-- Déplacement des nuages quelque soit le sens du parallaxe
moveCloud = function(cloud, dt) cloud.x = cloud.x + cloud.vx * dt end

function ajoutParticules(pSoldat)
    for i=1, love.math.random(150, 250) do 
        local particle = {}
        local x = love.math.random(-20, 20)
        local y = love.math.random(-20, 20)
        particle.size = love.math.random(1,2)
        particle.x = pSoldat.x + x
        particle.y = pSoldat.y + y
        particle.vx = love.math.random(-.2, .2)
        particle.vy = 0
        particle.vitesseX = love.math.random(.1, .3)
        particle.vitesseY = love.math.random(.1, .6)
        particle.vie = love.math.random(.3, .6)
        particle.vieMax = particle.vie
        particle.color = { love.math.random(), 0, 0, 1}
        table.insert(particules, particle)
    end
end

return jeu