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
    }

    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    _mapView.frame = self.bounds;
    [self addSubview:_mapView];
}

- (void) setMarkers:(NSArray *)markers {
    NSArray   *markerList = [NSArray arrayWithObjects: nil];

    for (int i = 0; i < [markers count]; i++) {
        NSDictionary *dict = [markers objectAtIndex:i];
        NSString *itemName = [dict valueForKey:@"name"];
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
        // markerItem.showAnimationType = MTMapPOIItemShowAnimationTypeNoAnimation; // Item이 화면에 추가될때 애니매이션
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

- (void) setInitialRegion:(NSDictionary *)region {
    float latdouble = 36.143099;
    float londouble = 128.392905;
    int zoomLevel   = 2;

    if ([region valueForKey:@"latitude"] != [NSNull null]) {
        latdouble = [[region valueForKey:@"latitude"] floatValue];
    }
    if ([region valueForKey:@"longitude"] != [NSNull null]) {
        londouble = [[region valueForKey:@"longitude"] floatValue];
    }
    if ([region valueForKey:@"zoomLevel"] != [NSNull null]) {
        zoomLevel = [[region valueForKey:@"zoomLevel"] intValue];
    }

    [_mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(latdouble, londouble)] zoomLevel:zoomLevel animated:YES];
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
    if (self.onMarkerSelectEvent) self.onMarkerSelectEvent(event);

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
    if (self.onMarkerPressEvent) self.onMarkerPressEvent(event);
    NSLog(@"touchedCalloutBalloonOfPOIItem");
}
@end
