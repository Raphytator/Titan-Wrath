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

function drawVoile()
    drawRectangle("fill", 0, 0, _ecran.w, _ecran.h, {0,0,0,0.6})
end

--[[
████████╗███████╗██╗  ██╗████████╗███████╗███████╗
╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝██╔════╝██╔════╝
   ██║   █████╗   ╚███╔╝    ██║   █████╗  ███████╗
   ██║   ██╔══╝   ██╔██╗    ██║   ██╔══╝  ╚════██║
   ██║   ███████╗██╔╝ ██╗   ██║   ███████╗███████║
   ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝
                                                  
]]

function txtPrint(pTxt)
    love.graphics.setFont(pTxt.font)
    love.graphics.setColor(pTxt.color)
    if pTxt.align == nil then 
        love.graphics.print(pTxt.txt, pTxt.x, pTxt.y)
    else 
        love.graphics.printf(pTxt.txt, pTxt.x, pTxt.y, pTxt.limit, pTxt.align)
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
            _fade.fadeEnd = true
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
            pBtn.img = pBtn.imgDefault            
        elseif pBtn.hover then
            pBtn.img = pBtn.imgHover            
        else
            pBtn.img = pBtn.imgDefault
        end
        love.graphics.draw(pBtn.img, pBtn.x, pBtn.y, pBtn.r, pBtn.sx, pBtn.sy, pBtn.ox, pBtn.oy)
        
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
        love.graphics.print(pBtn.txt, pBtn.x, pBtn.y)
        love.graphics.setColor(1,1,1,1)
    end
end

function btnUpdate(pBtn, pEvent, pVar)               
    if _mouse.x >= pBtn.x - pBtn.ox and
        _mouse.x <= (pBtn.x - pBtn.ox + pBtn.w) and
        _mouse.y >= pBtn.y - pBtn.oy and
        _mouse.y <= (pBtn.y - pBtn.oy + pBtn.h) then

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

        if pBtn.son ~= nil then
            pBtn.son:stop()
            pBtn.son:play()
        end
        
        if pEvent ~= nil then 
            if pVar ~= nil then 
                pEvent(pVar[1], pVar[2], pVar[3], pVar[4])
            else 
                pEvent()
            end
        end
    end
    if not love.mouse.isDown(1) then pBtn.pressed = false end
end

function newBtn(type, x, y, ...)

    -- btn img          => (image, imageHover, imagePressed, text, font, color)
    -- btn txt          => (texte, font, color, colorHover, colorPressed)

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
    end
    
    -- Fonctions
    tab.draw = btnDraw
    tab.update = btnUpdate          

    return tab
end