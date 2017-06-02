#import "uniMag.h"

NSString* repr(NSData* byteArray);
NSString* getUmReturnString(UmRet ret);

// -------------------------------------------------------------------------
// Used by umsdk_registerObservers ---- uniMag SDK notification registration
// -------------------------------------------------------------------------
@interface noteAndSel_t : NSObject
{
}
  @property (nonatomic, retain) NSString *n;
  @property (nonatomic, assign) SEL s;

-(void) setV: (NSString *) _nn : (SEL) _ss;
@end
