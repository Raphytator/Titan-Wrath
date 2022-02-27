function init()

    initVariables()
    initRoot()
    initFonts()
    initScenes()

    changeScene(_scenes.menuPrincipal)
end

function initVariables()
    _ecran = { w = 1280, h = 720 }
    _sceneOld = nil
    _sceneActu = nil
    _etatOld = nil
    _etatActu = nil
    _txt = {}
    _txt.choixLangue = "Selection de la langue"
    _clic = false 
    _mouse = { x = 0, y = 0}
    fadeInitialisation()
end 

function initRoot()
    love.window.setMode(_ecran.w, _ecran.h)
    love.window.setTitle("Titan Wrath")
    --love.mouse.setVisible(false)
end

function initFonts()
    _fonts = {}
    _fonts.texte = love.graphics.newFont("font/DIOGENES.ttf", 32)

end 

function initScenes()
    _scenes = {}
    _scenes.menuPrincipal = require("menuPrincipal")
    _scenes.jeu = require("jeu")

end 