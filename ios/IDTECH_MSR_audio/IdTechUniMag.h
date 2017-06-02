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
// React Native >= 0.40
#import <React/RCTConvert.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>
#else
// React Native <= 0.39
#import "RCTConvert.h"
#import "RCTEventEmitter.h"
#import "RCTBridgeModule.h"
#endif

@interface IDTECH_MSR_audio : RCTEventEmitter <RCTBridgeModule>

@end
