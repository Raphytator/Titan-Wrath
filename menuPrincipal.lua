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
                btn.jouer:update()
                btn.options:update()
                btn.controles:update()
                btn.credits:update()
                btn.quitter:update(love.event.quit)
            end 
        end 
    end

    if _fade.fadeEnd then 
        _fade.fadeEnd = false 
        _fade.alphaTransition = 0

        if _fade.sortie == "menuPrincipal" then 
            changeEtat("menuPrincipal")   
            fadeIn()
        elseif _fade.sortie == "jouer" then

        end 
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

return menuPrincipal