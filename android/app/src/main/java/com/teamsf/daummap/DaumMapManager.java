package com.teamsf.daummap;

import android.view.View;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import net.daum.mf.map.api.MapLayout;
import net.daum.mf.map.api.MapPoint;
import net.daum.mf.map.api.MapView;
import android.util.Log;

public class DaumMapManager extends SimpleViewManager<View> {
	public static final String REACT_CLASS = "DaumMap";

	@Override
	public String getName() {
		// Tell React the name of the module
		// https://facebook.github.io/react-native/docs/native-components-android.html#1-create-the-viewmanager-subclass
		return REACT_CLASS;
	}

	@Override
	public RNMapView createViewInstance(ThemedReactContext context) {
		return new RNMapView(context);
	}

	@ReactProp(name = "mapType")
	public void setMapType(MapView mMapView, String mapType) {
		if (mapType == "Standard") {
			mMapView.setMapType(MapView.MapType.Standard);
		} else if (mapType  == "Satellite") {
			mMapView.setMapType(MapView.MapType.Satellite);
		} else if (mapType == "Hybrid") {
			mMapView.setMapType(MapView.MapType.Hybrid);
		} else {
			mMapView.setMapType(MapView.MapType.Standard);
		}
	}

	@ReactProp(name = "initialRegion")
	public void setInitialRegion(MapView mMapView, ReadableMap initialRegion) {
		double xVal = initialRegion.hasKey("x") ? initialRegion.getDouble("x") : 0;
		double yVal = initialRegion.hasKey("y") ? initialRegion.getDouble("y") : 0;
		Log.d("DaumMap", String.format("Value of a: %.2f, %.2f", xVal, yVal));
	}
}
