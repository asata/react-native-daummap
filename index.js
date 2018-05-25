import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { requireNativeComponent } from 'react-native';

const DaumMap = requireNativeComponent('DaumMap', DaumMapView, {
	nativeOnly: {
		onMarkerSelectEvent: true,
		onMarkerPressEvent: true
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
			onMarkerSelectEvent={this._onMarkerSelectEvent}
			onMarkerPressEvent={this._onMarkerPressEvent}
			{...this.props} />
	}

	_onMarkerSelectEvent = (event) => {
		if (this.props.onMarkerSelect != undefined) {
			this.props.onMarkerSelect(event.nativeEvent);
		}
	}

	_onMarkerPressEvent = (event) => {
		if (this.props.onMarkerPress != undefined) {
			this.props.onMarkerPress(event.nativeEvent);
		}
	}
}

DaumMapView.propTypes = {
	onMarkerSelect: PropTypes.func,
	onMarkerPress: PropTypes.func,
}
