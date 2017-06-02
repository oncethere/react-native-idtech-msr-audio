/*
This class parses raw card swipe data produced by a UniMag family card reader.
-UniMag family readers read ISO/IEC 7811 and other types of magnetic stripe cards. Cards have at most 3 "tracks" of data.
-Data format can be either encrypted or or unencrypted
-If property "isValid" is true, no problem was found during parsing.
*/

#import <Foundation/Foundation.h>

@interface UMCardData : NSObject

//Raw data
@property (readonly) NSData   *byteData;  //Raw data which was used to initialize this object.

//Meta
@property (readonly) BOOL isValid;        //All available fields were successfully parsed from the raw data
@property (readonly) BOOL isEncrypted;    //Whether the output is from an encrypting reader or a non-encrypting reader
@property (readonly) BOOL isAesEncrypted; //Only valid if isEncrypted==TRUE. If true, AES cipher is used, otherwise it's TDES

//Parsed parts. Even if isValid==TRUE, some fields may be nil if the reader did not output them.
// For example, reader may not read all tracks of a card. 

//  Tracks
//    If non-encrypting reader is used, it is the full plain text card data
//    If     encrypting reader is used, it is the partially masked plain text card data
@property (readonly) NSData *track1;
@property (readonly) NSData *track2;
@property (readonly) NSData *track3;

//  Encrypted Tracks. Only in encrypting reader output
@property (readonly) NSData *track1_encrypted;
@property (readonly) NSData *track2_encrypted;
@property (readonly) NSData *track3_encrypted;

//  Other. Only in encrypting reader output
@property (readonly) NSData *serialNumber;
@property (readonly) NSData *KSN;


//Init
- (id)initWithBytes: (NSData*)cardData;

@end
