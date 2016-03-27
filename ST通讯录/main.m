//
//  main.m
//  ST通讯录
//
//  Created by chen_ryao on 16/1/11.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [Bmob registerWithAppKey:@"0256709a7854d209229528eb7f343ad9"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));

    }
}
