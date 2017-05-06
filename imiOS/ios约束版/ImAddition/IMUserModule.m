//
//  IMUserModule.m
//  im
//
//  Created by yuhui wang on 16/7/29.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMUserModule.h"
#import "IMClientState.h"

@interface IMUserModule(PrivateAPI)

- (void)p_loadLocalUserData;
- (void)p_loadDepartmentData;

@end

@implementation IMUserModule
{
    NSMutableDictionary* _allUsers;
}
+ (IMUserModule*)shareInstance
{
    static IMUserModule* g_userModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_userModule = [[IMUserModule alloc] init];
    });
    return g_userModule;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self registObserveClientState];
        _allUsers = [[NSMutableDictionary alloc] init];
    }
    return self;
}
/*
#pragma mark -
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:IM_USER_STATE_KEYPATH]) {
        IMClientState *clientState = (IMClientState *)object;
        switch (clientState.userState) {
            case IMUserOnline:      //上线,可以获取所有的联系人.
                [self p_loadLocalUserData];
                [self allUserReq];
                break;
                
            default:
                break;
        }
    }
}

-(void)allUserReq{
    
    IMSysConfigEntity* sysConfigEntity = [[IMSysConfigModule shareInstance] getSysConfigEntity:IM_SYS_CONFIG_USER_LASTUPTIME];
    NSInteger latestUpdateTime = sysConfigEntity.sysConfigValue;
    IMAllUserAPI *api = [[IMAllUserAPI alloc] init];
    [api requestWithObject:@[@(latestUpdateTime)] Completion:^(id response, NSError *error) {
        if (!error) {
            NSInteger responseLastUpdateTime = [[response objectForKey:@"latestUpdateTime"] integerValue];
            
            if(latestUpdateTime==0|| latestUpdateTime!=responseLastUpdateTime){
                NSMutableArray *userArray = [response objectForKey:@"userlist"];
                [self addMaintainOriginEntities:userArray];
                [[IMDatabaseUtil instance] insertUsers:userArray];
                [[IMSysConfigModule shareInstance] addSysConfigEntitiesToDBAndMaintainWithsysConfigName:IM_SYS_CONFIG_USER_LASTUPTIME sysConfigValue:responseLastUpdateTime];
            }
            //通知UI更新.🐓
            [IMClientState shareInstance].dataState = [IMClientState shareInstance].dataState | IMRemoteUserDataReady;
        }else{
            
            DDLog(@"error:%@",[error domain]);
        }
    }];
    
}


-(IMUserEntity *)myUserEntity{
    NSString *myUserId = [[IMClientState shareInstance] userID];
    return (IMUserEntity *)[self getOriginEntityWithOriginID:myUserId];
}

#pragma protocol

-(NSArray *)getAllOriginEntity{
    return [NSArray arrayWithArray:[_allUsers allValues]];
}

-(NSArray *)getAllUserId{
    return  [NSArray arrayWithArray:[_allUsers allKeys]];
}
- (void)addMaintainOriginEntities:(NSArray*)originEntities{
    
    for (IMUserEntity *userEntity in originEntities) {
        [[SpellLibrary instance] addSpellForObject:userEntity];
        [_allUsers setObject:userEntity forKey:userEntity.ID];
    }
}
/**
 *  根据OriginID获取实体类
 *
 *  @param originID originID
 *
 *  @return 实体类
 */
- (IMOriginEntity*)getOriginEntityWithOriginID:(NSString*)originID{
    return [_allUsers objectForKey:originID];
}

/**
 *  在本地没有相应信息的时候调用此接口，从后端获取
 *
 *  @param originIDs  originIDs
 *  @param completion 完成获取
 */
/*
- (void)getOriginEntityWithOriginIDsFromRemoteCompletion:(NSArray*)originIDs completion:(IMGetOriginsInfoCompletion)completion{
    if ([originIDs count] == 0)
    {
        return;
    }
    IMUserDetailInfoAPI* userDetailInfoAPI = [[IMUserDetailInfoAPI alloc] init];
    [userDetailInfoAPI requestWithObject:originIDs Completion:^(id response, NSError *error) {
        if (!error && response)
        {
            [self addMaintainOriginEntities:response];
        }
        completion(response,error);
    }];
}

- (void)removeOriginForIDs:(NSArray*)originIDs{
    [_allUsers removeObjectsForKeys:originIDs];
}


#pragma mark -
#pragma mark - PrivateAPI
- (void)p_loadLocalUserData
{
    NSArray* users = [[MTDatabaseUtil instance] queryUsers];
    [self addMaintainOriginEntities:users];
    [DDClientState shareInstance].dataState = [DDClientState shareInstance].dataState | DDLocalUserDataReady;
}
*/
@end
