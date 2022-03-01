function init()

    initVariables()
    initRoot()
    initImg()
    initSfx()
    initCadre()
    initFonts()
    initScenes()
    

    changeScene(_scenes.menuPrincipal)
end

function initVariables()
    _ecran = { w = 1280, h = 720, fullscreen = false }
    _sceneOld = nil
    _sceneActu = nil
    _etatOld = nil
    _etatActu = nil
    _txt = {}
    _txt.choixLangue = "Selection de la langue"
    _clic = false 
    _mouse = { x = 0, y = 0}
    _quad = {}
    _scale = 1
    _musique = true
    _sons = true
    _musiqueActu = nil
    fadeInitialisation()
end 

function initRoot()
    love.window.setMode(_ecran.w, _ecran.h)
    love.window.setTitle("Titan Wrath")
    --love.mouse.setVisible(false)
end

function initImg()
    _img = {}
    _img.btn = love.graphics.newImage("img/bouton.png")
    _img.btnHover = love.graphics.newImage("img/boutonHover.png")
    _img.btnPressed = love.graphics.newImage("img/boutonPressed.png")
end 

function initSfx()
    _sfx = {}
    _sfx.clic = love.audio.newSource("sfx/clic.wav", "static")
end 

function initFonts()
    _fonts = {}
    _fonts.titre = love.graphics.newFont("font/DIOGENES.ttf", 80)
    _fonts.texte = love.graphics.newFont("font/DIOGENES.ttf", 32)
    _fonts.btn = love.graphics.newFont("font/DIOGENES.ttf", 36)

end 

function initScenes()
    _scenes = {}
    _scenes.menuPrincipal = require("menuPrincipal")
    _scenes.jeu = require("jeu")

end 