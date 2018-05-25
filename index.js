import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { requireNativeComponent } from 'react-native';

const DaumMap = requireNativeComponent('DaumMap', DaumMapView, {
	nativeOnly: {
		onMarkerSelect: true,
		onMarkerPress: true,
		onRegionChange: true
	}
})

export default class DaumMapView extends Component {
	constructor(props) {
		super(props);

		this.state = {

		};
	}

	render () {
		return <DaumMap
			ref={ref => { this.map = ref; }}
			onMarkerSelect={this._onMarkerSelect}
			onMarkerPress={this._onMarkerPress}
			onRegionChange={this._onRegionChange}
			{...this.props} />
	}

	_onMarkerSelect = (event) => {
		if (this.props.onMarkerSelect != undefined) {
			this.props.onMarkerSelect(event.nativeEvent);
		}
		console.log("_onMarkerSelectEvent", event)
	}

	_onMarkerPress = (event) => {
		if (this.props.onMarkerPress != undefined) {
			this.props.onMarkerPress(event.nativeEvent);
		}
	}

	_onRegionChange = (event) => {
		if (this.props.onRegionChange != undefined) {
			this.props.onRegionChange(event.nativeEvent);
		}
	}
}

DaumMapView.propTypes = {
	onMarkerSelect: PropTypes.func,
	onMarkerPress: PropTypes.func,
	onRegionChange: PropTypes.func
}
