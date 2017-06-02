
#import "UMCardData.h"

//------------------------------------------------------------------------------
#pragma mark - Utilities
//------------------------------------------------------------------------------

static BOOL isBitSet(Byte byte, int bitIndex) {
    Byte mask = (1 << bitIndex);
    return byte & mask;
}

//------------------------------------------------------------------------------
#pragma mark - Initialize
//------------------------------------------------------------------------------

@implementation UMCardData

@synthesize byteData   =_byteData;

@synthesize isValid        =_isValid;
@synthesize isEncrypted    =_isEncrypted;
@synthesize isAesEncrypted =_isAesEncrypted;

@synthesize track1=_track1;
@synthesize track2=_track2;
@synthesize track3=_track3;
@synthesize track1_encrypted=_track1_encrypted;
@synthesize track2_encrypted=_track2_encrypted;
@synthesize track3_encrypted=_track3_encrypted;

@synthesize serialNumber=_serialNumber;
@synthesize KSN=_KSN;

/*
- (void)dealloc {
    [_byteData   release];
    
    [_track1 release];
    [_track2 release];
    [_track3 release];
    [_track1_encrypted release];
    [_track2_encrypted release];
    [_track3_encrypted release];
    
    [_serialNumber release];
    [_KSN release];
    
    [super dealloc];
}
*/

- (id)initWithBytes: (NSData*)cardData {
    self = [super init];
    if (self && cardData) {
        self->_byteData   = [cardData copy];
        
        const UInt8     *bytes= cardData.bytes;
        const NSUInteger len  = cardData.length;
        
        //check validity and parse
        if (len >= 1) {
            //is valid encrypted swipe?
            if (bytes[0] == '\x02') {
                self->_isEncrypted = TRUE;
                [self verifyAndParse_encrypted: cardData];
            }
            //is valid unencrypted swipe?
            else {
                self->_isEncrypted = FALSE;
                [self verifyAndParse_unencrypted: cardData];
            }
        }
    }
    return self;
}

-(void) verifyAndParse_encrypted:(NSData*) cardData {
    /*
    Encrypted swipe format: STX LenL LenH <payload> CheckXor CheckSum ETX
    The rest... there's a document.
    */
    
    //things to fill out
    NSData *tracks    [3] = {nil, nil, nil};
    NSData *tracks_enc[3] = {nil, nil, nil};
    NSData *serialNumber = nil;
    NSData *ksn          = nil;
    BOOL    isAES = FALSE;  //true if AES, false if TDES
    BOOL    isSwipeDataValid = FALSE;
    
    //shorthand
    const UInt8     *bytes= cardData.bytes;
    const NSUInteger len  = cardData.length;
    
    //Verify
    if (len < 6)
        return;
    // STX ETX
    if (bytes[0    ] != '\x02' ||
        bytes[len-1] != '\x03'   )
        return;
    // Length
    int payloadLen =
        (bytes[2]<<8)+
        (bytes[1]   );
    if (payloadLen+6 != len)
        return;
    // CheckXor and CheckSum
    UInt8 cksum=0, ckxor=0;
    for (int i=3; i<len-3; i++) {
        ckxor ^= bytes[i];
        cksum += bytes[i];
    }
    if ( bytes[len-2]!=cksum ||
         bytes[len-3]!=ckxor    )
        return;
    
    //parse
    {
    #define CHECK_INDEX(I) {if ((I) > len-3) goto stopParse;}
    int idx = 0;
    
    //get track1, track2, track3 length
    int trackLens[3];
    idx = 5;
    CHECK_INDEX(idx+3);
    for (int i=0; i<3; i++)
        trackLens[i] = bytes[idx+i];
    
    //get masked track
    int trackLensSum=0;
    idx = 10;
    for (int i=0; i<3; i++) {
        //skip if len is 0 or presence flag not set
        if ( trackLens[i]==0 || !isBitSet(bytes[8],i) )
            continue;
        CHECK_INDEX(idx + trackLens[i]);
        tracks[i] = [cardData subdataWithRange: NSMakeRange(idx, trackLens[i])];
        idx          += trackLens[i];
        trackLensSum += trackLens[i];
    }
    
    //determine encryption type (TDES or AES)
    idx = 8;
    CHECK_INDEX(idx+1);
    Byte encType = ((bytes[idx]>>4) & 0x03);
    if      (encType == 0x00)
        isAES = FALSE;
    else if (encType == 0x01)
        isAES = TRUE;
    else
        goto stopParse;
        
    //TODO: none encrypting encrypted swipe
    
    //get encrypted section
    int trackLens_enc[3];
    int encryptionBlockSize = (isAES ? 16 : 8);
    for (int i=0; i<3; i++) {
        trackLens_enc[i] =
            ceil( trackLens[i] / (double)encryptionBlockSize ) * encryptionBlockSize;
    }
    int trackLensSum_enc=0;
    idx = 10 + trackLensSum;
    for (int i=0; i<3; i++) {
        //skip if len is 0 or presence flag not set
        if ( trackLens_enc[i]==0 || !isBitSet(bytes[9],i) )
            continue;
        CHECK_INDEX(idx + trackLens_enc[i]);
        tracks_enc[i] = [cardData subdataWithRange: NSMakeRange(idx, trackLens_enc[i])];
        idx              += trackLens_enc[i];
        trackLensSum_enc += trackLens_enc[i];
    }

    //get KSN
    if ( (isBitSet(bytes[9], 7)   ) &&
         (isBitSet(bytes[9], 0)||
          isBitSet(bytes[9], 1)||
          isBitSet(bytes[9], 2)   )   )
    {
        idx = (int)(len-3-10);
        if (idx < 10 + trackLensSum + trackLensSum_enc)
            goto stopParse;
        ksn = [cardData subdataWithRange: NSMakeRange(idx, 10)];
    }
    
    //get serial number
    if ( isBitSet(bytes[8], 7) ) {
        idx  = (int)len-3-10 - (ksn ? 10 : 0);
        if (idx < 10 + trackLensSum + trackLensSum_enc)
            goto stopParse;
        serialNumber = [cardData subdataWithRange: NSMakeRange(idx, 10)];
    }
    
    //all checks and parsing succeeded
    isSwipeDataValid = TRUE;
    
    #undef CHECK_INDEX
    }
    stopParse:
    
    //save result
    self->_isValid = isSwipeDataValid;
    self->_isAesEncrypted = isAES;
    self->_track1 = tracks[0];
    self->_track2 = tracks[1];
    self->_track3 = tracks[2];
    self->_track1_encrypted = tracks_enc[0];
    self->_track2_encrypted = tracks_enc[1];
    self->_track3_encrypted = tracks_enc[2];
    self->_serialNumber = serialNumber;
    self->_KSN          = ksn;
}

-(void) verifyAndParse_unencrypted:(NSData*) cardData {
    /*
    Unencrypted swipe is the concatenation of one or more tracks (as listed below),
    then ended by a "\x0D".
    Track formats (in regular expression):
    ISO_1: "[\x25][^\x3F]+[\x3F]"
    ISO_2: "[\x3B][^\x3F]+[\x3F]"
    JIS  : "[\x7F][^\x7F]+[\x7F]"
    */
    
    BOOL    isSwipeDataValid = FALSE;
    
    //shorthand
    const UInt8     *bytes= cardData.bytes;
    const NSUInteger len  = cardData.length;
    
    if (bytes[len-1] == '\x0D') {
        isSwipeDataValid = YES;
    }
    
    //save result
    self->_isValid = isSwipeDataValid;
}

@end
