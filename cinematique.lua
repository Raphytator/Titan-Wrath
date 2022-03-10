local cinematique = {}

local sprite = {}
local txt = {}
local btn = {}

local alphaVoile = 0

function cinematique.init()
    sprite.diapo = {}
    sprite.diapo[1] = newSprite(love.graphics.newImage("img/diapo_1.jpg"), 0, 0)
    sprite.diapo[2] = newSprite(love.graphics.newImage("img/diapo_2.jpg"), 0, 0)
    sprite.diapo[3] = newSprite(love.graphics.newImage("img/diapo_3.jpg"), 0, 0)

    txt.diapo = {}
    local h = 580
    local h = 550
    txt.diapo[1] = newTxt("diapo1", _fonts.texte, 15, h, {.9,.9,.9,1}, _ecran.w - 30, "center")
    txt.diapo[2] = newTxt("diapo2", _fonts.texte2, 15, h + 45, {.9,.9,.9,1}, _ecran.w - 30, "center")
    txt.diapo[3] = newTxt("diapo3", _fonts.texte, 15, h, {.9,.9,.9,1}, _ecran.w - 30, "center")

    btn.continue = newBtn("img", _ecran.w - _img.btn:getWidth() - 25, _ecran.h - _img.btn:getHeight() - 15, _img.btn, _img.btnHover, _img.btnPressed, "continuer")
    
end

function cinematique.load()
    _continueMusique = true
end


function cinematique.update(dt)

    if not _fade.fadeIn and not _fade.fadeOut then    
        btn.continue:update(cinematique.suivante)
    end 

    if _fade.fadeEnd then 
        _fade.fadeEnd = false 
        _fade.alphaTransition = 0

        if _fade.sortie == "suivant" then 
            _etatActu = 2
        elseif _fade.sortie == "jeu" then 
            _continueMusique = false
            changeScene(_scenes.jeu)            
        elseif _fade.sortie == "menuPrincipal" then
            _musiqueActu = _music.menu
            _continueMusique = true
            changeScene(_scenes.menuPrincipal)
            changeEtat("menuPrincipal")
        end 
        fadeIn()
    end
end 

function cinematique.draw()

    sprite.diapo[_etatActu]:draw()
    txt.diapo[_etatActu]:print()
    
    btn.continue:draw() 
    
end 

function cinematique.suivante()
    if _etatActu == 1 then 
        fadeOut("suivant")       
    elseif _etatActu == 2 then 
        fadeOut("jeu")
    elseif _etatActu == 3 then 
        fadeOut("menuPrincipal")        
    end 

end 


return cinematique 