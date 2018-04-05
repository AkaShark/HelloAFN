### 前记
最近在隔壁的小组有一个项目，由于好久没有学习iOS，所有想乘机温习下功课，然后就主动请缨，帮助他们一起写项目，因为这个项目是有网络请求的（话说都有吧）然后觉得之前用的学长的一些网络请求有点不是很理解，然后就想自己也来封装一个（其实就是想装逼么。。。）好废话不多说 开整。

### 前提
这个封装是基于AFN（iOS网络请求最好的框架）用的AFN3.0。其实就是感觉就是将复杂重复的代码提取到了一起，然后再统一的调用，这个就是应该所谓的代码高聚合低耦合吧。（不知道这个算不算是设计模式中的工厂模式，请各位知道的大佬给提个醒~）

### 正题
这个类总共封装了9个方法，其中包裹简单的get和post封装，还有上传图片的方法，其中最主要的，也是花时间最长的封装是关于cookie的封装，关于cookie的封装我遇到了一些小的问题等下再跟大家一一到来。废话少说，上代码。

```
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

```
以上就是我在.h中封装的一些函数头，这些函数的功能已经写得详细了。
然后就是.m的些内容了

```
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

```
里面的代码也有注释，相关的说明。下面就主要说下我遇到的问题吧。和怎么去解决的吧。

### 问题好相应的解决
#### 认识cookie
我遇到的主要问题就是在cookie的封装。cookie在我的理解就是一种客户端和服务器端保持链接的一种方式吧。主要来说就是，客户端登陆后，服务器端返回cookie标记这个用户，然后客户端再次请求的时候要再请求头中加入cookie，来标识身份，然后通过服务器端就会通过这个cookie来认定客户端。（说成大白话就是，客户端第一次进门的时候服务器端给了一个手牌，然后客户端在瞎逛的时候要拿着这个手牌，不然服务器端就不认他）。这是我对cookie的理解，也不知道是不是准确。

#### 问题
我开始用两种方式获取到看cookie。。。。很诡异吧两种关键还不一样感觉。。一种方式我从AFN的相应报头中获取的，另一种我是通过NSHTTPCookie这个iOS对象获取的。当时很懵逼。感觉像是得到了两个东西一样，但是不知道要用哪一个。。。哎很难受啊。于是各种百度。最后看来这个一片文章[我的救星](https://blog.csdn.net/it520nm/article/details/38868491)其中的一句话给我很重要的帮助

>使用NSHTTPCookie的类方法可以将NSHTTPCookie实例与HTTP cookie header相互转换.

>根据NSHTTPCookie实例数组生成对应的HTTP cookie header

>宛如醍醐灌顶啊。。。

在iOS中其实是有专门管理cookie的，他们是NSHTTPCookie和NSHTTPCookieStorage 其中NSHTTPCookie是每一个cookie对应的iOS对象，而NSHTTPCookieStorage是一个cookie的容器。这个cookie本来是在响应的包头中的，iOS将其转换为NSHTTPCookie然后再由NSHTTPCookieStorage这个容器来管理。（自己的理解）于是茅塞顿开

剩下的就撸代码了。
其中还有几点，我尝试用NSHTTPCookie来设置cookie但是从AFN的请求头并没有cookie，于是尝试了另外一种就是直接给AFN设置请求头，这个效果函数很好的，我没有抓包工具去测试，但是我看了AFN的请求头确实包含了cookie字段。
[AFN查看请求头响应头](https://blog.csdn.net/minggeqingchun/article/details/77051175)

### 后记 
放假了，清明节没出去，今天在宿舍泡一天美滋滋，明天照常上班学习去，假期最后一天打算和舍友骑着小蓝溜一圈去~~~ （在宿舍写的博客。坐着真是不舒服啊 写的不见谅了 给位大佬，也请大家指出说的不对不好的地方一起努力学习~）
