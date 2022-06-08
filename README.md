# Teyemd
Block-based chained GCD timer.

[![CI Status](https://img.shields.io/travis/mayuwind/Teyemd.svg?style=flat)](https://travis-ci.org/mayuwind/Teyemd)
[![Version](https://img.shields.io/cocoapods/v/Teyemd.svg?style=flat)](https://cocoapods.org/pods/Teyemd)
[![License](https://img.shields.io/cocoapods/l/Teyemd.svg?style=flat)](https://cocoapods.org/pods/Teyemd)
[![Platform](https://img.shields.io/cocoapods/p/Teyemd.svg?style=flat)](https://cocoapods.org/pods/Teyemd)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Teyemd is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Teyemd'
```

## Usage

Usually if you need a countdown, you would use the following code:

```objective-c
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(<#delayInSeconds#> * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        <#code to be executed after a specified delay#>
    });

```
But with Teyemd, you just have to write:

```objective-c
    self.teyemdWithInterval(<#NSTimeInterval interval#>).withHandler(^{
        <#code#>
    });
```
It will be cancelled and released following the life cycle of the target object.

More importantly, it supports functions like NSTimer, just set the count of repetitions, it will be executed every time the time arrives.

```objective-c
    self.teyemdWithInterval(<#NSTimeInterval interval#>).withRepeat(<#NSUInteger count#>).withHandler(^{
        <#code#>
    });
```

If you need to actively remove:

```objective-c
    self.removeTeyemdWithFlag(<#NSString * _Nonnull flag#>);
```

## Author

Mayuwind, mayuwind@outlook.com

## License

Teyemd is available under the MIT license. See the LICENSE file for more info.
