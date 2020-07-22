#import "FpsPlugin.h"

@implementation FpsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"fps"
            binaryMessenger:[registrar messenger]];
  FpsPlugin* instance = [[FpsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getRefreshRate" isEqualToString:call.method]) {
   result(@([self getRefreshRate:call.arguments]));
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (double)displayRefreshRate:(CADisplayLink *)link {
    if (@available(iOS 10.3, *)) {
        NSInteger preferredFPS = link.preferredFramesPerSecond;  // iOS 10.0

        // From Docs:
        // The default value for preferredFramesPerSecond is 0. When this value is 0, the preferred
        // frame rate is equal to the maximum refresh rate of the display, as indicated by the
        // maximumFramesPerSecond property.

        if (preferredFPS != 0) {
            return @(preferredFPS).doubleValue;
        }

        return @([UIScreen mainScreen].maximumFramesPerSecond).doubleValue;  // iOS 10.3
    } else {
        return 60.0;
    }
}

- (void)onDisplayLink:(CADisplayLink *)link {
    NSLog(@"framesPerSecond：%lf", [self displayRefreshRate:link]);
}

- (double)getRefreshRate:(NSDictionary *)arguments {
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
    return [self displayRefreshRate:link];
}


@end
