package com.teamsf.daummap;

import android.view.View;
import android.util.Log;

import com.facebook.react.common.MapBuilder;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import net.daum.mf.map.api.MapLayout;
import net.daum.mf.map.api.MapPoint;
import net.daum.mf.map.api.MapView;
import net.daum.mf.map.api.MapPOIItem;

import javax.annotation.Nullable;
import java.util.Map;

public class DaumMapManager extends SimpleViewManager<View> implements MapView.MapViewEventListener, MapView.POIItemEventListener {
	public static final String REACT_CLASS = "DaumMap";
	public static final String TAG = "DaumMap";
	private final ReactApplicationContext appContext;
	private RNMapView rnMapView;

	public DaumMapManager (ReactApplicationContext context) {
		super();

		this.appContext = context;
	}

	@Override
	public String getName() {
		// Tell React the name of the module
		// https://facebook.github.io/react-native/docs/native-components-android.html#1-create-the-viewmanager-subclass
		return REACT_CLASS;
	}

	@Override
	public RNMapView createViewInstance(ThemedReactContext context) {
		RNMapView rMapView = new RNMapView(context, this.appContext);
		rnMapView = rMapView;

		rMapView.setOpenAPIKeyAuthenticationResultListener(new MapView.OpenAPIKeyAuthenticationResultListener() {
			public void onDaumMapOpenAPIKeyAuthenticationResult(MapView mapView, int resultCode, String resultMessage) {
				Log.i(TAG, String.format("Open API Key Authentication Result : code=%d, message=%s", resultCode, resultMessage));
			}
		});

		rMapView.setMapViewEventListener(this);
		rMapView.setPOIItemEventListener(this);

		return rMapView;
	}

	@ReactProp(name = "initialRegion")
	public void setInitialRegion(MapView mMapView, ReadableMap initialRegion) {
		double latitude 	= initialRegion.hasKey("latitude") ? initialRegion.getDouble("latitude") : 36.143099;
		double longitude 	= initialRegion.hasKey("longitude") ? initialRegion.getDouble("longitude") : 128.392905;
		int zoomLevel 		= initialRegion.hasKey("zoomLevel") ? initialRegion.getInt("zoomLevel") : 2;

		mMapView.setMapCenterPointAndZoomLevel(MapPoint.mapPointWithGeoCoord(latitude, longitude), zoomLevel, true);
	}

	@ReactProp(name = "mapType")
	public void setMapType(MapView mMapView, String mapType) {
		if (mapType.equals("Standard")) {
			mMapView.setMapType(MapView.MapType.Standard);
		} else if (mapType.equals("Satellite")) {
			mMapView.setMapType(MapView.MapType.Satellite);
		} else if (mapType.equals("Hybrid")) {
			mMapView.setMapType(MapView.MapType.Hybrid);
		} else {
			mMapView.setMapType(MapView.MapType.Standard);
		}
	}

	@ReactProp(name = "markers")
	public void setMarkers(MapView mMapView, ReadableArray markers) {
		for (int i = 0; i < markers.size(); i++) {
			ReadableMap markerInfo = markers.getMap(i);
			double latitude 	= markerInfo.hasKey("latitude") ? markerInfo.getDouble("latitude") : 36.143099;
			double longitude 	= markerInfo.hasKey("longitude") ? markerInfo.getDouble("longitude") : 128.392905;

			MapPOIItem.MarkerType markerType = MapPOIItem.MarkerType.BluePin;
			if (markerInfo.hasKey("pinColor")) {
				String pinColor = markerInfo.getString("pinColor");
				if (pinColor.equals("red")) {
					markerType = MapPOIItem.MarkerType.RedPin;
				} else if (pinColor.equals("yellow")) {
					markerType = MapPOIItem.MarkerType.YellowPin;
				} else if (pinColor.equals("blue")) {
					markerType = MapPOIItem.MarkerType.BluePin;
				}
			}

			MapPOIItem.MarkerType sMarkerType = MapPOIItem.MarkerType.RedPin;
			if (markerInfo.hasKey("selectPinColor")) {
				String pinColor = markerInfo.getString("selectPinColor");
				if (pinColor.equals("red")) {
					sMarkerType = MapPOIItem.MarkerType.RedPin;
				} else if (pinColor.equals("yellow")) {
					sMarkerType = MapPOIItem.MarkerType.YellowPin;
				} else if (pinColor.equals("blue")) {
					sMarkerType = MapPOIItem.MarkerType.BluePin;
				} else if (pinColor.equals("none")) {
					sMarkerType = null;
				}
			}

			MapPOIItem marker = new MapPOIItem();
			if (markerInfo.hasKey("name")) {
				marker.setItemName(markerInfo.getString("name"));
			}

			marker.setTag(i);
			marker.setMapPoint(MapPoint.mapPointWithGeoCoord(latitude, longitude));
			marker.setMarkerType(markerType); 							// 기본으로 제공하는 BluePin 마커 모양.
			marker.setSelectedMarkerType(sMarkerType); 					// 마커를 클릭했을때, 기본으로 제공하는 RedPin 마커 모양.
			marker.setShowDisclosureButtonOnCalloutBalloon(false);		// 마커 클릭시, 말풍선 오른쪽에 나타나는 > 표시 여부
			marker.setDraggable(false);

			mMapView.addPOIItem(marker);
		}
	}

	@Override
	@Nullable
	public Map getExportedCustomDirectEventTypeConstants() {
	Map<String, Map<String, String>> map = MapBuilder.of(
		"onMarkerSelectEvent", MapBuilder.of("registrationName", "onMarkerSelectEvent"),
		"onMarkerPressEvent", MapBuilder.of("registrationName", "onMarkerPressEvent")
	);

	// map.putAll(MapBuilder.of(
	// 	"onDragStart", MapBuilder.of("registrationName", "onDragStart"),
	// 	"onDrag", MapBuilder.of("registrationName", "onDrag"),
	// 	"onDragEnd", MapBuilder.of("registrationName", "onDragEnd")
	// ));

	return map;
	}

	/************************************************************************/
	// MapViewEvent
	/************************************************************************/
	// MapView가 사용 가능한 상태가 되었을 때 호출
	@Override
	public void onMapViewInitialized(MapView mapView) {

	}

	// 지도 중심 좌표가 이동했을 때
	@Override
	public void onMapViewCenterPointMoved(MapView mapView, MapPoint mapCenterPoint) {

	}

	// 지도 확대/축소 레벨이 변경된 경우
	@Override
	public void onMapViewZoomLevelChanged(MapView mapView, int zoomLevel) {

	}

	// 지도 위를 터치한 경우
	@Override
	public void onMapViewSingleTapped(MapView mapView, MapPoint mapPoint) {

	}

	// 지도 위 한 지점을 더블 터치한 경우
	@Override
	public void onMapViewDoubleTapped(MapView mapView, MapPoint mapPoint) {

	}

	// 지도 위 한 지점을 길게 누른 경우
	@Override
	public void onMapViewLongPressed(MapView mapView, MapPoint mapPoint) {

	}

	// 지도 드래그를 시작한 경우
	@Override
	public void onMapViewDragStarted(MapView mapView, MapPoint mapPoint) {

	}

	// 지도 이동이 완료된 경우
	@Override
	public void onMapViewDragEnded(MapView mapView, MapPoint mapPoint) {

	}

	@Override
	public void onMapViewMoveFinished(MapView mapView, MapPoint mapPoint) {

	}


	/************************************************************************/
	// POIItemEvent
	/************************************************************************/
	// Marker를 선택한 경우
	@Override
	public void onPOIItemSelected(MapView mapView, MapPOIItem poiItem) {
		WritableMap event = new WritableNativeMap();

		WritableMap coordinate = new WritableNativeMap();
		coordinate.putDouble("latitude", poiItem.getMapPoint().getMapPointGeoCoord().latitude);
		coordinate.putDouble("longitude", poiItem.getMapPoint().getMapPointGeoCoord().longitude);
		event.putMap("coordinate", coordinate);
		event.putString("action", "markerSelect");
		event.putInt("id", poiItem.getTag());

		appContext.getJSModule(RCTEventEmitter.class).receiveEvent(rnMapView.getId(), "onMarkerSelectEvent", event);
	}

	// Marker 말풍선을 선택한 경우
	@Override
	public void onCalloutBalloonOfPOIItemTouched(MapView mapView, MapPOIItem poiItem) {
		WritableMap event = new WritableNativeMap();

		WritableMap coordinate = new WritableNativeMap();
		coordinate.putDouble("latitude", poiItem.getMapPoint().getMapPointGeoCoord().latitude);
		coordinate.putDouble("longitude", poiItem.getMapPoint().getMapPointGeoCoord().longitude);
		event.putMap("coordinate", coordinate);
		event.putString("action", "markerPress");
		event.putInt("id", poiItem.getTag());

		appContext.getJSModule(RCTEventEmitter.class).receiveEvent(rnMapView.getId(), "onMarkerPressEvent", event);

	}
	@Override
	public void onCalloutBalloonOfPOIItemTouched(MapView mapView, MapPOIItem poiItem, MapPOIItem.CalloutBalloonButtonType buttonType) {
		WritableMap event = new WritableNativeMap();

		WritableMap coordinate = new WritableNativeMap();
		coordinate.putDouble("latitude", poiItem.getMapPoint().getMapPointGeoCoord().latitude);
		coordinate.putDouble("longitude", poiItem.getMapPoint().getMapPointGeoCoord().longitude);
		event.putMap("coordinate", coordinate);
		event.putString("action", "markerPress");
		event.putInt("id", poiItem.getTag());

		appContext.getJSModule(RCTEventEmitter.class).receiveEvent(rnMapView.getId(), "onMarkerPressEvent", event);
	}

	// Marker 위치를 이동한 경우
	@Override
	public void onDraggablePOIItemMoved(MapView mapView, MapPOIItem poiItem, MapPoint newMapPoint) {

	}
}
