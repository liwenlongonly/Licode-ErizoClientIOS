//
//  ErizoClientIOS
//
//  Copyright (c) 2015 Alvaro Gil (zevarito@gmail.com).
//
//  MIT License, see LICENSE file for details.
//

@import WebRTC;

@interface RTCIceCandidate (JSON)

+ (RTCIceCandidate *)candidateFromJSONDictionary:(NSDictionary *)dictionary;
- (NSData *)JSONData;

@end
