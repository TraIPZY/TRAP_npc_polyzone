Config = {}

-- Activer le debug pour afficher les zones en jeu
Config.Debug = true

-- Liste des polyzones
Config.PolyZones = {
    test = {
        points = {
            {x = -2054.4846, y = -432.3635},
            {x = -1989.6630, y = -485.7856},
            {x = -2051.7283, y = -562.8635},
            {x = -2120.6768, y = -510.3206}
        },
        clearVehicles = true,
        clearPeds = true,
        radiusCheck = 150.0 -- rayon pour optimiser la recherche
    }
}
