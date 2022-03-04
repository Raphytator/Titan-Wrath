local shockwave = {}

local shockwave_shader, shockwave_code
local intensity, diameter, time, isShocking
local area, aoe, speed


function shockwave.init()

    shockwave_code = love.filesystem.read("shockwave.glsl")
    shockwave_shader = love.graphics.newShader(shockwave_code)
    diameter = 0.1
    time = 0.0
    area = 0.0
    aoe = false
    speed = 1.0

end


function shockwave.update(dt)

    time = time + dt
    diameter = diameter + dt*speed
    
end


function shockwave.draw()

    shockwave_shader:send("diameter", diameter)
    shockwave_shader:send("time", time)
    shockwave_shader:send("area", area)
    shockwave_shader:send("aoe", aoe)
    love.graphics.setShader(shockwave_shader)
    
end


function shockwave.launch(pAoe, pArea)
    
    if pAoe then
        aoe = true
    else
        area = pArea or 3.0
    end

end


function shockwave.setSpeed(pSpeed)

    speed = pSpeed or 1.0

end


function shockwave.send(pX, pY)

    shockwave_shader:send("shake", {pX, pY})
    
end

function shockwave.reload()

    diameter = 0.1
    time = 0.0
    aoe = false

end


return shockwave