-- décélération jusqu'à une vitesse nulle
function tween_quadratic_easingOut(t, b, c, d)
    t = t / d 
    return -c * t * (t-2) + b
end


function tweenUpdate(pTween, dt)
    if pTween.timer < pTween.duree then pTween.timer = pTween.timer + dt end 
    pTween.actu = tween_quadratic_easingOut(pTween.timer, pTween.depart, pTween.distance, pTween.duree)
end 

function newTween(pDepart, pDistance, pDuree)
    local tab = {}

    tab.timer = 0
    tab.depart = pDepart
    tab.distance = pDistance
    tab.duree = pDuree
    tab.actu = tab.depart

    tab.update = tweenUpdate

    return tab
end 
