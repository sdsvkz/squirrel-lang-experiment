return {
	basePath = "",
}.setdelegate({
	function _call(_, path) {
		try {
			return loadfile(path, true)();
		} catch (e) {
			print("Error on requiring: " + path)
			print("\n  " + e + "\n")
			throw "Require failed: Error occurred above"
		}
	}
})
