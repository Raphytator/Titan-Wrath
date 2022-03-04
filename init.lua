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
    _toucheTitan = false 
    _degatsTitan = 0
    
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

    love.mouse.setCursor(love.mouse.newCursor(love.image.newImageData("img/cursor.png")))
end 

function initSfx()
    _sfx = {}
    _sfx.clic = love.audio.newSource("sfx/clic.wav", "static")
    _sfx.poing = love.audio.newSource("sfx/poing.wav", "static")
end 

function initFonts()
    _fonts = {}
    _fonts.titre = love.graphics.newFont("font/DIOGENES.ttf", 80)
    _fonts.victoire = love.graphics.newFont("font/DIOGENES.ttf", 100)
    _fonts.gameOver = love.graphics.newFont("font/DIOGENES.ttf", 70)
    _fonts.texte = love.graphics.newFont("font/DIOGENES.ttf", 32)
    _fonts.btn = love.graphics.newFont("font/DIOGENES.ttf", 36)
    _fonts.mini = love.graphics.newFont("font/DIOGENES.ttf", 16)

end 

function initScenes()
    _scenes = {}
    _scenes.menuPrincipal = require("menuPrincipal")
    _scenes.jeu = require("jeu")

end 