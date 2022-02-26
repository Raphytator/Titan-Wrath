io.stdout:setvbuf("no")

require("fonctions")
require("init")

function love.load()
    init()
end 

function love.update(dt)
    _sceneActu.update(dt)
end

function love.draw()
    _sceneActu.draw()
end

function love.keypressed(key)
    if key == "f11" then 
        love.event.quit("restart")
    elseif key == "f12" then 
        love.event.quit()
    end

    if _sceneActu.keypressed ~= nil then 
        _sceneActu.keypressed(key)
    end
end 