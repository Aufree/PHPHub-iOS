//
//  DebugConstant.h
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//


#define DEBUG_HTTP NO
#define DEBUG_ANALYTICS NO


#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define debugLog(...)
#define debugMethod()
#define NSLog(...)
#endif
