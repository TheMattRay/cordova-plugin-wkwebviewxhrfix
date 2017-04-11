//
//  CDVWKWebViewEngine+FileXhrFix.m
//  HelloCordova
//
//  Created by Connor Pearson on 2/9/17.
//
//

#import "CDVWKWebViewEngine+FileXhrFix.h"
#import <objc/runtime.h>

@implementation CDVWKWebViewEngine (FileXhrFix)
+ (void)load {
    SEL selector = NSSelectorFromString(@"createConfigurationFromSettings:");
    Method originalMethod = class_getInstanceMethod([CDVWKWebViewEngine class], selector);
    IMP originalImp = method_getImplementation(originalMethod);
    
    IMP newImp = imp_implementationWithBlock(^(id _self, NSDictionary* settings){
        // Get the original configuration
        WKWebViewConfiguration* configuration = originalImp(_self, selector, settings);
        
        // allow access to file api
        @try {
            [configuration.preferences setValue:@TRUE forKey:@"allowFileAccessFromFileURLs"];
        }
        @catch (NSException *exception) {}
        
        @try {
            [configuration setValue:@TRUE forKey:@"allowUniversalAccessFromFileURLs"];
        }
        @catch (NSException *exception) {}
        
        return configuration;
    });
    
    method_setImplementation(originalMethod, newImp);
}
@end