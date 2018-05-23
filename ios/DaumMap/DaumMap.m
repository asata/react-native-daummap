//  Created by react-native-create-bridge
#import <Foundation/Foundation.h>
#import "KakaoMap.h"
#import <DaumMap/MTMapView.h>

// import RCTEventDispatcher
#if __has_include(<React/RCTEventDispatcher.h>)
#import <React/RCTEventDispatcher.h>
#elif __has_include("RCTEventDispatcher.h")
#import "RCTEventDispatcher.h"
#else
#import "React/RCTEventDispatcher.h" // Required when used as a Pod in a Swift project
#endif


@implementation KakaoMap : UIView  {
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
  NSInteger idx = 1;
  NSArray   *markerList = [NSArray arrayWithObjects: nil];
  
  for (int i = 0; i < [markers count]; i++) {
    NSDictionary *dict = [markers objectAtIndex:i];
    NSString *itemName = [dict valueForKey:@"name"];
    NSString *pinColor = [dict valueForKey:@"pinColor"];
    MTMapPOIItemMarkerType markerColor = MTMapPOIItemMarkerTypeBluePin;
    if ([pinColor isEqualToString:@"red"]) {
      markerColor = MTMapPOIItemMarkerTypeRedPin;
    } else if ([pinColor isEqualToString:@"yellow"]) {
      markerColor = MTMapPOIItemMarkerTypeYellowPin;
    } else if ([pinColor isEqualToString:@"blue"]) {
      markerColor = MTMapPOIItemMarkerTypeBluePin;
    }
    
    MTMapPOIItem* markerItem = [MTMapPOIItem poiItem];
    if (itemName != NULL) markerItem.itemName = itemName;
    float latdouble = [[dict valueForKey:@"x"] floatValue];
    float londouble = [[dict valueForKey:@"y"] floatValue];

    markerItem.mapPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(latdouble, londouble)];
    markerItem.markerType = markerColor;
    markerItem.showAnimationType = MTMapPOIItemShowAnimationTypeNoAnimation; // Item이 화면에 추가될때 애니매이션
    markerItem.draggable = YES;
    markerItem.tag = idx;
    idx++;

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
  NSLog(@"%@", mapType);
}

- (void) setInitialRegion:(NSDictionary *)region {
  float latdouble = [[region valueForKey:@"x"] floatValue];
  float londouble = [[region valueForKey:@"y"] floatValue];
  
  [_mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(latdouble, londouble)] animated:YES];
}
@end
