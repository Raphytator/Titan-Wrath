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

    btn.retourMenuPrincipal = newBtn("img", _ecran.w - _img.btn:getWidth() - 25, _ecran.h - _img.btn:getHeight() - 15, _img.btn, _img.btnHover, _img.btnPressed, "retour")


    -- =======
    -- Crédits
    -- =======

    local l = 6
    local c = 18
    local xCadre = centrageCadre("x", c)
    local yCadre = centrageCadre("y", l)
    cadre.credits = newCadre(xCadre, yCadre, c, l)
    txt.creditsTxt = {}
    txt.creditsTxt[1] = newTxt("creditsTxt1", _fonts.texte, xCadre + 25, yCadre + 25, {0,0,0,1}, cadre.credits.w - 50, "center")
    txt.creditsTxt[2] = newTxt("creditsTxt2", _fonts.texte, xCadre + 25, txt.creditsTxt[1].y + 80, {0,0,0,1}, cadre.credits.w - 50, "left")
    txt.creditsTxt[3] = newTxt("creditsTxt3", _fonts.texte, xCadre + 25, txt.creditsTxt[2].y + 50, {0,0,0,1}, cadre.credits.w - 50, "left")
    txt.creditsTxt[4] = newTxt("creditsTxt4", _fonts.texte, xCadre + 25, txt.creditsTxt[3].y + 50, {0,0,0,1}, cadre.credits.w - 50, "left")
    txt.creditsTxt[5] = newTxt("creditsTxt5", _fonts.texte, xCadre + 25, txt.creditsTxt[4].y + 50, {0,0,0,1}, cadre.credits.w - 50, "left")



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
                alphaVoile = alphaVoile - dt
            else 
                changeEtat("menuPrincipal")
            end
        elseif inArray({"options", "controles", "credits"}, _etatActu) then 
            if alphaVoile < .6 then 
                alphaVoile = alphaVoile + dt
            else 
                if not affichePage then affichePage = true end

                btn.retourMenuPrincipal:update(changeEtat, {"retourMenuPrincipal"})

                if _etatActu == "options" then 
                
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

        end
    elseif _etatActu == "controles" then 
        spr.fondMenu:draw()
        drawVoile(alphaVoile)

        if affichePage then

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

return menuPrincipal