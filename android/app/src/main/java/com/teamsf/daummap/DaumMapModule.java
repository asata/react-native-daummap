package com.teamsf.daummap;

import android.support.annotation.Nullable;
import android.util.Log;
import android.app.Activity;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.NativeViewHierarchyManager;
import com.facebook.react.uimanager.UIBlock;
import com.facebook.react.uimanager.UIManagerModule;

import java.util.HashMap;
import java.util.Map;

public class DaumMapModule extends ReactContextBaseJavaModule {
	public static final String REACT_CLASS = "DaumMapModule";
	private static ReactApplicationContext reactContext = null;

	public DaumMapModule(ReactApplicationContext context) {
		super(context);

		this.reactContext = context;
	}

	@Override
	public String getName() {
		return REACT_CLASS;
	}

	@Override
	public Map<String, Object> getConstants() {
		final Map<String, Object> constants = new HashMap<>();
		// constants.put("EXAMPLE_CONSTANT", "example");

		return constants;
	}

	@ReactMethod
	public void clearMapCache (final int tag) {
		UIManagerModule uiManager = reactContext.getNativeModule(UIManagerModule.class);
		uiManager.addUIBlock(new UIBlock() {
			public void execute(NativeViewHierarchyManager nvhm) {
				RNMapView mapView = (RNMapView) nvhm.resolveView(tag);

				mapView.clearMapTilePersistentCache();
			}
		});
	}

	private static void emitDeviceEvent(String eventName, @Nullable WritableMap eventData) {
		reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, eventData);
	}
}
