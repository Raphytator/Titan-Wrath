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
    local distance = 200
    local duree = 3
    tween.titreJeu = newTween(depart, distance, duree)    
    txt.titreJeu = newTxt("titreJeu", _fonts.titre, 0, depart, {0,0,0,1}, _ecran.w, "center")

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