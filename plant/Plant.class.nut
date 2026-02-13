local inspect = require("vkzlib/inspect.nut")

/**
 * @readonly
 * @enum {string}
 */
local PlantType = {
	PlantA = "PlantA",
	PlantB = "PlantB",
	PlantC = "PlantC"
}

/**
 * @typedef {PlantType[keyof PlantType]} PlantType
 */

const PLANT_MIN_STAGE = 1
const PLANT_MIN_GROWTH = 0

class Plant {
	Type = PlantType

	/**
	 * @property {PlantType} _type Type of the plant. Actually, it is a string
	 * @property {integer[]} _growthTimeSeq Max growth time of each stage, can be empty
	 * @property {integer} _stage Current stage of the plant
	 * @property {integer} _growth How much time it has grown in current stage
	 *
	 * @param {{ type: PlantType, growthTimeSeq: integer[], stage?: integer, growth?: integer  }} params
	 */
	constructor(params) {
		local stage = "stage" in params ? params.stage : PLANT_MIN_STAGE
		if (stage < PLANT_MIN_STAGE) {
			throw "Plant::constructor: `stage` = " + stage + " < " + PLANT_MIN_STAGE
		}

		local growth = "growth" in params ? params.growth : PLANT_MIN_GROWTH
		if (growth < PLANT_MIN_GROWTH) {
			throw "Plant::constructor: `growth` = " + growth + " < " + PLANT_MIN_GROWTH
		}

		this._type = params.type
		this._growthTimeSeq = params.growthTimeSeq
		this._stage = stage
		this._growth = growth
	}

	// Business logics

	/**
	 * @desc Increase grown time, advance to next stage if reached growth time
	 *
	 * @param {integer}	sec How much time to grow, in second
	 */
	function grow(sec) {
		if (sec < 0) {
			throw "Plant::grow: `sec` = " + sec + " < 0"
		}

		this._growth += sec
		while (this.canAdvanceToNextStage()) {
			// 把多加的减回去
			this._growth -= this._growthTimeSeq[this._stage - 1]
			this._stage += 1
		}
	}

	/**
	 * @desc Decrease grown time but never decrease stage
	 *
	 * @param {integer} sec How much time to decrease, in second
	 */
	function ungrow(sec) {
		this._growth -= sec
		if (this._growth < PLANT_MIN_GROWTH) {
			this._growth = PLANT_MIN_GROWTH
		}
	}

	// Getters

	function getType() {
		return this._type
	}

	/**
	 * @desc Return a reference to growthTimeSeq. MUTATION IS NOT ALLOWED
	 *
	 * @return {integer[]} growthTimeSeq
	 */
	function getGrowthTimeSeqRef() {
		return this._growthTimeSeq
	}

	function getStage() {
		return this._stage
	}

	function getGrowth() {
		return this._growth
	}

	function getFinalStage() {
		return this._growthTimeSeq.len() + 1
	}

	function hasReachedFinalStage() {
		return this._stage >= this.getFinalStage()
	}

	/**
	 * @desc Get growth time of stage
	 *
	 * @param {integer | null} stage use current stage if `null` or omitted
	 * @return {integer | null} growthTime `null` if no growth time defined for this stage
	 */
	function getGrowthTimeOf(stage = null) {
		stage = stage != null ? stage : this._stage
		try {
			return this._growthTimeSeq[stage - 1]
		} catch (_) {
			return null
		}
	}

	function canAdvanceToNextStage() {
		return !this.hasReachedFinalStage() && this._growth >= this.getGrowthTimeOf()
	}

	// Utilities

	/**
	 * @desc Return the `Plant` instance as a table. DO NOT MUTATE growthTimeSeq
	 */
	function asTable() {
		return {
			type = this._type,
			growthTimeSeq = this._growthTimeSeq,
			stage = this._stage,
			growth = this._growth,
		}
	}

	/**
	 * @desc Convert the `Plant` instance to a table, with fields cloned
	 */
	function toTable() {
		local res = this.asTable()
		res.growthTimeSeq = clone this._growthTimeSeq
		return res
	}

	// Metamethods

	function _tostring() {
		return inspect(this.asTable())
	}

	// Properties

	// 因为这语言没有访问限制，所以我定了一个规则
	// 名字带下划线的只允许类内部或者继承类内部用 (protected)

	_type = null
	_growthTimeSeq = null
	_stage = null
	_growth = null
}

return Plant