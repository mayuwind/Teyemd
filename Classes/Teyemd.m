//
//  Teyemd.m
//  Teyemd
//
//  Created by Mayuwind on 2022/5/25.
//

#import "Teyemd.h"
#import "NSObject+Teyemd.h"

@interface Teyemd ()

/// Flag value
@property (nonatomic, copy) NSString *flag;

/// Time interval
@property (nonatomic, assign) NSTimeInterval interval;

/// Delay interval at startup
@property (nonatomic, assign) NSTimeInterval delay;

/// Repeat times
@property (nonatomic, assign) NSInteger count;

/// Whether to skip sleep time
@property (nonatomic, assign) BOOL isWallTime;

/// Whether to use async
@property (nonatomic, assign) BOOL isAsync;

/// Execute block
@property (nonatomic, copy) void (^handler)(void);

/// The GCD Timer
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation Teyemd

#pragma mark - Initialization method

- (instancetype)initWithTarget:(NSObject *)target {
    if (self = [super init]) {
        _target = target;
    }
    return self;
}

#pragma mark - Lifecycle cleanup

- (void)dealloc {
    [self stopTimer];
}

/// Stop and clean up the timer.
- (void)stopTimer {
    if (_timer != nil) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

#pragma mark - Public property methods

- (Teyemd * _Nonnull (^)(NSString * _Nonnull))withFlag {
    return ^(NSString *flag) {
        self.flag = flag;
        return self;
    };
}

- (Teyemd * _Nonnull (^)(NSTimeInterval))withInterval {
    return ^(NSTimeInterval interval) {
        self.interval = interval * NSEC_PER_SEC;
        return self;
    };
}

- (Teyemd * _Nonnull (^)(NSTimeInterval))withDelay {
    return ^(NSTimeInterval interval) {
        self.delay = interval * NSEC_PER_SEC;
        return self;
    };
}

- (Teyemd * _Nonnull (^)(NSUInteger))withRepeat {
    return ^(NSUInteger count) {
        self.count = count;
        return self;
    };
}

- (Teyemd * _Nonnull (^)(BOOL))wallTime {
    return ^(BOOL isWallTime) {
        self.isWallTime = isWallTime;
        return self;
    };
}

- (Teyemd * _Nonnull (^)(void))async {
    return ^{
        self.isAsync = YES;
        return self;
    };
}

- (void (^)(void (^ _Nonnull)(void)))withHandler {
    return ^(void (^handler)(void)) {
        self.handler = handler;
        // Preset a random value when the flag value does not exist.
        if (self.flag == nil || self.flag.length == 0) {
            self.flag = NSUUID.UUID.UUIDString;
        }
        if (self.interval > 0.f || self.delay > 0.f) {
            // Settings when used for countdown timer.
            if (self.interval > 0.f && self.count <= 1 && self.delay <= 0.f) {
                self.delay = self.interval;
            }
            // Use delays instead of time intervals.
            if (self.interval <= 0.f && self.delay > 0.f) {
                self.interval = self.delay;
            }
            dispatch_resume(self.timer);
        } else {
            self.target.removeTeyemdWithFlag(self.flag);
        }
    };
}

#pragma mark - Propertys

- (dispatch_source_t)timer {
    if (!_timer) {
        dispatch_queue_t queue = self.isAsync ? dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) : dispatch_get_main_queue();
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_time_t start = self.isWallTime ? dispatch_walltime(DISPATCH_TIME_NOW, self.delay) : dispatch_time(DISPATCH_TIME_NOW, self.delay);
        dispatch_source_set_timer(_timer, start, self.interval, 0);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_timer, ^{
            __strong typeof(weakSelf) self = weakSelf;
            self.count -= 1;
            if (self.count <= 0) {
                [self stopTimer];
                self.target.removeTeyemdWithFlag(self.flag);
            }
            if (self.handler) {
                self.handler();
            }
        });
    }
    return _timer;
}

@end
