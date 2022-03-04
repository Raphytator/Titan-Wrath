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
    if pSoldat.live and not pSoldat.fall then 
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

    if pSoldat.fall then 
        pSoldat.timerFall = pSoldat.timerFall + dt 
        if pSoldat.timerFall > .8 then 
            pSoldat.timerFall = 0
            pSoldat.r = 0
            pSoldat.fall = false 
        end
    end 
end 

function drawSoldats(pSoldat)

    for i=1, #pSoldat.soldats do 
        local s = pSoldat.soldats[i]
        if s.live then 
            love.graphics.draw(img.soldat[pSoldat.direction][pSoldat.frame], s.x, s.y, pSoldat.r, pSoldat.sx, pSoldat.sy, s.ox, s.oy)
            
        end
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

function recoitDegatsSoldats(pSoldats, pDegats, pFall)

    if pDegats > 0 then playSound(_sfx.splash) end

    for i=1, pDegats do 
        if #pSoldats.restants > 0 then 
            local nb = love.math.random(1, #pSoldats.restants)
            local id = pSoldats.restants[nb]
            table.remove(pSoldats.restants, nb)
            pSoldats.soldats[id].live = false
            
            ajoutParticules(pSoldats.soldats[id])
        end
    end 

    if #pSoldats.restants == 0 then 
        pSoldats.live = false
    else 
        if pFall then 
            pSoldats.fall = true
            pSoldats.timerFall = 0
            pSoldats.r = math.pi / 2
        end
    end
end 

function newSoldats()
    local s = {}

    s.frame = 1
    s.direction = love.math.random(1, 5)

    local angleSpe, milieuAngle 
    if s.direction == 1 then 
        angleSpe = math.pi / 6
        milieuAngle = -math.pi / 12 
    elseif s.direction == 2 then 
        angleSpe = 11 * math.pi / 30
        milieuAngle = -math.pi / 10
    elseif s.direction == 3 then 
        angleSpe = 19 * math.pi / 30
        milieuAngle = -2*math.pi / 15
    elseif s.direction == 4 then 
        angleSpe = 5 * math.pi / 6
        milieuAngle = -math.pi / 10
    elseif s.direction == 5 then 
        angleSpe = math.pi
        milieuAngle = -math.pi / 12
    end 

    --s.angle = math.pi / 5 * s.direction - math.pi / 10
    s.angle = angleSpe + milieuAngle 
    s.timerFrame = 0
    s.fall = false
    s.timerFall = 0
    s.live = true

    s.r = 0
    s.sx = 1
    s.sy = 1

    if inArray({1, 2}, s.direction) then
        s.sx = -1
    end 

    local rayon = 800
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
    for i=1, 12 do  s.soldats[i] = { x = 0, y = 0, ox = img.soldat[s.direction][s.frame]:getWidth() / 2, oy = img.soldat[s.direction][s.frame]:getHeight() / 2, live = true} end

    s.restants = {1,2,3,4,5,6,7,8,9,10,11,12}

    updateSoldatsPosition(s)

    s.draw = drawSoldats
    s.update = updateSoldats
    s.updatePositionSoldats = updateSoldatsPosition
    s.recoitDegats = recoitDegatsSoldats

    return s

end 
