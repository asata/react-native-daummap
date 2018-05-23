import React, { Component } from 'react'
import { requireNativeComponent } from 'react-native'

const DaumMap = requireNativeComponent('DaumMap', DaumMapView)

export default class DaumMapView extends Component {
	constructor(props) {
		super(props);

		this.state = {

		};
	}

	render () {
		return <DaumMap
			ref={ref => { this.map = ref; }}
			{...this.props} />
	}
}

DaumMapView.propTypes = {

}
