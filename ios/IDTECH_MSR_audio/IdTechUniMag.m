//
//  IdTechUniMag.m
//  IDTECH_MSR_audio
//
//  Created by Peace Chen on 5/30/2017.
//  Copyright © 2017 OnceThere. All rights reserved.
//

#import "IdTechUniMag.h"

uniMag *uniReader;
static NSMutableArray *s_noteAndSel_t = nil;

@implementation IDTECH_MSR_audio

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(activate,
                 readerType:(NSInteger)readerType
                 swipeTimeout:(NSInteger)swipeTimeout
                 logging:(BOOL)logging
                 activate_resolver:(RCTPromiseResolveBlock)resolve
                 activate_rejecter:(RCTPromiseRejectBlock)reject)
{
  //register observers for all uniMag notifications
  [self umsdk_registerObservers:TRUE];

  //enable info level NSLogs inside SDK
  // Here we turn on before initializing SDK object so the act of initializing is logged
  [uniMag enableLogging:logging];

  //initialize the SDK by creating a uniMag class object
  uniReader = [[uniMag alloc] init];

  //Set the reader type. The default is UniMag Pro.
  uniReader.readerType = (UmReader)readerType;

  //set SDK to perform the connect task automatically when headset is attached
  [uniReader setAutoConnect:TRUE];

  //set swipe timeout (0=infinite). By default, swipe task will timeout after 20 seconds
  [uniReader setSwipeTimeoutDuration:swipeTimeout];

  //make SDK maximize the volume automatically during connection
  [uniReader setAutoAdjustVolume:TRUE];

  UmRet ret = [uniReader startUniMag: TRUE];

  resolve(@{@"statusCode": @(ret),
            @"message": getUmReturnString(ret)} );
}

RCT_REMAP_METHOD(deactivate,
                 deactivate_resolver:(RCTPromiseResolveBlock)resolve
                 deactivate_rejecter:(RCTPromiseRejectBlock)reject)
{
  //deallocating the uniMag object deactivates the uniMag SDK
  //[uniReader release];
  uniReader = nil;

  //it is the responsibility of SDK client to unregister itself as notification observer
  [self umsdk_registerObservers:FALSE];

  resolve(@{@"statusCode": @0,
            @"message": @""} );
}

RCT_REMAP_METHOD(swipe,
                 swipe_resolver:(RCTPromiseResolveBlock)resolve
                 swipe_rejecter:(RCTPromiseRejectBlock)reject)
{
  //start the swipe task. ie, cause SDK to start waiting for a swipe to be made
  UmRet ret = [uniReader requestSwipe];

  resolve(@{@"statusCode": @(ret),
            @"message": getUmReturnString(ret)} );
}

//-----------------------------------------------------------------------------
#pragma mark - uniMag SDK notification registration -
//-----------------------------------------------------------------------------

-(void) umsdk_registerObservers:(BOOL) reg {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

  if (nil == s_noteAndSel_t) {
    s_noteAndSel_t = [[NSMutableArray alloc] init];
    //NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    noteAndSel_t * cd01 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd02 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd03 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd04 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd05 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd06 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd07 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd08 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd09 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd10 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd11 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd12 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd13 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd14 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd15 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd16 = [[noteAndSel_t alloc] init];
    noteAndSel_t * cd17 = [[noteAndSel_t alloc] init];
    [cd01 setV: uniMagAttachmentNotification       : @selector(umDevice_attachment:)];
    [cd02 setV: uniMagDetachmentNotification       : @selector(umDevice_detachment:)];
    [cd03 setV: uniMagInsufficientPowerNotification: @selector(umConnection_lowVolume:)];
    [cd04 setV: uniMagMonoAudioErrorNotification   : @selector(umConnection_monoAudioError:)];
    [cd05 setV: uniMagPoweringNotification         : @selector(umConnection_starting:)];
    [cd06 setV: uniMagTimeoutNotification          : @selector(umConnection_timeout:)];
    [cd07 setV: uniMagDidConnectNotification       : @selector(umConnection_connected:)];
    [cd08 setV: uniMagDidDisconnectNotification    : @selector(umConnection_disconnected:)];
    [cd09 setV: uniMagSwipeNotification            : @selector(umSwipe_starting:)];
    [cd10 setV: uniMagTimeoutSwipeNotification     : @selector(umSwipe_timeout:)];
    [cd11 setV: uniMagDataProcessingNotification   : @selector(umDataProcessing:)];
    [cd12 setV: uniMagInvalidSwipeNotification     : @selector(umSwipe_invalid:)];
    [cd13 setV: uniMagDidReceiveDataNotification   : @selector(umSwipe_receivedSwipe:)];
    [cd14 setV: uniMagCmdSendingNotification       : @selector(umCommand_starting:)];
    [cd15 setV: uniMagCommandTimeoutNotification   : @selector(umCommand_timeout:)];
    [cd16 setV: uniMagDidReceiveCmdNotification    : @selector(umCommand_receivedResponse:)];
    [cd17 setV: uniMagSystemMessageNotification    : @selector(umSystemMessage:)];
    [s_noteAndSel_t addObject: cd01];
    [s_noteAndSel_t addObject: cd02];
    [s_noteAndSel_t addObject: cd03];
    [s_noteAndSel_t addObject: cd04];
    [s_noteAndSel_t addObject: cd05];
    [s_noteAndSel_t addObject: cd06];
    [s_noteAndSel_t addObject: cd07];
    [s_noteAndSel_t addObject: cd08];
    [s_noteAndSel_t addObject: cd09];
    [s_noteAndSel_t addObject: cd10];
    [s_noteAndSel_t addObject: cd11];
    [s_noteAndSel_t addObject: cd12];
    [s_noteAndSel_t addObject: cd13];
    [s_noteAndSel_t addObject: cd14];
    [s_noteAndSel_t addObject: cd15];
    [s_noteAndSel_t addObject: cd16];
    [s_noteAndSel_t addObject: cd17];
    //[pool drain];
  }

  int len = (int)s_noteAndSel_t.count;
  //register or unregister
  for (int i=0; i<len; i++)
  {
    noteAndSel_t * cd = (noteAndSel_t *)[s_noteAndSel_t objectAtIndex : i];

    if (reg)
      [nc addObserver:self selector: cd.s name: cd.n object:nil];
    else
      [nc removeObserver:self name: cd.n object:nil];
  }
}

//-----------------------------------------------------------------------------
#pragma mark - uniMag SDK notification handlers  -
//-----------------------------------------------------------------------------

- (NSArray<NSString *> *)supportedEvents {
  return @[@"IdTechUniMagEvent"];
}

#pragma mark attachment

//called when uniMag is physically attached
- (void)umDevice_attachment:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umDevice_attachment",
                            @"message": @"Reader has been plugged in."}];
}

//called when uniMag is physically detached
- (void)umDevice_detachment:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umDevice_detachment",
                            @"message": @"Reader has been unplugged."}];
}

#pragma mark connection task

//called when attempting to start the connection task but iDevice's headphone playback volume is too low
- (void)umConnection_lowVolume:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umConnection_lowVolume",
                            @"message": @"Volume too low. Please maximize volume then re-attach the reader."}];
}

//called when attempting to start a task but iDevice's mono audio accessibility
// feature is enabled
- (void)umConnection_monoAudioError:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umConnection_monoAudioError",
                            @"message": @"Mono audio setting is enabled. Please disable it from iOS's Settings app."}];
}

//called when successfully starting the connection task
- (void)umConnection_starting:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umConnection_starting",
                            @"message": @"Starting connection with reader."}];
}

//called when SDK failed to handshake with reader in time. ie, the connection task has timed out
- (void)umConnection_timeout:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umConnection_timeout",
                            @"message": @"Connecting with reader timed out. Please try again."}];
}

//called when the connection task is successful. SDK's connection state changes to true
- (void)umConnection_connected:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umConnection_connected",
                            @"message": @"Reader successfully connected."}];
}

//called when SDK's connection state changes to false. This happens when reader becomes
// physically detached or when a disconnect API is called
- (void)umConnection_disconnected:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umConnection_disconnected",
                            @"message": @"Reader has been disconnected."}];
}

#pragma mark swipe task

//called when the swipe task is successfully starting, meaning the SDK starts to
// wait for a swipe to be made
- (void)umSwipe_starting:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umSwipe_starting",
                            @"message": @"Waiting for card swipe..."}];
}


//called when the SDK hasn't received a swipe from the device within a configured
// "swipe timeout interval".
- (void)umSwipe_timeout:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umSwipe_timeout",
                            @"message": @"Swipe timed out. Please try again."}];
}

//called when the SDK has read something from the uniMag device
// (eg a swipe, a response to a command) and is in the process of decoding it
// Use this to provide an early feedback on the UI
- (void)umDataProcessing:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umDataProcessing",
                            @"message": @"Processing swipe..."}];
}

//called when SDK failed to read a valid card swipe
- (void)umSwipe_invalid:(NSNotification *)notification {
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umSwipe_invalid",
                            @"message": @"Failed to read a valid swipe. Please try again."}];
}

//called when SDK received a swipe successfully
- (void)umSwipe_receivedSwipe:(NSNotification *)notification {
  NSData *data = [notification object];
  UMCardData *cd = [[UMCardData alloc] initWithBytes:data];

  // RCTConvert-serializable object
  NSObject * swipeData;
  if (cd.isAesEncrypted) {
    NSString *track1 = [[NSString alloc] initWithData:cd.track1 encoding:NSUTF8StringEncoding];
    NSString *track2 = [[NSString alloc] initWithData:cd.track2 encoding:NSUTF8StringEncoding];
    NSString *track3 = [[NSString alloc] initWithData:cd.track3 encoding:NSUTF8StringEncoding];
    NSString *track1_encrypted = [[NSString alloc] initWithData:cd.track1_encrypted encoding:NSUTF8StringEncoding];
    NSString *track2_encrypted = [[NSString alloc] initWithData:cd.track2_encrypted encoding:NSUTF8StringEncoding];
    NSString *track3_encrypted = [[NSString alloc] initWithData:cd.track3_encrypted encoding:NSUTF8StringEncoding];

    swipeData = @{
      @"isValid": [NSNumber numberWithBool:cd.isValid],
      @"isAesEncrypted": [NSNumber numberWithBool:cd.isAesEncrypted],
      @"tracks": @[track1, track2, track3],
      @"tracks_encrypted": @[track1_encrypted, track2_encrypted, track3_encrypted],
      @"serialNumber": [[NSString alloc] initWithData:cd.serialNumber encoding:NSUTF8StringEncoding],
      @"KSN": [[NSString alloc] initWithData:cd.KSN encoding:NSUTF8StringEncoding]
    };
  }
  else {
    swipeData = @{
      @"isValid": [NSNumber numberWithBool:cd.isValid],
      @"isAesEncrypted": [NSNumber numberWithBool:cd.isAesEncrypted],
      @"tracks": @[ [[NSString alloc] initWithData:cd.byteData encoding:NSUTF8StringEncoding] ]
    };
  }

  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umSwipe_receivedSwipe",
                            @"message": @"Successful swipe.",
                            @"data": swipeData}];
}

#pragma mark command task

//called when SDK successfully starts to send a command. SDK starts the command
// task
- (void)umCommand_starting:(NSNotification *)notification {
#ifdef DEBUG
  NSData *data = [notification object];
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umCommand_starting",
                            @"message": repr(data)}];
#endif
}

//called when SDK failed to receive a command response within a configured
// "command timeout interval"
- (void)umCommand_timeout:(NSNotification *)notification {
#ifdef DEBUG
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umCommand_timeout",
                            @"message": @"Command timed out. Please try again."}];
#endif
}

//called when SDK successfully received a response to a command
- (void)umCommand_receivedResponse:(NSNotification *)notification {
#ifdef DEBUG
  NSData *data = [notification object];
  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umCommand_receivedResponse",
                            @"message": repr(data)}];
#endif
}

#pragma mark misc

//this is a observer for a generic and extensible notification. It's currently only used during firmware update
- (void) umSystemMessage:(NSNotification *)notification {
  NSError *err = nil;
	err = [notification object];
  NSString *sysMsg = [NSString stringWithFormat:
    @"%ld: %@", (long)[err code], [[err userInfo] valueForKey:NSLocalizedDescriptionKey]];

  [self sendEventWithName:@"IdTechUniMagEvent"
                     body:@{@"type": @"umSystemMessage",
                            @"message": sysMsg} ];
}

@end
