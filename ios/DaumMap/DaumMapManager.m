#import <Foundation/Foundation.h>
#import "DaumMap.h"
#import "DaumMapManager.h"

@implementation DaumMapManager

@synthesize bridge = _bridge;

// Export a native module
// https://facebook.github.io/react-native/docs/native-modules-ios.html
RCT_EXPORT_MODULE();
// Return the native view that represents your React component
- (UIView *) view {
    _map = [[DaumMap alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
    return _map;
}

RCT_EXPORT_VIEW_PROPERTY(initialRegion, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(mapType, NSString)
RCT_EXPORT_VIEW_PROPERTY(markers, NSArray)
RCT_EXPORT_VIEW_PROPERTY(isTracking, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isCompass, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isCurrentMarker, BOOL)
RCT_EXPORT_VIEW_PROPERTY(region, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(polyLines, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(circles, NSArray)
RCT_EXPORT_VIEW_PROPERTY(onMarkerSelect, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMarkerPress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMarkerMoved, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onRegionChange, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onUpdateCurrentLocation, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onUpdateCurrentHeading, RCTDirectEventBlock)

// 임시 디렉토리에 저장된 지도 타일 캐쉬 데이터를 모두 삭제
RCT_EXPORT_METHOD(clearMapCache:(nonnull NSNumber *)reactTag) {
    [MTMapView clearMapTilePersistentCache];
}
@end
