require <- loadfile("vkzlib/require.nut", true)()

local Plant = require("plant/Plant.class.nut")
local inspect = require("vkzlib/inspect.nut")

local vkzlib_assert = require("vkzlib/test/assert.module.nut")
local assertEqual = vkzlib_assert.assertEqual

local vtest = require("vkzlib/test/unit.module.nut")
local describe = vtest.describe
local it = vtest.it

/**
 * @typedef {table} ExpectState
 * @property {integer} stage
 * @property {integer} growth
 * @property {bool} hasReachedFinalStage
 * @property {integer | null} nextStageRequirement
 */

/**
 * @param {Plant} plant
 * @param {integer} sec
 * @param {ExpectState} expect
 */
local function testGrowPlant(plant, sec, expect) {
	local getBeforeGrowPlantStr = @(what) @() what + "\nBefore grow " + sec + " sec: " + inspect(plant.asTable()) + "\n"
	plant.grow(sec)
	assertEqual(plant.getStage(), expect.stage, getBeforeGrowPlantStr("On getStage"))
	assertEqual(plant.getGrowth(), expect.growth, getBeforeGrowPlantStr("On getGrowth"))
	assertEqual(plant.getGrowthTimeOf(), expect.nextStageRequirement, getBeforeGrowPlantStr("On nextStageRequirement"))
	assertEqual(plant.hasReachedFinalStage(), expect.hasReachedFinalStage, getBeforeGrowPlantStr("On hasReachedFinalStage"))
}

describe("test Plant.class.nut", function () {
	local tests = []
	tests.push(it("should grow plant correctly", function () {
		local plantA = Plant({
			type = Plant.Type.PlantA,
			growthTimeSeq = [10, 20, 30],
		})

		testGrowPlant(plantA, 5, {
			stage = 1,
			growth = 5,
			nextStageRequirement = 10,
			hasReachedFinalStage = false,
		})
		testGrowPlant(plantA, 6, {
			stage = 2,
			growth = 1,
			nextStageRequirement = 20,
			hasReachedFinalStage = false,
		})
		testGrowPlant(plantA, 15, {
			stage = 2,
			growth = 16,
			nextStageRequirement = 20,
			hasReachedFinalStage = false,
		})
		testGrowPlant(plantA, 50, {
			stage = 4,
			growth = 16,
			nextStageRequirement = null,
			hasReachedFinalStage = true,
		})
		testGrowPlant(plantA, 5, {
			stage = 4,
			growth = 21,
			nextStageRequirement = null,
			hasReachedFinalStage = false,
		})
		print("something")
	}))
	return tests
})
