import { NativeModules } from 'react-native'

const { DaumMap } = NativeModules

export default {
	exampleMethod () {
		return DaumMap.exampleMethod()
	},

	EXAMPLE_CONSTANT: DaumMap.EXAMPLE_CONSTANT
}
