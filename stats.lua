local stats = {}

stats.pvMaxTitan = 250
stats.nbVagues = 5
stats.nbSoldats = {1, 8, 12, 16, 25}
stats.cooldown = { .8, 5, 20 }
stats.degatsZones = {
    [1] = {5, 3, 1, 0},
    [2] = {6, 4, 2, 1},
    [3] = {3, 2, 1, 1}
}
stats.vaches = {
    pv = 8,
    gain = 80,
    vitesse = 45
}

return stats