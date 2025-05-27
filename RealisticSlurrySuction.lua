print("Realistic Slurry Suction loaded (v1.0.0.0)")

RealisticSlurrySuction = {}

-- Default suction rate in liters per millisecond (0.5 L/s fallback)
RealisticSlurrySuction.defaultRate = 100 / 1000

-- Fallback suction rates per vehicle (in liters per second)
RealisticSlurrySuction.vehicleRates = {
    ["data/vehicles/farmtech/supercis800/supercis800.xml"] = 80,
    ["data/vehicles/annaburger/aw2227/aw2227.xml"] = 100,
    ["data/vehicles/fliegl/pfw18000MaxxLinePlus/pfw18000MaxxLinePlus.xml"] = 100,
    ["data/vehicles/kaweco/profi2/profi2.xml"] = 120,
    ["data/vehicles/samsonAgro/pgII28Genesis/pgII28Genesis.xml"] = 130,
    ["data/vehicles/kotte/pq32000/pq32000.xml"] = 150,
    ["data/vehicles/wienhoff/ta25ProfiLine/ta25ProfiLine.xml"] = 120
}

-- Load custom suction rate from vehicle.xml
function RealisticSlurrySuction:loadFromXML(vehicle, xmlFilePath, key)
    if xmlFilePath == nil then
        print("RealisticSlurrySuction: No configFileName found for vehicle.")
        return
    end

    local xmlId = loadXMLFile("tempXML", xmlFilePath)
    if xmlId ~= nil and xmlId ~= 0 then
        local rate = getXMLFloat(xmlId, key .. "#rate")
        if rate ~= nil then
            vehicle.realisticSlurryFillRate = rate
            print("RealisticSlurrySuction: Loaded rate " .. tostring(rate) .. " L/s from XML: " .. xmlFilePath)
        else
            print("RealisticSlurrySuction: No <realisticSlurrySuction rate=...> found in XML: " .. xmlFilePath)
        end
        delete(xmlId)
    else
        print("RealisticSlurrySuction: Could not load XML file: " .. tostring(xmlFilePath))
    end
end

-- Determine suction rate from XML or fallback table
function RealisticSlurrySuction:getEffectiveRate(vehicle)
    if vehicle.realisticSlurryFillRate ~= nil then
        print("RealisticSlurrySuction: Using custom XML rate: " .. tostring(vehicle.realisticSlurryFillRate) .. " L/s")
        return vehicle.realisticSlurryFillRate / 1000
    end

    local configFile = vehicle.configFileName and vehicle.configFileName:lower() or ""
    for targetConfig, rateLps in pairs(self.vehicleRates) do
        if configFile == targetConfig:lower() then
            print("RealisticSlurrySuction: Using fallback table rate: " .. tostring(rateLps) .. " L/s for: " .. configFile)
            return rateLps / 1000
        end
    end

    print("RealisticSlurrySuction: Using default rate: " .. tostring(self.defaultRate * 1000) .. " L/s")
    return self.defaultRate
end

-- Debugging helper to inspect attached implements
function RealisticSlurrySuction:debugPrintAttachedImplements(vehicle)
    print("RealisticSlurrySuction: Debug - Attached implements from " .. (vehicle.configFileName or "unknown vehicle"))

    if vehicle.getAttachedImplements ~= nil then
        for i, implement in pairs(vehicle:getAttachedImplements()) do
            if implement.object ~= nil then
                local name = implement.object:getName() or "Unnamed"
                local cfg = implement.object.configFileName or "No configFileName"
                print(string.format("  [%d] Name: %s | configFileName: %s", i, name, cfg))
            else
                print(string.format("  [%d] Empty implement.object", i))
            end
        end
    else
        print("RealisticSlurrySuction: getAttachedImplements function not available.")
    end
end

-- Hooked into LoadTrigger to modify suction speed dynamically
function RealisticSlurrySuction:startLoadingModifier(fillType, fillableObject, fillUnitIndex)
    local fillTypeName = g_fillTypeManager.indexToName[fillType]

    if fillTypeName == "LIQUIDMANURE" or fillTypeName == "DIGESTATE" then
        local vehicle = fillableObject

        -- Detect correct implement if base vehicle has no configFileName
        if (vehicle.configFileName == nil or vehicle.configFileName == "") and fillableObject.getRootVehicle ~= nil then
            local root = fillableObject:getRootVehicle()
            RealisticSlurrySuction:debugPrintAttachedImplements(root)

            if root.getAttachedImplements ~= nil then
                for _, implement in pairs(root:getAttachedImplements()) do
                    if implement.object ~= nil and implement.object.configFileName ~= nil then
                        local configFile = implement.object.configFileName:lower()
                        if RealisticSlurrySuction.vehicleRates[configFile] ~= nil then
                            vehicle = implement.object
                            break
                        end
                    end
                end
            end
        end

        if vehicle ~= nil and vehicle.configFileName ~= nil then
            -- Load suction rate if not cached yet
            if vehicle.realisticSlurryFillRate == nil then
                RealisticSlurrySuction:loadFromXML(vehicle, vehicle.configFileName, "vehicle.realisticSlurrySuction")
            end

            local rate = RealisticSlurrySuction:getEffectiveRate(vehicle)
            self.fillLitersPerMS = rate
            print("RealisticSlurrySuction: Set fill rate on trigger: " .. tostring(rate * 1000) .. " L/s (" .. tostring(vehicle.configFileName) .. ")")

            -- Fass-to-fass suction logic (source vehicle rate limiting)
            local sourceVehicle = self.sourceObject or self.fillSourceObject
            if sourceVehicle ~= nil and sourceVehicle.getRootVehicle ~= nil then
                local rootSource = sourceVehicle:getRootVehicle()
                if rootSource ~= nil and rootSource.configFileName ~= nil then
                    if rootSource.realisticSlurryFillRate == nil then
                        RealisticSlurrySuction:loadFromXML(rootSource, rootSource.configFileName, "vehicle.realisticSlurrySuction")
                    end

                    local sourceRate = RealisticSlurrySuction:getEffectiveRate(rootSource)
                    if sourceRate ~= nil and rate ~= nil then
                        local limitedRate = math.min(rate, sourceRate)
                        self.fillLitersPerMS = limitedRate
                        print("RealisticSlurrySuction: Fass-to-Fass transfer – Limited by source rate: " .. tostring(limitedRate * 1000) .. " L/s")
                    end
                end
            end
        else
            print("RealisticSlurrySuction: No suitable vehicle with configFileName found.")
        end
    end
end

-- Hook into LoadTrigger.startLoading with our custom modifier
LoadTrigger.startLoading = Utils.prependedFunction(LoadTrigger.startLoading, RealisticSlurrySuction.startLoadingModifier)