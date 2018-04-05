//
//  HelloAFN.m
//  AFN
//
//  Created by kys-20 on 2018/3/28.
//  Copyright © 2018年 kys-20. All rights reserved.
//

#import "HelloAFN.h"
#import <AFNetworking.h>
#import "macro.h"

@implementation HelloAFN



//时间戳
+ (NSString *)TheTimeStamp{
    //设置一个NSDateFormatter的格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}

//get
+ (void)GET:(NSString *)URLString parameters:(id)parameters succeed:(void (^)(id responseObject))succeed failure:(void (^)(NSError *error))failure
{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"",@"",nil];
    //发送网络请求(请求方式为GET)
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //会话 可以在这里上传下载 *downloadProgress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

//post
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //返回非json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //image 加解析 image/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //会话 可以在这里上传下载 *downloadProgress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//cookie get
+ (void)GET:(NSString *)URLString parameters:(id)parameters succeed:(void (^)(id responseObject))succeed failure:(void (^)(NSError *error))failure andWithCookie:(BOOL)is
{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"",nil];
//     需要cookie
    if(is)
    {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        
            //在afn中设置cookie
            NSString *cookie = [[NSString alloc] init];
            NSDictionary *dic =[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            if ([dic[@"Cookie"] isKindOfClass:[NSArray class]])
            {
                cookie = dic[@"Cookie"][0];
            }
            else{
                cookie = dic[@"Cookie"];
            }
            [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
        
//            NSHTTPCookie *cookie;
//            for (cookie in cookies)
//            {
//                [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
//
//            }
//        NSData *cookieData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:cookie forKey:@"Cookie"];
    }
    //发送网络请求(请求方式为GET)
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //会话 可以在这里上传下载 *downloadProgress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//cookie post
+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure andWithCookie:(BOOL)is
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //返回非json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //image 加解析 image/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
//    装入cookie
    if(is)
    {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];

////            在afn中设置cookie
                        NSString *cookie = [[NSString alloc] init];
                        NSDictionary *dic =[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
                        if ([dic[@"Cookie"] isKindOfClass:[NSArray class]])
                        {
                            cookie = dic[@"Cookie"][0];
                        }
                        else{
                            cookie = dic[@"Cookie"];
                        }
                        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
        
//            NSHTTPCookie *cookie;
//            for (cookie in cookies)
//            {
//                [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
//                
//            }
//            NSData *cookieData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:cookie forKey:@"Cookie"];
    }
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //会话 可以在这里上传下载 *downloadProgress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


//images
+(void)PostThrImagesWithDic:(NSDictionary *)dic WithImg:(NSDictionary *)imgDic url:(NSString *)url success:(void (^)(NSDictionary *))success faile:(void (^)(NSError *))faile
{
    AFHTTPSessionManager *postAvatarManger = [AFHTTPSessionManager manager];
    postAvatarManger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [postAvatarManger POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (id key in imgDic)
        {
            UIImage *image = [imgDic objectForKey:key];
            NSData *data = [[NSData alloc] init];
            data = UIImageJPEGRepresentation(image, 1.0);
            CGFloat count = 100;
            while (data.length>102400)
            {
                count--;
                data = UIImageJPEGRepresentation(image, count/100);
            }
            //name: 后台规定的key
            //fileName:自己给文件起名
            //mimeType :图片类型
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"%@",key] fileName:[NSString stringWithFormat:@"%@.jpeg",key] mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faile(error);
    
    }];
    
}
//cookie images
+(void)PostThrImagesWithDic:(NSDictionary *)dic WithImg:(NSDictionary *)imgDic url:(NSString *)url success:(void (^)(NSDictionary *))success faile:(void (^)(NSError *))faile is:(BOOL)yes
{
    AFHTTPSessionManager *postAvatarManger = [AFHTTPSessionManager manager];
    if(yes)
    {
//        取出cookie
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *cookie =[defaults objectForKey:@"Cookie"];
//        放到请求头中
        [postAvatarManger.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    postAvatarManger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [postAvatarManger POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (id key in imgDic)
        {
            UIImage *image = [imgDic objectForKey:key];
            NSData *data = [[NSData alloc] init];
            data = UIImageJPEGRepresentation(image, 1.0);
            CGFloat count = 100;
            while (data.length>102400)
            {
                count--;
                data = UIImageJPEGRepresentation(image, count/100);
            }
            //name: 后台规定的key
            //fileName:自己给文件起名
            //mimeType :图片类型
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"%@",key] fileName:[NSString stringWithFormat:@"%@.jpeg",key] mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faile(error);
        
    }];
}
//清除cookie
+(void)removeAllCookie
{
    NSUserDefaults *defatlus = [NSUserDefaults standardUserDefaults];
//    转化字典
    NSDictionary *dictionary = [defatlus dictionaryRepresentation];
    for (NSString *key in [dictionary allKeys])
    {
        if ([key isEqualToString:@"Cookie"])
        {
            [defatlus removeObjectForKey:key];
            [defatlus synchronize];
        }
    }
}
// 更新cookie
+(void)upDataTheCookie
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSString *cookie = [[NSString alloc] init];
    NSDictionary *dic = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    if ([dic[@"Cookie"] isKindOfClass:[NSArray class]])
    {
        cookie = dic[@"Cookie"][0];
    }
    else{
        cookie = dic[@"Cookie"];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cookie forKey:@"Cookie"];
    [defaults synchronize];
}

@end
