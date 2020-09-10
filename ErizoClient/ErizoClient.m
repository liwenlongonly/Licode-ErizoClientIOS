//
//  ErizoClientIOS
//
//  Copyright (c) 2015 Alvaro Gil (zevarito@gmail.com).
//
//  MIT License, see LICENSE file for details.
//

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
            RTCDefaultVideoDecoderFactory *decoderFactory =
                [[RTCDefaultVideoDecoderFactory alloc] init];
            RTCDefaultVideoEncoderFactory *encoderFactory =
                [[RTCDefaultVideoEncoderFactory alloc] init];
            NSArray<RTCVideoCodecInfo *> *codecs = [RTCDefaultVideoEncoderFactory supportedCodecs];
            for (RTCVideoCodecInfo * codec in codecs) {
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
