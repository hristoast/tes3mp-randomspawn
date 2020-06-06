local RandomSpawn = {}

local scriptName = "RandomSpawn"

-- THANKS: https://github.com/Texafornian/ccSuite/blob/ce2d81d156e4d05c8139499549ca3c6d5f51baf1/scripts/custom/ccsuite/ccConfig.lua#L279-L302
-- List of cells/locations where players can randomly spawn after chargen.
-- Format (cells): { "cell ID", Xcoord, Ycoord, Zcoord, Zrot, "displayed name" }
local VanillaSpawns = {
    { "-3, 6", -16523, 54362, 1973, 2.73, "Ald'Ruhn" },
    { "-11, 15", -89353, 128479, 110, 1.86, "Ald Velothi" },
    { "-3, -3", -20986, -17794, 865, -0.87, "Balmora" },
    { "-2, 2", -12238, 20554, 1514, -2.77, "Caldera" },
    { "7, 22", 62629, 185197, 131, -2.83, "Dagon Fel" },
    { "2, -13", 20769, -103041, 107, -0.87, "Ebonheart" },
    { "-8, 3", -58009, 26377, 52, -1.49, "Gnaar Mok" },
    { "-11, 11", -86910, 90044, 1021, 0.44, "Gnisis" },
    { "-6, -5", -49093, -40154, 78, 0.94, "Hla Oad" },
    { "-9, 17", -69502, 142754, 50, 2.89, "Khuul" },
    { "-3, 12", -22622, 101142, 1725, 0.28, "Maar Gan" },
    { "12, -8", 103871, -58060, 1423, 2.2, "Molag Mar" },
    { "0, -7", 2341, -56259, 1477, 2.13, "Pelagiad" },
    { "17, 4", 141415, 39670, 213, 2.47, "Sadrith Mora" },
    { "6, -6", 52855, -48216, 897, 2.36, "Suran" },
    { "14, 4", 122576, 40955, 59, 1.16, "Tel Aruhn" },
    { "14, -13", 119124, -101518, 51, 3.08, "Tel Branora" },
    { "13, 14", 106608, 115787, 53, -0.39, "Tel Mora" },
    { "3, -10", 36412, -74454, 59, -1.66, "Vivec" },
    { "11, 14", 101402, 114893, 158, -2.03, "Vos" }
}

-- TODO: Pick some points...
local ProvinceCyrodiilSpawns = {}
local SkyrimHomeOfTheNordsSpawns = {}
local TamrieRebuiltSpawns = {}

local spawns = {}

RandomSpawn.defaultConfig = {
    useProvinceCyrodiilSpawns = false,
    useTamrielRebuiltSpawns = false,
    useSkyrimHomeOfTheNordsSpawns = false,
    useVanillaSpawns = true,
    provinceCyrodiilSpawns = ProvinceCyrodiilSpawns,
    skyrimHomeOfTheNordsSpawns = SkyrimHomeOfTheNordsSpawns,
    tamrieRebuiltSpawns = TamrieRebuiltSpawns,
    vanillaSpawns = VanillaSpawns,
    customSpawns = {},
}

RandomSpawn.config = DataManager.loadConfiguration(scriptName, RandomSpawn.defaultConfig)

local function info(msg)
   tes3mp.LogMessage(enumerations.log.INFO, "[ " .. scriptName .." ]: " .. msg)
end

local function warn(msg)
   tes3mp.LogMessage(enumerations.log.WARN, "[ " .. scriptName .." ]: " .. msg)
end

-- Build the spawns table...
if RandomSpawn.config.useProvinceCyrodiilSpawns then
    for k, v in pairs(RandomSpawn.config.provinceCyrodiilSpawns) do spawns[k] = v end
end

if RandomSpawn.config.useTamrielRebuiltSpawns then
    for k, v in pairs(RandomSpawn.config.tamrieRebuiltSpawns) do spawns[k] = v end
end

if RandomSpawn.config.useSkyrimHomeOfTheNordsSpawns then
    for k, v in pairs(RandomSpawn.config.skyrimHomeOfTheNordsSpawns) do spawns[k] = v end
end

if RandomSpawn.config.customSpawns ~= {} then
    for k, v in pairs(RandomSpawn.config.customSpawns) do spawns[k] = v end
end

if RandomSpawn.config.useVanillaSpawns then
    for k, v in pairs(RandomSpawn.config.vanillaSpawns) do spawns[k] = v end
end

-- Use the default vanilla spawns if nothing else has been selected...
if next(spawns) == nil then
    warn("No configured spawn points were found!")
    warn("Falling back to the default vanilla points...")
    for k, v in pairs(VanillaSpawns) do spawns[k] = v end
end

-- THANKS: https://github.com/Texafornian/ccSuite/blob/699b87fe98698ea240a9a77c42d400ec88c30841/scripts/custom/ccsuite/ccCharGen.lua#L176-L191
RandomSpawn.DoSpawn = function(eventStatus, pid)
    math.randomseed(os.time())
    local t = math.random(1, #spawns)
    local cellID = spawns[t][1]
    local x = spawns[t][2]
    local y = spawns[t][3]
    local z = spawns[t][4]
    local rot = spawns[t][5]

    info("Spawning new player \"" .. Players[pid].name .. "\" in cell: " .. cellID)

    tes3mp.SetCell(pid, cellID)
    tes3mp.SendCell(pid)

    tes3mp.SetPos(pid, x, y, z)
    tes3mp.SetRot(pid, 0, rot)
    tes3mp.SendPos(pid)
end

customEventHooks.registerHandler("OnPlayerEndCharGen", RandomSpawn.DoSpawn)
