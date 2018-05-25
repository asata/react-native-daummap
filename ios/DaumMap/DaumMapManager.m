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
  return [[DaumMap alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

RCT_EXPORT_VIEW_PROPERTY(initialRegion, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(mapType, NSString)
RCT_EXPORT_VIEW_PROPERTY(markers, NSArray)
RCT_EXPORT_VIEW_PROPERTY(region, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onMarkerSelect, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMarkerPress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onRegionChange, RCTDirectEventBlock)


//RCT_EXPORT_VIEW_PROPERTY(exampleProp, NSString)
//// Export constants
//// https://facebook.github.io/react-native/releases/next/docs/native-modules-ios.html#exporting-constants
//- (NSDictionary *)constantsToExport
//{
//  return @{
//           @"EXAMPLE": @"example"
//           };
//}

@end
