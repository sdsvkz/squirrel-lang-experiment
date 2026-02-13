require <- loadfile("vkzlib/require.nut", true)()

local Plant = require("plant/Plant.class.nut")
local inspect = require("vkzlib/inspect.nut")

local function plantGrowUsage() {
    local plant = Plant({
        type = Plant.Type.PlantA,
        growthTimeSeq = [60, 60, 90],
    })
    print("Initial plant: " + plant + "\n\n")
    plant.grow(15)
    print("After plant.grow(15): " + plant + "\n\n")
    plant.grow(50)
    print("After plant.grow(50): " + plant + "\n\n")
    plant.grow(180)
    print("After plant.grow(180): " + plant + "\n\n")
    plant.grow(500)
    print("After plant.grow(500): " + plant + "\n\n")
}

local function main() {
    plantGrowUsage()
}

main()
