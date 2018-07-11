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
			isTracking={this.props.isTracking}
			isCompass={this.props.isCompass}
			isCurrentMarker={this.props.isCurrentMarker}
			onMarkerSelect={this._onMarkerSelect}
			onMarkerPress={this._onMarkerPress}
			onRegionChange={this._onRegionChange}
			onUpdateCurrentLocation={this._onUpdateCurrentLocation}
			{...this.props} />
	}

	_onMarkerSelect = (event) => {
		if (this.props.onMarkerSelect != undefined) {
			this.props.onMarkerSelect(event.nativeEvent);
		}
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

	_onUpdateCurrentLocation = (event) => {
		if (this.props.onUpdateCurrentLocation != undefined) {
			this.props.onUpdateCurrentLocation(event.nativeEvent);
		}

		console.log("onUpdateCurrentLocation", event.nativeEvent);
	}
}

DaumMapView.propTypes = {
	isTracking 				: PropTypes.bool,
	isCompass 				: PropTypes.bool,
	isCurrentMarker 		: PropTypes.bool,

	onMarkerSelect 			: PropTypes.func,
	onMarkerPress 			: PropTypes.func,
	onRegionChange 			: PropTypes.func,
	onUpdateCurrentLocation	: PropTypes.func,
}

DaumMapView.defaultProps = {
	isTracking 		: false,
	isCompass		: false,
	isCurrentMarker : false,
}