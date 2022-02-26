io.stdout:setvbuf("no")

require("init")

function love.load()
    init()
end 

function love.update(dt)

end

function love.draw()

end

function love.keypressed(key)
    if key == "f11" then 
        love.event.quit("restart")
    elseif key == "f12" then 
        love.event.quit()
    end
end 