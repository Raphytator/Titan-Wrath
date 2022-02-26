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