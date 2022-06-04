//
//  Teyemd.h
//  Teyemd
//
//  Created by Mayuwind on 2022/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Core class for implementing timer operations.
/// Configurable operations via optional chaining.
/// No need to deal with the start and end of the timer, it all runs automatically as designed.
@interface Teyemd : NSObject

/// The bound object must be a weak reference.
@property (nonatomic, weak, readonly) NSObject *target;

#pragma mark - initialization method

- (instancetype)initWithTarget:(NSObject *)target;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Optional configuration actions

/// incoming flag value.
@property (nonatomic, copy, readonly) NSString *flag;

/// pass in flag value.
@property (nonatomic, copy, readonly) Teyemd *(^withFlag)(NSString *flag);

/// Incoming time interval.
@property (nonatomic, copy, readonly) Teyemd *(^withInterval)(NSTimeInterval interval);

/// Incoming start-time delay interval.
@property (nonatomic, copy, readonly) Teyemd *(^withDelay)(NSTimeInterval interval);

/// Incoming repetitions.
@property (nonatomic, copy, readonly) Teyemd *(^withRepeat)(NSUInteger count);

/// Whether to ignore the sleep time, usually when the device enters the background sleep, the time is still running, the execution may be skipped next time it resumes, and this value is passed in so that the time will not be skipped during resume, that is, it will start from the stop.
@property (nonatomic, copy, readonly) Teyemd *(^wallTime)(BOOL isWallTime);

/// If asynchronous, a new background thread may be started, otherwise the main thread is used.
@property (nonatomic, copy, readonly) Teyemd *(^async)(void);

#pragma mark - Final execution

/// You always need to pass in this value for the method to wrap and the timer to start running.
@property (nonatomic, copy, readonly) void (^withHandler)(void (^handler)(void));

@end

NS_ASSUME_NONNULL_END
