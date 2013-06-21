//
//  GKAPICode.h
//  Grape
//
//  Created by 谢家欣 on 13-3-31.
//  Copyright (c) 2013年 guoku. All rights reserved.
//




#define SUCCESS 0 

#define OBJECT_EMPTY 10001
#define PREMISSIONS_DENY 10002
#define NOTE_ID_ERROR 10011
#define RECOMMENDATION_EMPTY_ERROR 10020

#define SESSION_ERROR 20001
#define PASSWD_NOT_MATCAH 20002
#define ABSENT_USER 20003
#define EMAIL_NOT_EXIST 20004
#define EMAIL_IS_REGISTER 20005
#define NICK_IS_USED 20006
#define NEED_REGISTER 20008


#define TOKEN_ERROR 30001
#define OTHER_USER_BINDED 30002
#define USER_ALREADY_BINDED 30003
#define TOKEN_EXPIRES 30004
#define WEIBO_USER_UPDATING 30005


#define EntityErrorDomain @"com.guoku.entity"
#define UserErrorDomain @"com.guoku.user"
#define ThreePartErrorDomain @"com.guoku.threepart"

typedef enum {
    kUserSessionError = -10000,
    kUserPasswdError,
    kAbsenUserError,
    kEmailIsUsedError,
    kAbsentEmailError,
    kNicknameIsUsedError,
    kNeedRegister,
} UserActionError;


typedef enum {
    kEntityIsEmpty = -20000,
    kPremissonDenyError,
    kNoteIdError,
    kRecommendationError,
} EntityError;

typedef enum {
    kTokenError = -30000,
    kTokenExpires,
    kOtherUserBinded,
    kUserAlreadyBinded,
    kWeiboUserUpdating,
} ThreePartAccountError;