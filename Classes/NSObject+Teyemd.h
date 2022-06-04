//
//  NSObject+Teyemd.h
//  Teyemd
//
//  Created by Mayuwind on 2022/5/25.
//

#import <Foundation/Foundation.h>

#import <Teyemd/Teyemd.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Teyemd)

/// This property will always return a Teyemd instance.
@property (nonatomic, readonly) Teyemd *teyemd;

/// This property will return a Teyemd instance with the set interval.
@property (nonatomic, copy, readonly) Teyemd *(^teyemdWithInterval)(NSTimeInterval interval);

/// This property will return a Teyemd instance, if an instance of this flag exists, it will return the instance, if not, it will create one.
@property (nonatomic, copy, readonly) Teyemd *(^teyemdWithFlag)(NSString *flag);

/// Remove if needed, usually you don't need to do this, it follows the lifetime of the target object itself.
@property (nonatomic, copy, readonly) void (^removeTeyemdWithFlag)(NSString *flag);

@end

NS_ASSUME_NONNULL_END
