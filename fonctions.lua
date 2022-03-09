function changeScene(pNewScene)

    _sceneOld = _sceneActu
    _sceneActu = pNewScene

    if _musiqueActu ~= nil and not _continueMusique then _musiqueActu:stop() end

    if _sceneActu.initialisation == nil then 
        _sceneActu.initialisation = true
        _sceneActu.init()
    end 

    if _sceneActu.load ~= nil then 
        _sceneActu.load()
    end 

end 

function changeEtat(pNewEtat)
    _etatOld = _etatActu
    _etatActu = pNewEtat
end 

function updateClic()
    if love.mouse.isDown(1) and not _clic then _clic = true end
    if not love.mouse.isDown(1) then _clic = false end
end 

function inArray(pTab, pValue)
    for k,v in pairs(pTab) do 
        if v == pValue then return true end 
    end
    return false
end

function playSound(pSon)
    if _sons then 
        pSon:stop()
        pSon:play()
    end 
end 

function playMusic(pMusique)
    if _musique then 
        pMusique:play()
    end
end 

function musique()
    if _musique and _musiqueActu ~= nil then 
        if not _musiqueActu:isPlaying() then _musiqueActu:play() end
    end
end 

function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

function newVector(pX, pY)
    local v = {}
    v.x = pX
    v.y = pY

    local vectorMT = {}

    -- Addition
    function vectorMT.__add(v1, v2)
        local r = newVector(0,0)
        r.x = v1.x + v2.x
        r.y = v1.y + v2.y
        return r
    end 
    -- Soustraction
    function vectorMT.__sub(v1, v2)
        local r = newVector(0,0)
        r.x = v1.x - v2.x 
        r.y = v1.y - v2.y 
        return r
    end
    -- Multiplication
    function vectorMT.__mul(k,v)
        local r = newVector(0,0)
        r.x = k * v.x
        r.y = k * v.y
        return r
    end
    -- Opposé d'un vecteur
    function vectorMT.__unm(v)
        local oppose = newVector(-v.x, -v.y)
        return oppose
    end
    setmetatable(v,vectorMT)
    -- Norme d'un vecteur
    function v.norme()
        return math.sqrt(v.x^2 + v.y^2)
    end
    -- Normalisation d'un vecteur
    function v.normalize()
        local N = v.norme()
        v.x = v.x / N 
        v.y = v.y / N
    end

    return v
end

function distance(aX, aY, bX, bY) return math.sqrt((bX - aX)^2 + (bY - aY)^2) end