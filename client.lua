-- Include la config
-- Assurez-vous que config.lua est chargé avant ce client dans le fxmanifest

-- Fonction pour vérifier si un point est dans un polygone
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

-- Dessiner le mur vert pour le debug
local function DrawPolyZone(zone)
    local points = zone.points
    local zMin, zMax = 0.0, 12.0
    for i = 1, #points do
        local startPoint = points[i]
        local endPoint = points[i % #points + 1]
        for z = zMin, zMax, 1.0 do
            DrawLine(startPoint.x, startPoint.y, z, endPoint.x, endPoint.y, z, 0, 255, 0, 150)
        end
    end
end

-- Thread principal pour nettoyer les NPC
CreateThread(function()
    while true do
        local sleep = 500
        if Config.Debug then sleep = 0 end

        for _, zone in pairs(Config.PolyZones) do

            -- Supprimer véhicules NPC
            if zone.clearVehicles then
                for _, veh in pairs(GetGamePool("CVehicle")) do
                    local driver = GetPedInVehicleSeat(veh, -1)
                    if driver == 0 or not IsPedAPlayer(driver) then
                        local vx, vy, vz = table.unpack(GetEntityCoords(veh))
                        if isPointInPolygon(vx, vy, zone.points) then
                            DeleteEntity(veh)
                        end
                    end
                end
            end

            -- Supprimer Peds NPC
            if zone.clearPeds then
                for _, ped in pairs(GetGamePool("CPed")) do
                    if not IsPedAPlayer(ped) then
                        local px, py, pz = table.unpack(GetEntityCoords(ped))
                        if isPointInPolygon(px, py, zone.points) then
                            DeleteEntity(ped)
                        end
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
