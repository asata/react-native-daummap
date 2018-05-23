//  Created by react-native-create-bridge

import React, { Component } from 'react'
import { requireNativeComponent } from 'react-native'

const KakaoMap = requireNativeComponent('KakaoMap', KakaoMapView)

export default class KakaoMapView extends Component {
	constructor(props) {
		super(props);

		this.state = {
			// isReady: Platform.OS === 'ios',
		};
		
		// this._onMapReady = this._onMapReady.bind(this);
	}

	render () {
		return <KakaoMap
			ref={ref => { this.map = ref; }}
			{...this.props} />
	}
	
	// _onMapReady() {
	// 	const { region, initialRegion, onMapReady } = this.props;

	// 	if (initialRegion) {
	// 		this.map.setNativeProps({ initialRegion });
	// 	}
	// }
}

KakaoMapView.propTypes = {
	// exampleProp: React.PropTypes.any
}
