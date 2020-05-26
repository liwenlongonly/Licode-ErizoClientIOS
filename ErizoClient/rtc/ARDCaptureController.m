/*
 *  Copyright 2017 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "ARDCaptureController.h"

const Float64 kFramerateLimit = 15.0;

@implementation ARDCaptureController {
    __strong RTCCameraVideoCapturer *_capturer;
    BOOL _usingFrontCamera;
    int _width;
    int _height;
}

- (instancetype)initWithCapturer:(RTCCameraVideoCapturer *)capturer{
  if (self = [super init]) {
      _capturer = capturer;
      _usingFrontCamera = YES;
      _width = 0;
      _height = 0;
  }

  return self;
}

- (void)startCapture:(int)width H:(int)height {
    _width = width;
    _height = height;
  AVCaptureDevicePosition position =
      _usingFrontCamera ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
  AVCaptureDevice *device = [self findDeviceForPosition:position];
  AVCaptureDeviceFormat *format = [self selectFormatForDevice:device];

  if (format == nil) {
    RTCLogError(@"No valid formats for device %@", device);
    NSAssert(NO, @"");

    return;
  }

  NSInteger fps = [self selectFpsForFormat:format];

  [_capturer startCaptureWithDevice:device format:format fps:fps];
}

- (void)stopCapture {
  [_capturer stopCapture];
}

- (void)switchCamera {
  _usingFrontCamera = !_usingFrontCamera;
  [self startCapture:_width H:_height];
}

#pragma mark - Private

- (AVCaptureDevice *)findDeviceForPosition:(AVCaptureDevicePosition)position {
  NSArray<AVCaptureDevice *> *captureDevices = [RTCCameraVideoCapturer captureDevices];
  for (AVCaptureDevice *device in captureDevices) {
    if (device.position == position) {
      return device;
    }
  }
  return captureDevices[0];
}

- (AVCaptureDeviceFormat *)selectFormatForDevice:(AVCaptureDevice *)device {
  NSArray<AVCaptureDeviceFormat *> *formats =
      [RTCCameraVideoCapturer supportedFormatsForDevice:device];
  int targetWidth = _width;
  int targetHeight = _height;
  AVCaptureDeviceFormat *selectedFormat = nil;
  int currentDiff = INT_MAX;

  for (AVCaptureDeviceFormat *format in formats) {
    CMVideoDimensions dimension = CMVideoFormatDescriptionGetDimensions(format.formatDescription);
    FourCharCode pixelFormat = CMFormatDescriptionGetMediaSubType(format.formatDescription);
    int diff = abs(targetWidth - dimension.width) + abs(targetHeight - dimension.height);
    if (diff < currentDiff) {
      selectedFormat = format;
      currentDiff = diff;
    } else if (diff == currentDiff && pixelFormat == [_capturer preferredOutputPixelFormat]) {
      selectedFormat = format;
    }
  }

  return selectedFormat;
}

- (NSInteger)selectFpsForFormat:(AVCaptureDeviceFormat *)format {
  Float64 maxSupportedFramerate = 0;
  for (AVFrameRateRange *fpsRange in format.videoSupportedFrameRateRanges) {
    maxSupportedFramerate = fmax(maxSupportedFramerate, fpsRange.maxFrameRate);
  }
  return fmin(maxSupportedFramerate, kFramerateLimit);
}

@end
