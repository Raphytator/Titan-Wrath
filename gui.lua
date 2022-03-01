--[[
██████╗ ██████╗ ██╗███╗   ███╗██╗████████╗██╗██╗   ██╗███████╗███████╗
██╔══██╗██╔══██╗██║████╗ ████║██║╚══██╔══╝██║██║   ██║██╔════╝██╔════╝
██████╔╝██████╔╝██║██╔████╔██║██║   ██║   ██║██║   ██║█████╗  ███████╗
██╔═══╝ ██╔══██╗██║██║╚██╔╝██║██║   ██║   ██║╚██╗ ██╔╝██╔══╝  ╚════██║
██║     ██║  ██║██║██║ ╚═╝ ██║██║   ██║   ██║ ╚████╔╝ ███████╗███████║
╚═╝     ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚═╝   ╚═╝   ╚═╝  ╚═══╝  ╚══════╝╚══════╝
]]

function drawRectangle(pType, pX, pY, pW, pH, pColor)
    love.graphics.setColor(pColor)
    love.graphics.rectangle(pType, pX, pY, pW, pH)
    love.graphics.setColor(1,1,1,1)
end 

function drawVoile(pAlpha)
    local alpha
    if pAlpha ~= nil then alpha = pAlpha else alpha = .6 end 
    drawRectangle("fill", 0, 0, _ecran.w, _ecran.h, {0,0,0,alpha})
end

--[[
████████╗███████╗██╗  ██╗████████╗███████╗███████╗
╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝██╔════╝██╔════╝
   ██║   █████╗   ╚███╔╝    ██║   █████╗  ███████╗
   ██║   ██╔══╝   ██╔██╗    ██║   ██╔══╝  ╚════██║
   ██║   ███████╗██╔╝ ██╗   ██║   ███████╗███████║
   ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝
                                                  
]]

function getText(pTxt)
    local textReturn
    if _str[pTxt] == nil then 
        return "#"..pTxt.."#"
    else
        return _str[pTxt]
    end 
end 

function txtPrint(pTxt)
    love.graphics.setFont(pTxt.font)
    love.graphics.setColor(pTxt.color)
    if pTxt.align == nil then 
        love.graphics.print(getText(pTxt.txt), pTxt.x, pTxt.y)
    else 
        love.graphics.printf(getText(pTxt.txt), pTxt.x, pTxt.y, pTxt.limit, pTxt.align)
    end 
    love.graphics.setColor(1,1,1,1)
end 

function newTxt(pText, pFont, pX, pY, pColor, pLimit, pAlign)
    local txt = {}

    txt.txt = tostring(pText)
    txt.font = pFont
    txt.x = pX 
    txt.y = pY
    txt.w = pFont:getWidth(pText)
    local c 
    if pColor ~= nil then c = pColor else c = {0,0,0,1} end 
    txt.color = c 
    txt.limit = pLimit 
    txt.align = pAlign 
        
    -- Fonctions 
    txt.print = txtPrint 

    return txt 
end 

--[[

 ███████╗ █████╗ ██████╗ ███████╗
 ██╔════╝██╔══██╗██╔══██╗██╔════╝
 █████╗  ███████║██║  ██║█████╗  
 ██╔══╝  ██╔══██║██║  ██║██╔══╝  
 ██║     ██║  ██║██████╔╝███████╗
 ╚═╝     ╚═╝  ╚═╝╚═════╝ ╚══════╝
                                 
]]

function fadeInitialisation()
    _fade = { fadeIn = false, fadeOut = false, fadeEnd = false, alphaTransition = 0, sortie = "" }
end

function fadeUpdate(dt)    
    local vitesseFondu = 3
    if _fade.fadeIn and not _fade.fadeOut then 
        _fade.alphaTransition = _fade.alphaTransition - dt * vitesseFondu    
        
        if _fade.alphaTransition <= 0 then 
            _fade.alphaTransition = 0 
            _fade.fadeIn = false 
            --_fade.fadeEnd = true
        end
    elseif not _fade.fadeIn and _fade.fadeOut then 
        _fade.alphaTransition = _fade.alphaTransition + dt * vitesseFondu

        if _fade.alphaTransition >= 1 then 
            _fade.alphaTransition = 1
            _fade.fadeOut = false
            _fade.fadeEnd = true
        end 
    end 
end 

function fadeIn()
    _fade.alphaTransition = 1
    _fade.fadeIn = true
end 

function fadeOut(pSortie)
    _fade.fadeOut = true
    _fade.sortie = pSortie
end

function fadeDraw()
    if _fade.fadeIn or _fade.fadeOut or _fade.fadeEnd then drawRectangle("fill", 0, 0, _ecran.w, _ecran.h, {0,0,0, _fade.alphaTransition}) end
end

--[[
██████╗  ██████╗ ██╗   ██╗████████╗ ██████╗ ███╗   ██╗███████╗
██╔══██╗██╔═══██╗██║   ██║╚══██╔══╝██╔═══██╗████╗  ██║██╔════╝
██████╔╝██║   ██║██║   ██║   ██║   ██║   ██║██╔██╗ ██║███████╗
██╔══██╗██║   ██║██║   ██║   ██║   ██║   ██║██║╚██╗██║╚════██║
██████╔╝╚██████╔╝╚██████╔╝   ██║   ╚██████╔╝██║ ╚████║███████║
╚═════╝  ╚═════╝  ╚═════╝    ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚══════╝
                                                              
]]

function btnDraw(pBtn)
    local color
    if pBtn.type == "img" then    
        if pBtn.pressed then
            pBtn.img = pBtn.imgPressed
            color = {1,1,1,1}         
        elseif pBtn.hover then
            pBtn.img = pBtn.imgHover   
            color = {1,1,0,1}     
        else
            pBtn.img = pBtn.imgDefault
            color = {0,0,0,1}
        end
        love.graphics.draw(pBtn.img, pBtn.x, pBtn.y, pBtn.r, pBtn.sx, pBtn.sy, pBtn.ox, pBtn.oy)
        
        if pBtn.txt ~= nil then
            love.graphics.setColor(color)
            love.graphics.setFont(pBtn.font)
            love.graphics.printf(getText(pBtn.txt), pBtn.x, pBtn.y, pBtn.img:getWidth(), "center")
            
            love.graphics.setColor(1,1,1,1)
        end     
    elseif pBtn.type == "txt" then 
        if pBtn.pressed then
            color = pBtn.colorPressed
        elseif pBtn.hover then
            color = pBtn.colorHover
        else
            color = pBtn.color
        end

        love.graphics.setColor(color)
        love.graphics.setFont(pBtn.font)
        love.graphics.print(getText(pBtn.txt), pBtn.x, pBtn.y)
        love.graphics.setColor(1,1,1,1)
    elseif pBtn.type == "chkbox" then
        if pBtn.checked then
            pBtn.img = pBtn.imgCheck
        else
            pBtn.img = pBtn.imgNoCheck
        end
        love.graphics.draw(pBtn.img, pBtn.x, pBtn.y)
    end
end

function btnUpdate(pBtn, pEvent, pVar)  
    if _mouse.x / _scale>= pBtn.x - pBtn.ox and
        _mouse.x / _scale <= (pBtn.x - pBtn.ox + pBtn.w) and
        _mouse.y / _scale >= pBtn.y - pBtn.oy and
        _mouse.y / _scale <= (pBtn.y - pBtn.oy + pBtn.h) then

        pBtn.hover = true
        --imgCurseurActu = _img.curseurSelect
        --pBtn.font = fonts.btnH
    else
        pBtn.hover = false
        pBtn.pressed = false
        --pBtn.font = fonts.btn
    end
    
    if pBtn.hover and not pBtn.pressed and (love.mouse.isDown(1) and not _clic) then
        pBtn.pressed = true
        pBtn.hover = false

        if pBtn.sfx ~= nil then
            playSound(pBtn.sfx)
        end

        if pBtn.type == "chkbox" then
            pBtn.checked = not pBtn.checked
        end
        
        if pEvent ~= nil then 
            pBtn.pressed = false
            if pVar ~= nil then 
                pEvent(pVar[1], pVar[2], pVar[3], pVar[4])
            else 
                pEvent()
            end
        end
    end
    if not love.mouse.isDown(1) then pBtn.pressed = false end
end

function btnAddSfx(pBtn, pSfx)
    pBtn.sfx = pSfx
end

function newBtn(type, x, y, ...)

    -- btn img          => (image, imageHover, imagePressed, text, font, color)
    -- btn txt          => (texte, font, color, colorHover, colorPressed)
    -- btn chkbox       => (imgNoCheck, imgCheck, check)

    local tab = {}
    tab.x = x
    tab.y = y  
    tab.type = type
    tab.hover = false
    tab.pressed = false
    tab.r = 0
    tab.sx = 1
    tab.sy = 1
    tab.ox = 0
    tab.oy = 0   
    tab.sfx = _sfx.clic

    local p = {...}
        
    if type == "img" then        
        tab.imgDefault = p[1]

        if p[2] ~= nil then tab.imgHover = p[2]
        else tab.imgHover = p[1] end 

        if p[3] ~= nil then tab.imgPressed = p[3]
        else tab.imgPressed = p[1] end

        tab.img = tab.imgDefault
        tab.w = tab.imgDefault:getWidth()
        tab.h = tab.imgDefault:getHeight()

        if p[4] ~= nil then tab.txt = p[4] end
        if p[5] ~= nil then tab.font = p[5] else tab.font = _fonts.btn end 
    elseif type == "txt" then
        tab.txt = p[1]
        tab.font = p[2]

        if p[3] ~= nil then tab.color = p[3]
        else tab.color = {0,0,0,1} end 

        if p[4] ~= nil then tab.colorHover = p[4]
        else tab.colorHover = {1,1,0,1} end 

        if p[5] ~= nil then tab.colorPressed = p[5]
        else tab.colorPressed = {1,1,1,1} end
    elseif type == "chkbox" then
        
        tab.imgNoCheck = p[1]
        tab.imgCheck = p[2]
        tab.img = tab.imgNoCheck
        tab.w = tab.img:getWidth()
        tab.h = tab.img:getHeight()

        if p[3] ~= nil then tab.checked = p[3] else tab.checked = false end
    end
    
    -- Fonctions
    tab.draw = btnDraw
    tab.update = btnUpdate
    tab.addSfx = btnAddSfx    

    return tab
end

--[[
███████╗██████╗ ██████╗ ██╗████████╗███████╗
██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔════╝
███████╗██████╔╝██████╔╝██║   ██║   █████╗  
╚════██║██╔═══╝ ██╔══██╗██║   ██║   ██╔══╝  
███████║██║     ██║  ██║██║   ██║   ███████╗
╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝
                                            
]]

function drawSprite(tab)
    love.graphics.setColor(1,1,1,tab.alpha)
    love.graphics.draw(tab.img, tab.x, tab.y, tab.r, tab.sx, tab.sy, tab.ox, tab.oy)
end 

function newSprite(image, x, y, alpha, oxy)
    local tab = {}

    tab.img = image    
    tab.x = x 
    tab.y = y 
    tab.color = {}
    tab.sx = 1
    tab.sy = 1

    if oxy then 
        tab.ox = image:getWidth() / 2
        tab.oy = image:getHeight() / 2
    else 
        tab.ox = 0
        tab.oy = 0
    end 

    tab.r = 0

    if alpha ~= nil then 
        tab.alpha = alpha
    else 
        tab.alpha = 1
    end

    tab.draw = drawSprite

    return tab
end 

--[[
 ██████╗ █████╗ ██████╗ ██████╗ ███████╗███████╗
██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝
██║     ███████║██║  ██║██████╔╝█████╗  ███████╗
██║     ██╔══██║██║  ██║██╔══██╗██╔══╝  ╚════██║
╚██████╗██║  ██║██████╔╝██║  ██║███████╗███████║
 ╚═════╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝
                                                
]]

function drawCadre(pCadre)

    love.graphics.setColor(1, 1, 1, pCadre.alpha)

    -- Côté gauche
    love.graphics.draw(_img.tilesetCadre, _quad.cadre[1], pCadre.x, pCadre.y, 0, pCadre.sx, pCadre.sy, pCadre.ox, pCadre.oy)  
    for l=1, pCadre.l do
        love.graphics.draw(_img.tilesetCadre, _quad.cadre[4], pCadre.x, pCadre.y + (_tailleElemCadre * l), 0, pCadre.sx, pCadre.sy, pCadre.ox, pCadre.oy)
    end  
    love.graphics.draw(_img.tilesetCadre, _quad.cadre[7], pCadre.x, pCadre.y + (_tailleElemCadre * pCadre.l) + _tailleElemCadre, 0, pCadre.sx, pCadre.sy, pCadre.ox, pCadre.oy)

    -- Milieu Haut et Bas
    for c=1, pCadre.c do
        love.graphics.draw(_img.tilesetCadre, _quad.cadre[2], pCadre.x + (_tailleElemCadre * c), pCadre.y, 0, pCadre.sx, pCadre.sy, pCadre.ox, pCadre.oy)
        love.graphics.draw(_img.tilesetCadre, _quad.cadre[8], pCadre.x + (_tailleElemCadre * c), pCadre.y + (_tailleElemCadre * pCadre.l) + _tailleElemCadre, 0, pCadre.sx, pCadre.sy, pCadre.ox, pCadre.oy)
    end

    for l=1, pCadre.l do
        for c=1, pCadre.c + 1 do
            love.graphics.draw(_img.tilesetCadre, _quad.cadre[5], pCadre.x + (_tailleElemCadre * c), pCadre.y + (_tailleElemCadre * l), 0, pCadre.sx, pCadre.sy, pCadre.ox, pCadre.oy)
        end
    end

    -- Coté droit
    love.graphics.draw(_img.tilesetCadre, _quad.cadre[3], pCadre.x + (_tailleElemCadre * pCadre.c) + _tailleElemCadre, pCadre.y, 0, pCadre.sx, pCadre.sy, pCadre.ox, pCadre.oy)
    for l=1, pCadre.l do
        love.graphics.draw(_img.tilesetCadre, _quad.cadre[6], pCadre.x + (_tailleElemCadre * pCadre.c) + _tailleElemCadre, pCadre.y + (_tailleElemCadre * l), 0, pCadre.sx, pCadre.sy, pCadre.ox, pCadre.oy)
    end  
    love.graphics.draw(_img.tilesetCadre, _quad.cadre[9], pCadre.x + (_tailleElemCadre * pCadre.c) + _tailleElemCadre, pCadre.y + (_tailleElemCadre * pCadre.l) + _tailleElemCadre, 0, pCadre.sx, pCadre.sy, pCadre.ox, pCadre.oy)

    love.graphics.setColor(1, 1, 1, 1)
end 

function newCadre(x, y, c, l)
    local cadre = {}
    cadre.x = x
    cadre.y = y
    cadre.c = c
    cadre.l = l
    cadre.ox = 0
    cadre.oy = 0
    cadre.sx = 1
    cadre.sy = 1
    cadre.w = _tailleElemCadre * (c + 2)
    cadre.h = _tailleElemCadre * (l + 2)
    cadre.alpha = 1

    cadre.draw = drawCadre

    return cadre
end

function initCadre()
    _img.tilesetCadre = love.graphics.newImage("img/cadre.png")
    _tailleElemCadre = _img.tilesetCadre:getWidth() / 3
    _quad.cadre = {}
    local n = 1
    for i=1, 3 do 
        for j=1, 3 do 
            _quad.cadre[n] = love.graphics.newQuad((j-1)*_tailleElemCadre, (i-1)*_tailleElemCadre, _tailleElemCadre, _tailleElemCadre, _img.tilesetCadre:getWidth(), _img.tilesetCadre:getHeight())
            n = n + 1 
        end 
    end 
end

function centrageCadre(axe, val)
    local result, axeEcran 
    if axe == "x" then
        axeEcran = _ecran.w        
    elseif axe == "y" then 
        axeEcran = _ecran.h
    end 
    result = (axeEcran - (_tailleElemCadre * (val + 2))) / 2
    return result
end 