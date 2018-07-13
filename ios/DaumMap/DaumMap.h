// import UIKit so you can subclass off UIView
#import <UIKit/UIKit.h>

// import RCTBridge
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#import <React/UIView+React.h>
#import <React/RCTEventDispatcher.h>
#elif __has_include("RCTBridge.h")
#import "RCTBridge.h"
#import "UIView+React.h"
#import "RCTEventDispatcher.h"
#else
#import "React/RCTBridge.h" // Required when used as a Pod in a Swift project
#import "React/UIView+React.h"
#import "React/RCTEventDispatcher.h"
#endif

@class RCTEventDispatcher;

@interface DaumMap : UIView
  // Define view properties here with @property
    @property (nonatomic, assign) NSMutableDictionary *initialRegion;
    @property (nonatomic, copy) RCTDirectEventBlock onMarkerSelect;
    @property (nonatomic, copy) RCTDirectEventBlock onMarkerPress;
    @property (nonatomic, copy) RCTDirectEventBlock onMarkerMoved;
    @property (nonatomic, copy) RCTDirectEventBlock onRegionChange;
    @property (nonatomic, copy) RCTDirectEventBlock onUpdateCurrentLocation;

    @property (nonatomic, assign) float latdouble;
    @property (nonatomic, assign) float londouble;
    @property (nonatomic, assign) NSInteger zoomLevel;

    @property (nonatomic, assign) BOOL isTracking;
    @property (nonatomic, assign) BOOL isCompass;
    @property (nonatomic, assign) BOOL isCurrentMarker;

  // Initializing with the event dispatcher allows us to communicate with JS
  - (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher NS_DESIGNATED_INITIALIZER;

@end
