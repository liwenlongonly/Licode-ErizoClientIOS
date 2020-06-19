//
//  ErizoClientIOS
//
//  Copyright (c) 2015 Alvaro Gil (zevarito@gmail.com).
//
//  MIT License, see LICENSE file for details.
//

@import WebRTC;
#import "ErizoClient.h"
#import "rtc/ECClient.h"

@implementation ErizoClient

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
#ifdef DEBUG
        RTCSetMinDebugLogLevel(RTCLoggingSeverityError);
#endif
        RTCInitializeSSL();
        [ECClient setPreferredVideoCodec:@"VP8"];
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


+ (RTCPeerConnectionFactory *)getPeerConnectionFactory{
    static dispatch_once_t onceToken;
    static RTCPeerConnectionFactory* _instance = nil;
    dispatch_once(&onceToken, ^{
        if(_instance==nil){
            RTC_OBJC_TYPE(RTCDefaultVideoDecoderFactory) *decoderFactory =
                [[RTC_OBJC_TYPE(RTCDefaultVideoDecoderFactory) alloc] init];
            RTC_OBJC_TYPE(RTCDefaultVideoEncoderFactory) *encoderFactory =
                [[RTC_OBJC_TYPE(RTCDefaultVideoEncoderFactory) alloc] init];
            NSArray<RTC_OBJC_TYPE(RTCVideoCodecInfo) *> *codecs = [RTC_OBJC_TYPE(RTCDefaultVideoEncoderFactory) supportedCodecs];
            for (RTC_OBJC_TYPE(RTCVideoCodecInfo) * codec in codecs) {
                if([codec.name isEqualToString:@"VP8"]){
                    encoderFactory.preferredCodec = codec;
                }
            }
            _instance = [[RTCPeerConnectionFactory alloc] initWithEncoderFactory:encoderFactory decoderFactory:decoderFactory];
        }
    });
    return _instance;
}

@end
