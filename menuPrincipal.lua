local menuPrincipal = {}

--[[
██╗███╗   ██╗██╗████████╗
██║████╗  ██║██║╚══██╔══╝
██║██╔██╗ ██║██║   ██║   
██║██║╚██╗██║██║   ██║   
██║██║ ╚████║██║   ██║   
╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   
                         
]]

local img = {}
local btn = {}
local spr = {}
local txt = {}
local tween = {}
local cadre = {}

local alphaVoile = 0
local affichePage = false
local cible = ""

function menuPrincipal.init()

    -- ============
    -- Choix langue
    -- ============
    img.flags = {
        anglais = {
            defaut = love.graphics.newImage("img/Flag-EN.png"),
            hover = love.graphics.newImage("img/Flag-EN-Hover.png")
        },
        francais = {
            defaut = love.graphics.newImage("img/Flag-FR.png"),
            hover = love.graphics.newImage("img/Flag-FR-Hover.png")
        }
    }

    local tier = _ecran.w / 3

    btn.flagEN = newBtn("img", tier - img.flags.anglais.defaut:getWidth() / 2, (love.graphics.getHeight() - img.flags.anglais.defaut:getHeight())/2, img.flags.anglais.defaut, img.flags.anglais.hover)
    btn.flagFR = newBtn("img", tier * 2 - img.flags.francais.defaut:getWidth() / 2, (love.graphics.getHeight() - img.flags.francais.defaut:getHeight())/2, img.flags.francais.defaut, img.flags.francais.hover)

    -- ==============
    -- Menu principal
    -- ==============

    spr.fondMenu = newSprite(love.graphics.newImage("img/fondMenuPrincipal.jpg"), 0, 0)
    
    local depart = 0 - _fonts.titre:getHeight("W") - 10 
    tween.titreJeu = newTween(depart, 200, 2)
    txt.titreJeu = newTxt("titreJeu", _fonts.titre, 0, depart, {0,0,0,1}, _ecran.w, "center")

    local xBtn = (_ecran.w - _img.btn:getWidth()) / 2
    local yBtn = 420
    local separationY = _img.btn:getHeight() + 5
    btn.jouer = newBtn("img", xBtn, yBtn, _img.btn, _img.btnHover, _img.btnPressed, "jouer")
    btn.options = newBtn("img", xBtn, btn.jouer.y + separationY, _img.btn, _img.btnHover, _img.btnPressed, "options")
    btn.controles = newBtn("img", xBtn, btn.options.y + separationY, _img.btn, _img.btnHover, _img.btnPressed, "controles")
    btn.credits = newBtn("img", xBtn, btn.controles.y + separationY, _img.btn, _img.btnHover, _img.btnPressed, "credits")
    btn.quitter = newBtn("img", xBtn, btn.credits.y + separationY, _img.btn, _img.btnHover, _img.btnPressed, "quitter")

    btn.retourMenuPrincipal = newBtn("img", _ecran.w - _img.btn:getWidth() - 10, _ecran.h - _img.btn:getHeight() - 10, _img.btn, _img.btnHover, _img.btnPressed, "retour")

    local l, c, xCadre, yCadre
    
    -- =======
    -- Options
    -- =======

    l = 3
    c = 6
    xCadre = centrageCadre("x", c)
    yCadre = centrageCadre("y", l)
    cadre.options = newCadre(xCadre, yCadre, c, l)
    img.checkbox = love.graphics.newImage("img/checkBox.png")
    img.checkboxChecked = love.graphics.newImage("img/checkBoxChecked.png")
    btn.musique = newBtn("chkbox", xCadre + 25, yCadre + 35, img.checkbox, img.checkboxChecked, true)
    txt.musique = newTxt("musique", _fonts.texte, btn.musique.x + 40, btn.musique.y - 8)
    btn.sons = newBtn("chkbox", xCadre + 25, btn.musique.y + _fonts.texte:getHeight("W") + 5, img.checkbox, img.checkboxChecked, true)
    txt.sons = newTxt("sons", _fonts.texte, btn.sons.x + 40, btn.sons.y - 8)
    btn.fullscreen = newBtn("chkbox", xCadre + 25, btn.sons.y + _fonts.texte:getHeight("W") + 5, img.checkbox, img.checkboxChecked, false)
    txt.fullscreen = newTxt("fullscreen", _fonts.texte, btn.fullscreen.x + 40, btn.fullscreen.y - 8)

    -- =========
    -- Controles
    -- =========

    l = 13
    c = 25
    xCadre = centrageCadre("x", c)
    yCadre = 15
    cadre.controles = newCadre(xCadre, yCadre, c, l)
    txt.controles = newTxt("infoControles", _fonts.texte, xCadre + 25, yCadre + 25, {0,0,0,1}, cadre.controles.w - 50, "left")


    -- =======
    -- Crédits
    -- =======

    l = 7
    c = 18
    xCadre = centrageCadre("x", c)
    yCadre = centrageCadre("y", l)
    cadre.credits = newCadre(xCadre, yCadre, c, l)
    txt.creditsTxt = {}
    txt.creditsTxt[1] = newTxt("creditsTxt1", _fonts.texte, xCadre + 25, yCadre + 25, {0,0,0,1}, cadre.credits.w - 50, "center")
    txt.creditsTxt[2] = newTxt("creditsTxt2", _fonts.texte, xCadre + 25, txt.creditsTxt[1].y + 80, {0,0,0,1}, cadre.credits.w - 50, "left")
    txt.creditsTxt[3] = newTxt("creditsTxt3", _fonts.texte, xCadre + 25, txt.creditsTxt[2].y + 50, {0,0,0,1}, cadre.credits.w - 50, "left")
    txt.creditsTxt[4] = newTxt("creditsTxt4", _fonts.texte, xCadre + 25, txt.creditsTxt[3].y + 50, {0,0,0,1}, cadre.credits.w - 50, "left")
    txt.creditsTxt[5] = newTxt("creditsTxt5", _fonts.texte, xCadre + 25, txt.creditsTxt[4].y + 50, {0,0,0,1}, cadre.credits.w - 50, "left")
    txt.creditsTxt[6] = newTxt("creditsTxt6", _fonts.texte, xCadre + 25, txt.creditsTxt[5].y + 50, {0,0,0,1}, cadre.credits.w - 50, "left")

end 

--[[
██╗      ██████╗  █████╗ ██████╗ 
██║     ██╔═══██╗██╔══██╗██╔══██╗
██║     ██║   ██║███████║██║  ██║
██║     ██║   ██║██╔══██║██║  ██║
███████╗╚██████╔╝██║  ██║██████╔╝
╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
                                 
]]

function menuPrincipal.load()
    changeEtat("choixLangue")
end 

--[[
██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗
██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  
██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  
╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗
 ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
                                                  
]]

function menuPrincipal.update(dt)

    if not _fade.fadeIn and not _fade.fadeOut then
        if _etatActu == "choixLangue" then
            btn.flagEN:update(menuPrincipal.selectLangue, {"en"})
            btn.flagFR:update(menuPrincipal.selectLangue, {"fr"})
        elseif _etatActu == "menuPrincipal" then 
            tween.titreJeu:update(dt)
            txt.titreJeu.y = tween.titreJeu.actu

            if tween.titreJeu.finished then 
                btn.jouer:update(fadeOut, {"jouer"})
                btn.options:update(menuPrincipal.ouvrePage, {"options"})
                btn.controles:update(menuPrincipal.ouvrePage, {"controles"})
                btn.credits:update(menuPrincipal.ouvrePage, {"credits"})
                btn.quitter:update(love.event.quit)
            end 
        elseif _etatActu == "retourMenuPrincipal" then 
            if alphaVoile > 0 then 
                alphaVoile = alphaVoile - dt * 3
            else 
                changeEtat("menuPrincipal")
            end
        elseif inArray({"options", "controles", "credits"}, _etatActu) then 
            if alphaVoile < .6 then 
                alphaVoile = alphaVoile + dt * 3
            else 
                if not affichePage then affichePage = true end

                btn.retourMenuPrincipal:update(changeEtat, {"retourMenuPrincipal"})

                if _etatActu == "options" then 
                    btn.musique:update(menuPrincipal.modifMusiqueSon, {"musique"})
                    btn.sons:update(menuPrincipal.modifMusiqueSon, {"sons"})
                    btn.fullscreen:update(menuPrincipal.passageFullscreen)
                end
            end 
        end 
    end

    if _fade.fadeEnd then 
        _fade.fadeEnd = false 
        _fade.alphaTransition = 0

        if _fade.sortie == "menuPrincipal" then 
            changeEtat("menuPrincipal") 
        elseif _fade.sortie == "jouer" then
            changeScene(_scenes.jeu)
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

function menuPrincipal.draw()

    if _etatActu == "choixLangue" then
        btn.flagEN:draw()
        btn.flagFR:draw()
    elseif _etatActu == "retourMenuPrincipal" then 
        spr.fondMenu:draw()
        drawVoile(alphaVoile)
    elseif _etatActu == "menuPrincipal" then 
        spr.fondMenu:draw()
        txt.titreJeu:print()

        if tween.titreJeu.finished then 
            btn.jouer:draw()
            btn.options:draw()
            btn.controles:draw()
            btn.credits:draw()
            btn.quitter:draw()
        end
    elseif _etatActu == "options" then 
        spr.fondMenu:draw()
        drawVoile(alphaVoile)
        if affichePage then            
            cadre.options:draw()
            btn.retourMenuPrincipal:draw()

            btn.musique:draw()
            txt.musique:print()
            btn.sons:draw()
            txt.sons:print()
            btn.fullscreen:draw()
            txt.fullscreen:print()

        end
    elseif _etatActu == "controles" then 
        spr.fondMenu:draw()
        drawVoile(alphaVoile)

        if affichePage then
            cadre.controles:draw()
            btn.retourMenuPrincipal:draw()
            txt.controles:print()
        end
    elseif _etatActu == "credits" then 
        spr.fondMenu:draw()
        drawVoile(alphaVoile)

        if affichePage then
            cadre.credits:draw()
            btn.retourMenuPrincipal:draw()
            
            for i=1, #txt.creditsTxt do 
                txt.creditsTxt[i]:print()
            end
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

function menuPrincipal.keypressed(key)

end

--[[
███████╗ ██████╗ ███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
██╔════╝██╔═══██╗████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
█████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
                                                                          
]]

function menuPrincipal.selectLangue(pLang)
    _str = require("lang/"..pLang)
    fadeOut("menuPrincipal")
end 

function menuPrincipal.ouvrePage(pPage)
    alphaVoile = 0 
    affichePage = false
    changeEtat(pPage)
end 

function menuPrincipal.passageFullscreen()
    _ecran.fullscreen = not _ecran.fullscreen
    local flags = { fullscreen = _ecran.fullscreen}
    love.window.setMode(_ecran.w, _ecran.h, flags)

    _scale = love.graphics.getWidth() / _ecran.w 
    
end

function menuPrincipal.modifMusiqueSon(pType)
    if pType == "musique" then
        _musique = not _musique
        if _musiqueActu ~= nil then _musiqueActu:stop() end
    elseif pType == "sons" then
        _sons = not _sons
    end
end 

return menuPrincipal