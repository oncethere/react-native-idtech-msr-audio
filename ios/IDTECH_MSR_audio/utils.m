#import <Foundation/Foundation.h>
#import "utils.h"

//get C source code representation of a byte string
NSString* repr(NSData* byteArray) {
    NSMutableString * ret = [NSMutableString string];

    @autoreleasepool
    {
        const int len = (int)byteArray.length;
        const Byte *bytes = byteArray.bytes;
        NSString *chr=nil;
        char oneCharStr[2] = {0,0};

        for (int i=0; i<len; i++)
        {
            //special escaped char
            if        (bytes[i] == '\t') {
                chr = @"\\t";
            } else if (bytes[i] == '\n') {
                chr = @"\\n";
            } else if (bytes[i] == '\r') {
                chr = @"\\r";
            } else if (bytes[i] == '\\') {
                chr = @"\\";
            }
            //printable char
            else if (bytes[i] >= 0x20 && bytes[i] <= 0x7E) {
                oneCharStr[0] = bytes[i];
                chr = [NSString stringWithCString:oneCharStr encoding:NSASCIIStringEncoding];
            }
            //normal escaped char eg 0xab => \xab
            else {
                chr = [NSString stringWithFormat:@"\\x%02x", bytes[i]];
            }

            //
            [ret appendString: chr];
        }
    }

    return ret;
}

NSString* getUmReturnString(UmRet ret) {
  NSString *s;
  do {
    switch (ret) {
    case UMRET_SUCCESS          : s=@""; break;
    case UMRET_NO_READER        : s=@"No reader attached"; break;
    case UMRET_SDK_BUSY         : s=@"Communication with reader in progress"; break;
    case UMRET_MONO_AUDIO       : s=@"Mono audio enabled"; break;
    case UMRET_ALREADY_CONNECTED: s=@"Already connected"; break;
    case UMRET_LOW_VOLUME       : s=@"Low volume"; break;
    case UMRET_NOT_CONNECTED    : s=@"Not connected"; break;
    case UMRET_NOT_APPLICABLE   : s=@"Not applicable to reader type"; break;
    case UMRET_INVALID_ARG      : s=@"Invalid argument"; break;
    case UMRET_UF_INVALID_STR   : s=@"Invalid firmware update string"; break;
    case UMRET_UF_NO_FILE       : s=@"Firmware file not found"; break;
    case UMRET_UF_INVALID_FILE  : s=@"Invalid firmware file"; break;
    default: s=@"<unknown code>"; break;
    }
  } while (0);

  return s;
}

// -------------------------------------------------------------------------
// Used by umsdk_registerObservers --- uniMag SDK notification registration
// -------------------------------------------------------------------------
@implementation noteAndSel_t
@synthesize n = _n;
@synthesize s = _s;

-(id) init {
  self = [super init];
  if (self) {
    _n = @"";
    _s = nil;
  }
  return self;
}

-(void) setV: (NSString *) _nn : (SEL) _ss;
{
  _n = _nn;
  _s = _ss;
}
@end
