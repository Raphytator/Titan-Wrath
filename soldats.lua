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
    local vitesseDeplSoldats = 15
    if math.floor(distance(pSoldat.position.x, pSoldat.position.y, pSoldat.arrivee.x, pSoldat.arrivee.y)) > 4 then 
        pSoldat.position = pSoldat.position + (dt / vitesseDeplSoldats) * pSoldat.parcours
    else 
        pSoldat.position.x = pSoldat.arrivee.x 
        pSoldat.position.y = pSoldat.arrivee.y 
        
        -- Attaque le joueur
        pSoldat.timerFrame = pSoldat.timerFrame + dt 
        local vitesseAttaqueSoldats = .5
        if pSoldat.timerFrame >= vitesseAttaqueSoldats then 
            pSoldat.timerFrame = 0
            pSoldat.frame = pSoldat.frame + 1
            if pSoldat.frame > #img.soldat[pSoldat.direction] then 
                pSoldat.frame = 1
                _toucheTitan = true 
                _degatsTitan = #pSoldat.soldats
            end 
        end 
    end

    pSoldat:updatePositionSoldats()
end 

function drawSoldats(pSoldat)

    for i=1, #pSoldat.soldats do 
        local s = pSoldat.soldats[i]
        love.graphics.draw(img.soldat[pSoldat.direction][pSoldat.frame], s.x, s.y, s.r, pSoldat.sx, pSoldat.sy, s.ox, s.oy)
    end
end 


function updateSoldatsPosition(pSoldats)
    pSoldats.x = pSoldats.position.x
    pSoldats.y = pSoldats.position.y

    local w = img.soldat[pSoldats.direction][pSoldats.frame]:getWidth() 
    local h = img.soldat[pSoldats.direction][pSoldats.frame]:getHeight() 

    local colonne1 = pSoldats.x - (w / 2) * 2
    local colonne2 = pSoldats.x - (w / 3)
    local colonne3 = pSoldats.x + (w / 3)
    local colonne4 = pSoldats.x + (w / 2) * 2

    local ligne1 = pSoldats.y - 25
    local ligne2 = pSoldats.y 
    local ligne3 = pSoldats.y + 25

    pSoldats.soldats[1].x = colonne1
    pSoldats.soldats[1].y = ligne1
    pSoldats.soldats[2].x = colonne2
    pSoldats.soldats[2].y = ligne1
    pSoldats.soldats[3].x = colonne3
    pSoldats.soldats[3].y = ligne1
    pSoldats.soldats[4].x = colonne4
    pSoldats.soldats[4].y = ligne1

    pSoldats.soldats[5].x = colonne1
    pSoldats.soldats[5].y = ligne2
    pSoldats.soldats[6].x = colonne2
    pSoldats.soldats[6].y = ligne2
    pSoldats.soldats[7].x = colonne3
    pSoldats.soldats[7].y = ligne2
    pSoldats.soldats[8].x = colonne4
    pSoldats.soldats[8].y = ligne2

    pSoldats.soldats[9].x = colonne1
    pSoldats.soldats[9].y = ligne3
    pSoldats.soldats[10].x = colonne2
    pSoldats.soldats[10].y = ligne3
    pSoldats.soldats[11].x = colonne3
    pSoldats.soldats[11].y = ligne3
    pSoldats.soldats[12].x = colonne4
    pSoldats.soldats[12].y = ligne3
end 

function newSoldats()
    local s = {}

    s.frame = 1
    s.direction = love.math.random(1, 5)
    s.angle = math.pi / 5 * s.direction - math.pi / 10
    s.timerFrame = 0

    s.r = 0
    s.sx = 1
    s.sy = 1

    if inArray({1, 2}, s.direction) then
        s.sx = -1
    end 

    local rayon = 800
    --local rayon = 300
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
    for i=1, 12 do  s.soldats[i] = { x = 0, y = 0, ox = img.soldat[s.direction][s.frame]:getWidth() / 2, oy = img.soldat[s.direction][s.frame]:getHeight() / 2} end

    updateSoldatsPosition(s)

    s.draw = drawSoldats
    s.update = updateSoldats
    s.updatePositionSoldats = updateSoldatsPosition

    return s

end 