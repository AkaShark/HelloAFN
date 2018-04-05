//
//  HelloAFN.h
//  AFN
//
//  Created by kys-20 on 2018/3/28.
//  Copyright © 2018年 kys-20. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "macro.h"

/**
 注：以下封装只针对json数据
 */
@interface HelloAFN : NSObject

/**
 时间戳

 @return 返回时间戳
 */
+(NSString *)TheTimeStamp;

/**
 封装get请求
 
 @param URLString URL
 @param parameters 参数字典
 @param succeed 成功后返回的JSON数据
 @param failure 失败后返回的JSON数据
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters succeed:(void (^)(id responseObject))succeed failure:(void (^)(NSError *error))failure;


/**
 封装post请求
 
 @param URLString URL
 @param parameters 参数字典
 @param success 成功后返回的JSON
 @param failure 失败后返回的JSON
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 这个请求过后的请求需要添加cookie（一般是在登陆的请求）

 @param URLString 请求URL
 @param parameters 参数
 @param succeed 成功json
 @param failure 是吧json
 @param is 是否需要cookie
 
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters succeed:(void (^)(id responseObject))succeed failure:(void (^)(NSError *error))failure andWithCookie:(BOOL)is;

/**
 这个请求过后的请求需要添加cookie（一般是在登陆的请求）此方法一般常用
 @param URLString 请求url
 @param parameters 参数
 @param success 成功json
 @param failure 失败json
 @param is 是否需要
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure andWithCookie: (BOOL)is;




/**
 上传图片
 (大的图片有压缩)
 @param dic 除去图片还需要的参数
 @param imgDic 图片的字典
 @param url 上传的url
 @param success 成功回调
 @param faile 失败回调
 */
+(void)PostThrImagesWithDic:(NSDictionary *)dic WithImg:(NSDictionary *)imgDic url:(NSString *)url success:(void (^)(NSDictionary *))success faile:(void (^)(NSError *))faile;


/**
 移除cookie
 */
+(void)removeAllCookie;

/**
 更新cookie
 */
+(void)upDataTheCookie;

/**
 上传图片（含有cookie）

 @param dic 其他参数
 @param imgDic image字典
 @param url url地址
 @param success 成功回调
 @param faile 失败回调
 @param yes 是否cookie
 */
+(void)PostThrImagesWithDic:(NSDictionary *)dic WithImg:(NSDictionary *)imgDic url:(NSString *)url success:(void (^)(NSDictionary *))success faile:(void (^)(NSError *))faile is:(BOOL)yes;



@end
