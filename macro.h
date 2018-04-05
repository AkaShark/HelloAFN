//
//  macro.h
//  AFN
//
//  Created by kys-20 on 2018/3/28.
//  Copyright © 2018年 kys-20. All rights reserved.
//

#ifndef macro_h
#define macro_h


#ifdef DEBUG
#define ACLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define ACLog(...)
#endif







#endif /* macro_h */
