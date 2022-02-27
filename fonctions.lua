function changeScene(pNewScene)

    _sceneOld = _sceneActu
    _sceneActu = pNewScene

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

function getText(pTxt)
    local textReturn
    if _str[pTxt] == nil then 
        return "#"..pTxt.."#"
    else
        return _str[pTxt]
    end 
end 

function updateClic()
    if love.mouse.isDown(1) and not _clic then _clic = true end
    if not love.mouse.isDown(1) then _clic = false end
end 
