package com.teamsf.daummap;

import android.os.Bundle;
import android.view.View;
import android.util.Log;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.bridge.ReactApplicationContext;
import net.daum.mf.map.api.MapView;

public class RNMapView extends MapView {
	private ThemedReactContext mContext;
	private MapView mMapView;
	private static final String TAG = "DaumMap";

	public RNMapView(ThemedReactContext themedReactContext, ReactApplicationContext appContext) {
		super(themedReactContext.getCurrentActivity(), null);
		mContext = themedReactContext;

		this.setMapTilePersistentCacheEnabled(true);
		String apiKey = null;
		try {
			ApplicationInfo ai = appContext.getPackageManager().getApplicationInfo(appContext.getApplicationContext().getPackageName(), PackageManager.GET_META_DATA);
			Bundle bundle = ai.metaData;
			if (bundle != null) {
				apiKey = bundle.getString("com.kakao.sdk.AppKey");
				this.setDaumMapApiKey(apiKey);
			}
		} catch (NameNotFoundException e) {
			Log.e(TAG, e.getMessage());
		}
	}
}
