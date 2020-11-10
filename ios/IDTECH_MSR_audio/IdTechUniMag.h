//
//  IdTechUniMag.h
//  IDTECH_MSR_audio
//
//  Created by Peace Chen on 5/30/2017.
//  Copyright © 2017 OnceThere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uniMag.h"
#import "UMCardData.h"
#import "utils.h"

#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif

#if __has_include(<React/RCTEventEmitter.h>)
#import <React/RCTEventEmitter.h>
#else
#import "RCTEventEmitter.h"
#endif

#if __has_include(<React/RCTConvert.h>)
#import <React/RCTConvert.h>
#else
#import "RCTConvert.h"
#endif

@interface IDTECH_MSR_audio : RCTEventEmitter <RCTBridgeModule>

@end
