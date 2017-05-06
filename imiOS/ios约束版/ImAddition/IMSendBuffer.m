//
//  SendBuffer.m
//

#import "IMSendBuffer.h"

@implementation IMSendBuffer
@synthesize sendPos; // 上次发送截止的位置

+ (id)dataWithNSData:(NSData *)newData;
{
	IMSendBuffer *obj = [IMSendBuffer alloc];
	return [obj initWithData:newData];
}

- (id)initWithData:(NSData *)newData
{
	self = [super init];
    if (self) {
		embeddedData = [NSMutableData dataWithData:newData];
		sendPos = 0;
	}
	
	return self;
}

- (void)consumeData:(NSInteger)length
{
	sendPos += length;
}



- (const void *)bytes
{
	return [embeddedData bytes];
}

- (NSUInteger)length
{
	return [embeddedData length];
}

- (void *)mutableBytes
{
	return [embeddedData mutableBytes];
}

- (void)setLength:(NSUInteger)length
{
	[embeddedData setLength:length];
}
@end
