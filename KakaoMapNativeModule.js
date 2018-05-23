import { NativeModules } from 'react-native'

const { KakaoMap } = NativeModules

export default {
	exampleMethod () {
		return KakaoMap.exampleMethod()
	},

	EXAMPLE_CONSTANT: KakaoMap.EXAMPLE_CONSTANT
}
