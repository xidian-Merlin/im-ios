//
//  IMSessionKeyManager.m
//  TEST
//
//  Created by yuhui wang on 2017/1/12.
//  Copyright © 2017年 yuhui wang. All rights reserved.
//

#import "IMSessionKeyManager.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@implementation IMSessionKeyManager
{
    NSData* _sessionKey;
}
+ (instancetype)instance
{
    static IMSessionKeyManager* g_packageIDManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_packageIDManager = [[IMSessionKeyManager alloc] init];
    });
    return g_packageIDManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _sessionKey = [IMSessionKeyManager AESKeyGenerate];
    }
    return self;
}

+ (NSData *)AESKeyGenerate;
{
    //password
    uint8_t password[kCCKeySizeAES128];
    OSStatus result = SecRandomCopyBytes(kSecRandomDefault, kCCKeySizeAES128, password); //  /dev/random is used
    if (result != errSecSuccess)
    {
        CFShow(CFSTR("\nCould not create password"));
    }
    
    //salt
    uint8_t salt[8];
    result = SecRandomCopyBytes(kSecRandomDefault, 8, salt);
    if (result != errSecSuccess)
    {
        CFShow(CFSTR("\nCould not create salt"));
    }
    
    //key
    uint8_t derivedKey[16];
    CCCryptorStatus cryptResult = CCKeyDerivationPBKDF(kCCPBKDF2, (const char *)password, sizeof(password), salt, sizeof(salt), kCCPRFHmacAlgSHA1, 10000, derivedKey, kCCKeySizeAES128);
    if (cryptResult != kCCSuccess)
    {
        CFShow(CFSTR("\nCould not create key"));
    }
    CFDataRef keyData = CFDataCreate(kCFAllocatorDefault, derivedKey, kCCKeySizeAES128);
    
    return (__bridge NSData *)(keyData);
}

- (NSData *)sessionKey
{
    
    return _sessionKey;
}
@end
