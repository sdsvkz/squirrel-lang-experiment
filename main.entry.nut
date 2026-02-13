require <- loadfile("vkzlib/require.nut", true)()

local Plant = require("plant/Plant.class.nut")
local inspect = require("vkzlib/inspect.nut")

local function main() {
    local plant = Plant({
        type = Plant.Type.PlantA,
        growthTimeSeq = [60, 60, 90],
    })
}

main()
