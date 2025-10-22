-- Fonction pour savoir si un point est dans un polygone
local function isPointInPolygon(x, y, polygon)
    local inside = false
    local j = #polygon
    for i = 1, #polygon do
        if ((polygon[i].y > y) ~= (polygon[j].y > y)) and
           (x < (polygon[j].x - polygon[i].x) * (y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x) then
            inside = not inside
        end
        j = i
    end
    return inside
end

-- Récupérer les véhicules proches
local function GetNearbyVehicles(coords, radius)
    local nearby = {}
    local vehicles = GetGamePool("CVehicle") -- <-- correction ici
    for _, veh in pairs(vehicles) do
        local vx, vy, vz = table.unpack(GetEntityCoords(veh))
        if #(vector3(vx, vy, vz) - coords) <= radius then
            table.insert(nearby, veh)
        end
    end
    return nearby
end

-- Récupérer les peds proches
local function GetNearbyPeds(coords, radius)
    local nearby = {}
    local peds = GetGamePool("CPed") -- <-- correction ici
    for _, ped in pairs(peds) do
        if not IsPedAPlayer(ped) then
            local px, py, pz = table.unpack(GetEntityCoords(ped))
            if #(vector3(px, py, pz) - coords) <= radius then
                table.insert(nearby, ped)
            end
        end
    end
    return nearby
end

-- Dessiner la polyzone en debug
local function DrawPolyZone(zone)
    local points = zone.points
    local zMin = 0.0    -- base de la zone
    local zMax = 70.0   -- hauteur de la zone

    for i = 1, #points do
        local startPoint = points[i]
        local endPoint = points[i % #points + 1]

        -- Dessine des lignes verticales pour chaque coin
        for z = zMin, zMax, 1.0 do
            DrawLine(startPoint.x, startPoint.y, z, endPoint.x, endPoint.y, z, 0, 255, 0, 150)
        end

        -- Dessine un petit marker au sommet de chaque coin
        DrawMarker(2, startPoint.x, startPoint.y, zMax, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 0, 255, 0, 150, false, true, 2, false, nil, nil, false)
    end
end

-- Thread principal pour nettoyer les polyzones
CreateThread(function()
    while true do
        local sleep = 500
        if Config.Debug then sleep = 0 end

        for zoneName, zone in pairs(Config.PolyZones) do
            -- Centre approximatif pour filtrer les entités proches
            local centerX, centerY = 0, 0
            for _, point in pairs(zone.points) do
                centerX = centerX + point.x
                centerY = centerY + point.y
            end
            centerX = centerX / #zone.points
            centerY = centerY / #zone.points
            local center = vector3(centerX, centerY, 0)

            -- Supprimer véhicules
            if zone.clearVehicles then
                local nearbyVehicles = GetNearbyVehicles(center, zone.radiusCheck)
                for _, veh in pairs(nearbyVehicles) do
                    local vx, vy, vz = table.unpack(GetEntityCoords(veh))
                    if isPointInPolygon(vx, vy, zone.points) then
                        DeleteEntity(veh)
                    end
                end
            end

            -- Supprimer peds
            if zone.clearPeds then
                local nearbyPeds = GetNearbyPeds(center, zone.radiusCheck)
                for _, ped in pairs(nearbyPeds) do
                    local px, py, pz = table.unpack(GetEntityCoords(ped))
                    if isPointInPolygon(px, py, zone.points) then
                        DeleteEntity(ped)
                    end
                end
            end

            -- Affichage debug
            if Config.Debug then
                DrawPolyZone(zone)
            end
        end
        Wait(sleep)
    end
end)
