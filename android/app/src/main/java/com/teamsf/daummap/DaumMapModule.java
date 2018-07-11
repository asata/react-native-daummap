package com.teamsf.daummap;

import android.support.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.HashMap;
import java.util.Map;

public class DaumMapModule extends ReactContextBaseJavaModule {
	public static final String REACT_CLASS = "DaumMap";
	private static ReactApplicationContext reactContext = null;

	public DaumMapModule(ReactApplicationContext context) {
		super(context);

		reactContext = context;
	}

	@Override
	public String getName() {
		return REACT_CLASS;
	}

	@Override
	public Map<String, Object> getConstants() {
		final Map<String, Object> constants = new HashMap<>();
		constants.put("EXAMPLE_CONSTANT", "example");

		return constants;
	}

	@ReactMethod
	public void exampleMethod () {

	}

	private static void emitDeviceEvent(String eventName, @Nullable WritableMap eventData) {
		reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, eventData);
	}
}
