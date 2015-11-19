//
//  KeyChain.h
//  LockScreenMedia
//
//  Created by njdby on 15/11/18.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
设置keychain项保护等级
NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                        (__bridge id)kSecAttrGeneric:@"MyItem",
                        (__bridge id)kSecAttrAccount:@"username",
                        (__bridge id)kSecValueData:@"password",
                        (__bridge id)kSecAttrService:[NSBundle mainBundle].bundleIdentifier,
                        (__bridge id)kSecAttrLabel:@"",
                        (__bridge id)kSecAttrDescription:@"",
                        (__bridge id)kSecAttrAccessible:(__bridge id)kSecAttrAccessibleWhenUnlocked};

OSStatus result = SecItemAdd((__bridge CFDictionaryRef)(query), NULL);
//keychain项保护等级列表
kSecAttrAccessibleWhenUnlocked                          //keychain项受到保护，只有在设备未被锁定时才可以访问
kSecAttrAccessibleAfterFirstUnlock                      //keychain项受到保护，直到设备启动并且用户第一次输入密码
kSecAttrAccessibleAlways                                //keychain未受保护，任何时候都可以访问 （Default）
kSecAttrAccessibleWhenUnlockedThisDeviceOnly            //keychain项受到保护，只有在设备未被锁定时才可以访问，而且不可以转移到其他设备
kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly        //keychain项受到保护，直到设备启动并且用户第一次输入密码，而且不可以转移到其他设备
kSecAttrAccessibleAlwaysThisDeviceOnly                  //keychain未受保护，任何时候都可以访问，但是不能转移到其他设备
*/
@interface KeyChain : NSObject

@end
