local img = {}

function initSoldats()

    img.spartiate_1_move = love.graphics.newImage("img/Spartiate_1_move.png")
    img.spartiate_1_attack = love.graphics.newImage("img/Spartiate_1_attack.png")

    img.soldat = {}
    img.soldat[1] = {img.spartiate_1_move, img.spartiate_1_attack}
    img.soldat[2] = {img.spartiate_1_move, img.spartiate_1_attack}
    img.soldat[3] = {love.graphics.newImage("img/Spartiate_2_move.png"), love.graphics.newImage("img/Spartiate_2_attack.png")}
    img.soldat[4] = {img.spartiate_1_move, img.spartiate_1_attack}
    img.soldat[5] = {img.spartiate_1_move, img.spartiate_1_attack}
end

function updateSoldats(pSoldat, dt)

    if math.floor(distance(pSoldat.position.x, pSoldat.position.y, pSoldat.arrivee.x, pSoldat.arrivee.y)) > 4 then 
        pSoldat.position = pSoldat.position + (dt / 15) * pSoldat.parcours
        --pSoldat.position = pSoldat.position + (dt ) * pSoldat.parcours
    else 
        pSoldat.position.x = pSoldat.arrivee.x 
        pSoldat.position.y = pSoldat.arrivee.y 
        
        -- Attaque le joueur

    end

    pSoldat:updatePositionSoldats()

end 

function drawSoldats(pSoldat)

    for i=1, #pSoldat.soldats do 
        local s = pSoldat.soldats[i]
        love.graphics.draw(img.soldat[pSoldat.direction][pSoldat.frame], s.x, s.y, s.r, pSoldat.sx, pSoldat.sy, s.ox, s.oy)

        drawRectangle("fill", pSoldat.arrivee.x, pSoldat.arrivee.y, 20, 20, {1,0,0,1})
    end 

end 


function updateSoldatsPosition(pSoldats)
    pSoldats.x = pSoldats.position.x
    pSoldats.y = pSoldats.position.y

    pSoldats.soldats[1] = { x = pSoldats.x - img.soldat[pSoldats.direction][pSoldats.frame]:getWidth(), y = pSoldats.y - 25}
    pSoldats.soldats[2] = { x = pSoldats.x - img.soldat[pSoldats.direction][pSoldats.frame]:getWidth() / 2, y = pSoldats.y - 25}
    pSoldats.soldats[3] = { x = pSoldats.x, y = pSoldats.y - 25}
    pSoldats.soldats[4] = { x = pSoldats.x + img.soldat[pSoldats.direction][pSoldats.frame]:getWidth() / 2, y = pSoldats.y - 25}

    pSoldats.soldats[5] = { x = pSoldats.x - img.soldat[pSoldats.direction][pSoldats.frame]:getWidth(), y = pSoldats.y}
    pSoldats.soldats[6] = { x = pSoldats.x - img.soldat[pSoldats.direction][pSoldats.frame]:getWidth() / 2, y = pSoldats.y}
    pSoldats.soldats[7] = { x = pSoldats.x, y = pSoldats.y}
    pSoldats.soldats[8] = { x = pSoldats.x + img.soldat[pSoldats.direction][pSoldats.frame]:getWidth() / 2, y = pSoldats.y }

    pSoldats.soldats[9] = { x = pSoldats.x - img.soldat[pSoldats.direction][pSoldats.frame]:getWidth() , y = pSoldats.y + 25}
    pSoldats.soldats[10] = { x = pSoldats.x - img.soldat[pSoldats.direction][pSoldats.frame]:getWidth() / 2, y = pSoldats.y + 25}
    pSoldats.soldats[11] = { x = pSoldats.x, y = pSoldats.y + 25}
    pSoldats.soldats[12] = { x = pSoldats.x + img.soldat[pSoldats.direction][pSoldats.frame]:getWidth() / 2, y = pSoldats.y + 25}
end 

function newSoldats()
    local s = {}

    s.frame = 1
    s.direction = love.math.random(1, 5)
    --s.direction = 5
    s.angle = math.pi / 5 * s.direction - math.pi / 10

    s.r = 0
    s.sx = 1
    s.sy = 1

    if inArray({1, 2}, s.direction) then
        s.sx = -1
     end 

    s.ox = img.soldat[s.direction][s.frame]:getWidth() / 2
    s.oy = img.soldat[s.direction][s.frame]:getHeight() / 2
    
    --local rayon = 800
    local rayon = 300
    local posYOrigine = 265
    s.x = rayon * math.cos(s.angle) + _ecran.w / 2
    s.y = rayon * math.sin(s.angle) + posYOrigine 

        
    local distanceArrivee = 80
    local arriveeX = distanceArrivee * math.cos(s.angle) + _ecran.w / 2
    local arriveeY = distanceArrivee * math.sin(s.angle) + posYOrigine

    s.depart = newVector(s.x, s.y)
    s.arrivee = newVector(arriveeX, arriveeY)
    s.parcours = s.arrivee - s.depart
    s.position = s.depart


    s.soldats = {}
    for i=1, 12 do  s.soldats[i] = { x = 0, y = 0 } end

    updateSoldatsPosition(s)

    s.draw = drawSoldats
    s.update = updateSoldats
    s.updatePositionSoldats = updateSoldatsPosition

    return s

end 
