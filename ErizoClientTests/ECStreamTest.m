//
//  ECStreamTest.m
//  ErizoClientIOS
//
//  Created by Alvaro Gil on 5/23/17.
//
//

#import "ECUnitTest.h"
#import "ECStream.h"

@interface ECStreamTest : ECUnitTest

@end

@implementation ECStreamTest

# pragma mark - Tests

- (void)testInitLocalStream {
    ECStream *stream = [[ECStream alloc] initLocalStream];
    XCTAssertTrue([self isVideoEnabled:stream]);
}

- (void)testInitLocalStreamWithoutVideo {
    ECStream *stream = [[ECStream alloc] initLocalStreamWithOptions:@{
                                                                      kStreamOptionVideo:@FALSE
                                                                      }
                                                         attributes:nil
                                                   videoConstraints:nil
                                                   audioConstraints:nil];
    XCTAssertFalse([self isVideoEnabled:stream]);
}

- (void)testAudioStreamHasNotBeenAdded {
    ECStream *stream = [[ECStream alloc] initLocalStreamWithOptions:@{
                                                                      kStreamOptionAudio:@FALSE
                                                                      }
                                                         attributes:nil];
    XCTAssertFalse([stream hasAudio]);
}

- (void)testAudioStreamHasBeenAdded {
    ECStream *stream = [[ECStream alloc] initLocalStream];
    XCTAssertTrue([stream hasAudio]);
}

# pragma mark - Helpers

- (BOOL)isVideoEnabled:(ECStream *)stream {
    return [[NSString stringWithFormat:@"%@",
             [stream.streamOptions objectForKey:kStreamOptionVideo]] boolValue];
}

- (BOOL)isAudioEnabled:(ECStream *)stream {
    return [[NSString stringWithFormat:@"%@",
             [stream.streamOptions objectForKey:kStreamOptionAudio]] boolValue];
}

- (BOOL)isDataEnabled:(ECStream *)stream {
    return [[NSString stringWithFormat:@"%@",
             [stream.streamOptions objectForKey:kStreamOptionData]] boolValue];
}

@end