function init()

    initRoot()

end

function initRoot()
    _ecran = { w = 1280, h = 720 }

    love.window.setMode(_ecran.w, _ecran.h)
    love.window.setTitle("Titan Wrath")
    love.mouse.setVisible(false)

end