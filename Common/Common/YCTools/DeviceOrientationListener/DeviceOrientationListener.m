//
//  DeviceOrientationListener.m
//  Common
//
//  Created by wlpiaoyi on 14/12/26.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "DeviceOrientationListener.h"
#import "Common.h"

static DeviceOrientationListener *xDeviceOrientationListener;
static id synDeviceOrientationListener;

@interface DeviceOrientationListener()
@property (strong,nonatomic) NSHashTable *tableListeners;
@end


@implementation DeviceOrientationListener
+(void) initialize{
    synDeviceOrientationListener = [NSObject new];
}
-(id) init{
    if(self=[super init]){
        UIDevice *device = [UIDevice currentDevice]; //Get the device object
        [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
        
        self.soundPath = [[NSBundle mainBundle] pathForResource:@"device_orientation"
                                                              ofType:@"wav"];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
        [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:device];
        self.tableListeners = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

+(DeviceOrientationListener*) getSingleInstance{
    @synchronized(synDeviceOrientationListener){
        if (!xDeviceOrientationListener) {
            xDeviceOrientationListener = [DeviceOrientationListener new];
            xDeviceOrientationListener.duration = GALOB_ANIMATION_TIME;
        }
    }
    return xDeviceOrientationListener;
}

/**
 旋转当前装置
 */
+(void) attemptRotationToDeviceOrientation:(UIDeviceOrientation) deviceOrientation completion:(void (^)(void)) completion{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[self getSingleInstance] setOrientation:deviceOrientation];
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = deviceOrientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        [UIViewController attemptRotationToDeviceOrientation];//这句是关键
        //保证当前线程执行完成后才执行下一个线程
        dispatch_barrier_async(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:[DeviceOrientationListener getSingleInstance].duration];
            if (completion) {
                completion();
            }
        });
        dispatch_barrier_async(dispatch_get_main_queue(), ^{
        });
//        dispatch_queue_t syn_queue;
//        syn_queue = dispatch_queue_create("com.wlpiaoyi.syn.synchronize",nil);
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        });

    }
}

-(void) addListener:(id<DeviceOrientationListenerDelegate>) listener{
    @synchronized(self.tableListeners){
        if ([self.tableListeners containsObject:listener]) {
            return;
        }
        [self.tableListeners addObject:listener];
    }
}
-(void) removeListenser:(id<DeviceOrientationListenerDelegate>) listener{
    @synchronized(self.tableListeners){
        [self.tableListeners removeObject:listener];
    }
}
- (void)orientationChanged:(NSNotification *)note{
    @synchronized(self.tableListeners){
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if (!isSupportOrientation(orientation)) {
            return;
        }
        [self setOrientation:orientation];
        
        for (id<DeviceOrientationListenerDelegate> listener in self.tableListeners) {
            switch (_orientation) {
                    // Device oriented vertically, home button on the bottom
                case UIDeviceOrientationPortrait:{
                    if([listener respondsToSelector:@selector(deviceOrientationPortrait)])[listener deviceOrientationPortrait];
                }
                    break;
                    // Device oriented vertically, home button on the top
                case UIDeviceOrientationPortraitUpsideDown:{
                    if([listener respondsToSelector:@selector(deviceOrientationPortraitUpsideDown)])[listener deviceOrientationPortraitUpsideDown];
                }
                    break;
                    // Device oriented horizontally, home button on the right
                case UIDeviceOrientationLandscapeLeft:{
                    if([listener respondsToSelector:@selector(deviceOrientationLandscapeLeft)])[listener deviceOrientationLandscapeLeft];
                }
                    break;
                    // Device oriented horizontally, home button on the left
                case UIDeviceOrientationLandscapeRight:{
                    if([listener respondsToSelector:@selector(deviceOrientationLandscapeRight)])[listener deviceOrientationLandscapeRight];
                }
                    break;
                default:{
                }
                    break;
            }
        }
    }
}

-(void) setOrientation:(UIDeviceOrientation)orientation{
    if (globalRotateHasVoice&&_orientation!=orientation) {
        [Utils soundWithPath:self.soundPath isShake:YES];
    }
    _orientation = orientation;
}

-(void) dealloc{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [device endGeneratingDeviceOrientationNotifications]; //Tell it to end monitoring the accelerometer for orientation
    [nc removeObserver:self name:UIDeviceOrientationDidChangeNotification object:device];
}


bool isSupportOrientation(UIDeviceOrientation orientation){
    UIInterfaceOrientationMask  supportedOrientations= [[Utils getWindow].rootViewController supportedInterfaceOrientations];
    int all = supportedOrientations;
    int cur = 1<<orientation;
    if (!(all&cur)) {
        return false;
    }
    supportedOrientations = [[Utils getCurrentController] supportedInterfaceOrientations];
    all = supportedOrientations;
    if (!(all&cur)) {
        return false;
    }
    return true;
}

@end

