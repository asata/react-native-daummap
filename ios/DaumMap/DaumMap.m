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

        [MTMapView setMapTilePersistentCacheEnabled:YES];
        _mapView = [[MTMapView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,
                                                               self.bounds.origin.y,
                                                               self.bounds.size.width,
                                                               self.bounds.size.height)];
        _mapView.delegate = self;
        _mapView.baseMapType = MTMapTypeHybrid;

        _latdouble = 36.143099;
        _londouble = 128.392905;
        _zoomLevel = 2;
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
    NSArray   *markerList = [NSArray arrayWithObjects: nil];

    for (int i = 0; i < [markers count]; i++) {
        NSDictionary *dict = [markers objectAtIndex:i];
        NSString *markerTitle = [dict valueForKey:@"title"];
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
        if (markerTitle != NULL) markerItem.itemName = markerTitle;
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

/****************************************************************/
// 이벤트 처리 시작
/****************************************************************/
- (void)mapView:(MTMapView*)mapView openAPIKeyAuthenticationResultCode:(int)resultCode resultMessage:(NSString*)resultMessage {
//    NSLog(@"openAPIKeyAuthenticationResultCode : %d %@", resultCode, resultMessage);

    [_mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(_latdouble, _londouble)] zoomLevel:_zoomLevel animated:YES];
}

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
