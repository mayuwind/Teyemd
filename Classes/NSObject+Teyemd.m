//
//  NSObject+Teyemd.m
//  Teyemd
//
//  Created by Mayuwind on 2022/5/25.
//

#import "NSObject+Teyemd.h"
#import <objc/runtime.h>

@interface NSObject ()

/// All Teyemd instances will be stored in an array.
/// Implement data association through runtime binding.
@property (nonatomic, strong, readonly) NSMutableArray<Teyemd *> *teyemds;

@end

@implementation NSObject (Teyemd)

- (Teyemd *)teyemd {
    Teyemd *tey = [[Teyemd alloc] initWithTarget:self];
    [self.teyemds addObject:tey];
    return tey;
}

- (NSMutableArray<Teyemd *> *)teyemds {
    @synchronized (self) {
        NSMutableArray<Teyemd *> *teyemds = objc_getAssociatedObject(self, @selector(teyemds));
        if (teyemds == nil) {
            teyemds = [NSMutableArray array];
            objc_setAssociatedObject(self, @selector(teyemds), teyemds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return teyemds;
    }
}

- (Teyemd * _Nonnull (^)(NSTimeInterval))teyemdWithInterval {
    return ^(NSTimeInterval interval) {
        return self.teyemd.withInterval(interval);
    };
}

- (Teyemd * _Nonnull (^)(NSString * _Nonnull))teyemdWithFlag {
    return ^(NSString *flag) {
         __block Teyemd *teyemd = nil;
        // First query from the array associated with itself.
        [self.teyemds.copy enumerateObjectsUsingBlock:^(Teyemd * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.flag != nil && obj.flag.length > 0 && [obj.flag isEqualToString:flag]) {
                teyemd = obj;
                *stop = YES;
            }
        }];
        // Otherwise recreate and return.
        if (teyemd == nil) {
            teyemd = self.teyemd.withFlag(flag);
        }
        return teyemd;
    };
}

- (void (^)(NSString * _Nonnull))removeTeyemdWithFlag {
    return  ^(NSString *flag) {
        __block Teyemd *teyemd = nil;
       // First query from the array associated with itself.
       [self.teyemds.copy enumerateObjectsUsingBlock:^(Teyemd * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           if (obj.flag != nil && obj.flag.length > 0 && [obj.flag isEqualToString:flag]) {
               teyemd = obj;
               *stop = YES;
           }
       }];
       // If it exists it will be removed.
       if (teyemd != nil) {
           [self.teyemds removeObject:teyemd];
       }
    };
}

@end
