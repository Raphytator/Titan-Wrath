function init()

    initVariables()
    initRoot()
    initImg()
    initMusic()
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
    _continueMusique = false
    fadeInitialisation()
end 

function initRoot()
    love.window.setMode(_ecran.w, _ecran.h)
    love.window.setTitle("Titan Wrath")
    local icone = love.image.newImageData("img/icone.png")
    love.window.setIcon(icone)
end

function initImg()
    _img = {}
    _img.btn = love.graphics.newImage("img/bouton.png")
    _img.btnHover = love.graphics.newImage("img/boutonHover.png")
    _img.btnPressed = love.graphics.newImage("img/boutonPressed.png")

    love.mouse.setCursor(love.mouse.newCursor(love.image.newImageData("img/cursor.png")))
end 

function initMusic()
    _music = {}
    _music.wave = love.audio.newSource("music/wave.ogg", "stream")
    _music.finalWave = love.audio.newSource("music/last.ogg", "stream")
    _music.gameOver = love.audio.newSource("music/gameover.ogg", "stream")
    _music.victoire = love.audio.newSource("music/victory.ogg", "stream")
    _music.jeu = love.audio.newSource("music/Titan_wrath.ogg", "stream")
    _music.menu = love.audio.newSource("music/menu.ogg", "stream")
end 

function initSfx()
    _sfx = {}
    _sfx.clic = love.audio.newSource("sfx/clic.wav", "static")
    _sfx.poing = love.audio.newSource("sfx/poing.wav", "static")
    _sfx.vache = love.audio.newSource("sfx/vache.wav", "static")
    _sfx.heal = love.audio.newSource("sfx/heal.wav", "static")
    _sfx.splash = love.audio.newSource("sfx/splash.wav", "static")
    _sfx.pause = love.audio.newSource("sfx/pause.wav", "static")
    _sfx.lance = love.audio.newSource("sfx/lance.wav", "static")
end 

function initFonts()
    _fonts = {}
    _fonts.titre = love.graphics.newFont("font/DIOGENES.ttf", 80)
    _fonts.victoire = love.graphics.newFont("font/DIOGENES.ttf", 100)
    _fonts.gameOver = love.graphics.newFont("font/DIOGENES.ttf", 70)
    _fonts.texte = love.graphics.newFont("font/DIOGENES.ttf", 32)
    _fonts.texte2 = love.graphics.newFont("font/DIOGENES.ttf", 40)
    _fonts.btn = love.graphics.newFont("font/DIOGENES.ttf", 36)
    _fonts.mini = love.graphics.newFont("font/DIOGENES.ttf", 16)

end 

function initScenes()
    _scenes = {}
    _scenes.menuPrincipal = require("menuPrincipal")
    _scenes.jeu = require("jeu")
    _scenes.cinematique = require("cinematique")
end 