function init()

    initVariables()
    initRoot()
    initScenes()

    changeScene(_scenes.menuPrincipal)
end

function initVariables()
    _ecran = { w = 1280, h = 720 }
    _sceneOld = nil
    _sceneActu = nil    
end 

function initRoot()
    love.window.setMode(_ecran.w, _ecran.h)
    love.window.setTitle("Titan Wrath")
    love.mouse.setVisible(false)
end

function initScenes()
    _scenes = {}
    _scenes.menuPrincipal = require("menuPrincipal")
    _scenes.jeu = require("jeu")

end 