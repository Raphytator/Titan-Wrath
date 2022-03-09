--[[
████████╗██╗████████╗ █████╗ ███╗   ██╗    ██╗    ██╗██████╗  █████╗ ████████╗██╗  ██╗
╚══██╔══╝██║╚══██╔══╝██╔══██╗████╗  ██║    ██║    ██║██╔══██╗██╔══██╗╚══██╔══╝██║  ██║
   ██║   ██║   ██║   ███████║██╔██╗ ██║    ██║ █╗ ██║██████╔╝███████║   ██║   ███████║
   ██║   ██║   ██║   ██╔══██║██║╚██╗██║    ██║███╗██║██╔══██╗██╔══██║   ██║   ██╔══██║
   ██║   ██║   ██║   ██║  ██║██║ ╚████║    ╚███╔███╔╝██║  ██║██║  ██║   ██║   ██║  ██║
   ╚═╝   ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
                                                                                      
    - Löve Gamejam 2022
    - Developped by Babbou, Bsy, Lysenti & Raphytator
    - February / March 2022
]]

io.stdout:setvbuf("no")

require("gui")
require("fonctions")
require("init")
require("tweening")
require("soldats")


function love.load()
    init()
end 

function love.update(dt)
    musique()
    dt = math.min(dt, 1/60)
    _mouse.x, _mouse.y = love.mouse.getPosition()
    fadeUpdate(dt)
    _sceneActu.update(dt)
    updateClic()
end

function love.draw()
    love.graphics.scale(_scale)
    _sceneActu.draw()
    fadeDraw() 
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

function love.mousepressed(x, y, button, istouch, presses)
    if _sceneActu.mousepressed ~= nil then
        _sceneActu.mousepressed(x, y, button, istouch, presses)
    end 
end 
