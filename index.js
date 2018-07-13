import PropTypes from 'prop-types';
import React, { Component } from 'react';
import {
	requireNativeComponent,
	Platform,
	PermissionsAndroid,
	View,
} from 'react-native';

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
			permissionGranted: false,

		};
	}

	async componentDidMount () {
		if (Platform.OS === "android") {
			try {
				const granted = await PermissionsAndroid.request(
					PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
					{
						'title'		: this.props.PermissionsAndroidTitle,
						'message'	: this.props.PermissionsAndroidMessage
					}
				)
				if (granted === PermissionsAndroid.RESULTS.GRANTED) {
					this.setState({ permissionGranted: true, });
				} else {
					this.setState({ permissionGranted: false, });
				}
			} catch (err) {
				console.warn(err)
			}
		} else {
			this.setState({ permissionGranted: true, });
		}
	}

	render () {
		if (this.state.permissionGranted) {
			return (
				<DaumMap
					{...this.props} 
					style={[{ width: "100%", height: "100%", }, this.props.style]}
					ref={ref => { this.map = ref; }}
					onMarkerSelect={this._onMarkerSelect}
					onMarkerPress={this._onMarkerPress}
					onMarkerMoved={this._onMarkerMoved}
					onRegionChange={this._onRegionChange}
					onUpdateCurrentLocation={this._onUpdateCurrentLocation}/>
			);
		} else {
			return (
				<View style={{ flex: 1, }}>
					{this.props.permissionDeniedView}
				</View>
			);
		}
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

	_onMarkerMoved = (event) => {
		if (this.props.onMarkerMoved != undefined) {
			this.props.onMarkerMoved(event.nativeEvent);
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
	style					: {},
	isTracking 				: false,
	isCompass				: false,
	isCurrentMarker 		: true,
	permissionDeniedView 	: null,
	PermissionsAndroidTitle : "권한 요청",
	PermissionsAndroidMessage: "지도 표시를 위해 권한을 허용 해 주세요.",
}