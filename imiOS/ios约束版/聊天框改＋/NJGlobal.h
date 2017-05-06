//
//  NJGlobal.h


#ifndef _7__________NJGlobal_h
#define _7__________NJGlobal_h

#define NJInitH(name) \
- (instancetype)initWithDict:(NSDictionary *)dict; \
+ (instancetype)name##WithDict:(NSDictionary *)dict;

#define NJInitM(name)\
- (instancetype)initWithDict:(NSDictionary *)dict \
{ \
    if (self = [super init]) { \
        [self setValuesForKeysWithDictionary:dict]; \
    } \
    return self; \
} \
+ (instancetype)name##WithDict:(NSDictionary *)dict \
{ \
    return [[self alloc] initWithDict:dict]; \
}

#endif
