#import <Foundation/Foundation.h>
#import "DaumMap.h"
#import <DaumMap/MTMapView.h>

// import RCTEventDispatcher
#if __has_include(<React/RCTEventDispatcher.h>)
#import <React/RCTEventDispatcher.h>
#elif __has_include("RCTEventDispatcher.h")
#import "RCTEventDispatcher.h"
#else
#import "React/RCTEventDispatcher.h" // Required when used as a Pod in a Swift project
#endif

@implementation DaumMap : UIView {
    RCTEventDispatcher *_eventDispatcher;
    MTMapView *_mapView;
}

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher {
    if ((self = [super init])) {
        _eventDispatcher = eventDispatcher;
        
        _mapView = [[MTMapView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,
                                                               self.bounds.origin.y,
                                                               self.bounds.size.width,
                                                               self.bounds.size.height)];
        _mapView.delegate = self;
        _mapView.baseMapType = MTMapTypeHybrid;
        
        _latdouble = 36.143099;
        _londouble = 128.392905;
        _zoomLevel = 2;
        
        _isTracking = false;
        _isCompass = false;
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    _mapView.frame = self.bounds;
    [self addSubview:_mapView];
}

- (void) setInitialRegion:(NSDictionary *)region {
    if ([region valueForKey:@"latitude"] != [NSNull null]) {
        _latdouble = [[region valueForKey:@"latitude"] floatValue];
    }
    if ([region valueForKey:@"longitude"] != [NSNull null]) {
        _londouble = [[region valueForKey:@"longitude"] floatValue];
    }
    if ([region valueForKey:@"zoomLevel"] != [NSNull null]) {
        _zoomLevel = [[region valueForKey:@"zoomLevel"] intValue];
    }
}

- (void) setMarkers:(NSArray *)markers {
    NSArray *markerList = [NSArray arrayWithObjects: nil];
    
    for (int i = 0; i < [markers count]; i++) {
        NSDictionary *dict = [markers objectAtIndex:i];
        NSString *itemName = [dict valueForKey:@"title"];
        NSString *pinColor = [dict valueForKey:@"pinColor"];
        NSString *selectPinColor = [dict valueForKey:@"selectPinColor"];
        MTMapPOIItemMarkerType markerColor = MTMapPOIItemMarkerTypeBluePin;
        if ([pinColor isEqualToString:@"red"]) {
            markerColor = MTMapPOIItemMarkerTypeRedPin;
        } else if ([pinColor isEqualToString:@"yellow"]) {
            markerColor = MTMapPOIItemMarkerTypeYellowPin;
        } else if ([pinColor isEqualToString:@"blue"]) {
            markerColor = MTMapPOIItemMarkerTypeBluePin;
        }
        
        MTMapPOIItemMarkerSelectedType sMarkerColor = MTMapPOIItemMarkerSelectedTypeRedPin;
        if ([selectPinColor isEqualToString:@"red"]) {
            sMarkerColor = MTMapPOIItemMarkerSelectedTypeRedPin;
        } else if ([selectPinColor isEqualToString:@"yellow"]) {
            sMarkerColor = MTMapPOIItemMarkerSelectedTypeYellowPin;
        } else if ([selectPinColor isEqualToString:@"blue"]) {
            sMarkerColor = MTMapPOIItemMarkerSelectedTypeBluePin;
        } else if ([selectPinColor isEqualToString:@"none"]) {
            sMarkerColor = MTMapPOIItemMarkerSelectedTypeNone;
        }
        
        MTMapPOIItem* markerItem = [MTMapPOIItem poiItem];
        if (itemName != NULL) markerItem.itemName = itemName;
        float latdouble = [[dict valueForKey:@"latitude"] floatValue];
        float londouble = [[dict valueForKey:@"longitude"] floatValue];
        
        markerItem.mapPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(latdouble, londouble)];
        markerItem.markerType = markerColor;
        markerItem.markerSelectedType = sMarkerColor;
        markerItem.showAnimationType = MTMapPOIItemShowAnimationTypeSpringFromGround; // Item이 화면에 추가될때 애니매이션
        markerItem.draggable = NO;
        markerItem.tag = i;
        markerItem.showDisclosureButtonOnCalloutBalloon = NO;
        
        markerList = [markerList arrayByAddingObject: markerItem];
    }
    
    [_mapView addPOIItems:markerList];
    [_mapView fitMapViewAreaToShowAllPOIItems];
}

- (void) setMapType:(NSString *)mapType {
    if ([mapType isEqualToString:@"Standard"]) {
        _mapView.baseMapType = MTMapTypeStandard;
    } else if ([mapType isEqualToString:@"Satellite"]) {
        _mapView.baseMapType = MTMapTypeSatellite;
    } else if ([mapType isEqualToString:@"Hybrid"]) {
        _mapView.baseMapType = MTMapTypeHybrid;
    } else {
        _mapView.baseMapType = MTMapTypeStandard;
    }
}

- (void) setRegion:(NSDictionary *)region {
    if ([region valueForKey:@"latitude"] != [NSNull null] && [region valueForKey:@"longitude"] != [NSNull null]) {
        float latdouble = [[region valueForKey:@"latitude"] floatValue];
        float londouble = [[region valueForKey:@"longitude"] floatValue];
        
        [_mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(latdouble, londouble)] animated:YES];
    }
}

- (void) setIsCurrentMarker: (BOOL)isCurrentMarker {
    [_mapView setShowCurrentLocationMarker:isCurrentMarker];
}

- (void) setIsTracking:(BOOL)isTracking {
    _isTracking = isTracking;
    [self setMapTracking];
}

- (void) setIsCompass:(BOOL)isCompass {
    _isCompass = isCompass;
    [self setMapTracking];
}

- (MTMapCurrentLocationTrackingMode) getTrackingMode {
    // 트래킹 X, 나침반 X, 지도이동 X : MTMapCurrentLocationTrackingOff
    // 트래킹 O, 나침반 X, 지도이동 O : MTMapCurrentLocationTrackingOnWithoutHeading
    // 트래킹 O, 나침반 O, 지도이동 O : MTMapCurrentLocationTrackingOnWithHeading
    // 트래킹 O, 나침반 X, 지도이동 X : MTMapCurrentLocationTrackingOnWithoutHeadingWithoutMapMoving
    // 트래킹 O, 나침반 O, 지도이동 X : MTMapCurrentLocationTrackingOnWithHeadingWithoutMapMoving
    return [_mapView currentLocationTrackingMode];
}

- (void) setMapTracking {
    MTMapCurrentLocationTrackingMode trackingModeValue = MTMapCurrentLocationTrackingOff;
    if (_isTracking && _isCompass) {
        trackingModeValue = MTMapCurrentLocationTrackingOnWithHeading;
    } else if (_isTracking && !_isCompass) {
        trackingModeValue = MTMapCurrentLocationTrackingOnWithoutHeading;
    } else {
        trackingModeValue = MTMapCurrentLocationTrackingOff;
    }
    
    [_mapView setCurrentLocationTrackingMode:trackingModeValue];
}

/****************************************************************/
// 이벤트 처리 시작
/****************************************************************/
// APP KEY 인증 서버에 인증한 결과를 통보받을 수 있다.
- (void)mapView:(MTMapView*)mapView openAPIKeyAuthenticationResultCode:(int)resultCode resultMessage:(NSString*)resultMessage {
    [_mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(_latdouble, _londouble)] zoomLevel:(int)_zoomLevel animated:YES];
}

// 단말의 현위치 좌표값
- (void)mapView:(MTMapView*)mapView updateCurrentLocation:(MTMapPoint*)location withAccuracy:(MTMapLocationAccuracy)accuracy {
    id event = @{
                 @"action": @"updateCurrentLocation",
                 // @"accuracy": @(accuracy),
                 @"coordinate": @{
                         @"latitude": @([location mapPointGeo].latitude),
                         @"longitude": @([location mapPointGeo].longitude)
                         }
                 };
    
    if (self.onUpdateCurrentLocation) self.onUpdateCurrentLocation(event);
}

// 단말 사용자가 POI Item을 선택한 경우
- (BOOL)mapView:(MTMapView*)mapView selectedPOIItem:(MTMapPOIItem*)poiItem {
    id event = @{
                 @"action": @"markerSelect",
                 @"id": @(poiItem.tag),
                 @"coordinate": @{
                         @"latitude": @(poiItem.mapPoint.mapPointGeo.latitude),
                         @"longitude": @(poiItem.mapPoint.mapPointGeo.longitude)
                         }
                 };
    if (self.onMarkerSelect) self.onMarkerSelect(event);
    
    return YES;
}

// 단말 사용자가 POI Item 아이콘(마커) 위에 나타난 말풍선(Callout Balloon)을 터치한 경우
- (void)mapView:(MTMapView *)mapView touchedCalloutBalloonOfPOIItem:(MTMapPOIItem *)poiItem {
    id event = @{
                 @"action": @"markerPress",
                 @"id": @(poiItem.tag),
                 @"coordinate": @{
                         @"latitude": @(poiItem.mapPoint.mapPointGeo.latitude),
                         @"longitude": @(poiItem.mapPoint.mapPointGeo.longitude)
                         }
                 };
    if (self.onMarkerPress) self.onMarkerPress(event);
}

// 지도 중심 좌표가 이동한 경우
- (void)mapView:(MTMapView*)mapView centerPointMovedTo:(MTMapPoint*)mapCenterPoint {
    id event = @{
                 @"action": @"regionChange",
                 @"coordinate": @{
                         @"latitude": @(mapCenterPoint.mapPointGeo.latitude),
                         @"longitude": @(mapCenterPoint.mapPointGeo.longitude)
                         }
                 };
    if (self.onRegionChange) self.onRegionChange(event);
}
@end
