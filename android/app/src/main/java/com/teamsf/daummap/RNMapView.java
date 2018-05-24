package com.teamsf.daummap;

import android.view.View;
import android.util.Log;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import net.daum.mf.map.api.MapLayout;
import net.daum.mf.map.api.MapPoint;
import net.daum.mf.map.api.MapView;

public class RNMapView extends MapView {
	private ThemedReactContext mContext;
	private MapView mMapView;
	private static final String LOG_TAG = "DaumMap";

	public RNMapView(ThemedReactContext themedReactContext) {
		super(themedReactContext.getCurrentActivity(), null);
		mContext = themedReactContext;
		mMapView = this;
		this.setDaumMapApiKey("daea374daf719513adc4afa2e4423a9a");

		this.setOpenAPIKeyAuthenticationResultListener(new OpenAPIKeyAuthenticationResultListener() {
			public void onDaumMapOpenAPIKeyAuthenticationResult(MapView mapView, int resultCode, String resultMessage) {
				Log.i(LOG_TAG, String.format("Open API Key Authentication Result : code=%d, message=%s", resultCode, resultMessage));
			}
		});
		this.setMapViewEventListener(new MapViewEventListener() {
			public void onMapViewInitialized(MapView mapView) {
				Log.i(LOG_TAG, "MapView had loaded. Now, MapView APIs could be called safely");
				//mMapView.setCurrentLocationTrackingMode(MapView.CurrentLocationTrackingMode.TrackingModeOnWithoutHeading);
				mMapView.setMapCenterPointAndZoomLevel(MapPoint.mapPointWithGeoCoord(37.537229, 127.005515), 2, true);
				// Log.i(LOG_TAG, "%s", mMapView.getMapType().toString());
				mMapView.setMapType(MapView.MapType.Satellite);
			}

			public void onMapViewCenterPointMoved(MapView mapView, MapPoint mapCenterPoint) {

			}

			public void onMapViewZoomLevelChanged(MapView mapView, int zoomLevel) {

			}

			public void onMapViewSingleTapped(MapView mapView, MapPoint mapPoint) {

			}

			public void onMapViewDoubleTapped(MapView mapView, MapPoint mapPoint) {

			}

			public void onMapViewLongPressed(MapView mapView, MapPoint mapPoint) {

			}

			public void onMapViewDragStarted(MapView mapView, MapPoint mapPoint) {

			}

			public void onMapViewDragEnded(MapView mapView, MapPoint mapPoint) {

			}

			public void onMapViewMoveFinished(MapView mapView, MapPoint mapPoint) {

			}
		});
	}
}