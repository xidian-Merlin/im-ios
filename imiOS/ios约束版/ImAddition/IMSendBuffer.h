//
//  SendBuffer.h
//

#import <Foundation/Foundation.h>

@interface IMSendBuffer : NSMutableData{
    @private
    NSMutableData *embeddedData;
	NSInteger sendPos;
}

@property (readonly) NSInteger sendPos;

+ (id)dataWithNSData:(NSData *)newdata;

- (id)initWithData:(NSData *)newdata;
- (void)consumeData:(NSInteger)length;

- (const void *)bytes;
- (NSUInteger)length;

- (void *)mutableBytes;
- (void)setLength:(NSUInteger)length;

@end
