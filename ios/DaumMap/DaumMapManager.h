// import RCTViewManager
#if __has_include(<React/RCTViewManager.h>)
#import <React/RCTViewManager.h>
#elif __has_include("RCTViewManager.h")
#import "RCTViewManager.h"
#else
#import "React/RCTViewManager.h" // Required when used as a Pod in a Swift project
#endif

#import <DaumMap/MTMapView.h>

@interface DaumMapManager : RCTViewManager
    @property(nonatomic,strong)DaumMap *map;
@end
