//
//  SEGIntegrationsManager.h
//  Analytics
//
//  Created by Tony Xiao on 9/20/16.
//  Copyright © 2016 Segment. All rights reserved.
//

#import "SEGAnalyticsConfiguration.h"
#import "SEGCrypto.h"


@implementation UIApplication (SEGApplicationProtocol)

- (UIBackgroundTaskIdentifier)seg_beginBackgroundTaskWithName:(nullable NSString *)taskName expirationHandler:(void (^__nullable)(void))handler
{
    return [self beginBackgroundTaskWithName:taskName expirationHandler:handler];
}

- (void)seg_endBackgroundTask:(UIBackgroundTaskIdentifier)identifier
{
    [self endBackgroundTask:identifier];
}

@end


@interface SEGAnalyticsConfiguration ()

@property (nonatomic, copy, readwrite) NSDictionary *settings;
@property (nonatomic, strong, readonly) NSMutableArray *factories;

@end


@implementation SEGAnalyticsConfiguration

+ (instancetype)configurationWithSettings:(NSDictionary *_Nonnull) settings
{
    return [[SEGAnalyticsConfiguration alloc] initWithSettings:settings];
}

- (instancetype)initWithSettings:(NSDictionary *) settings
{
    if (self = [self init]) {
        self.settings = settings;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.shouldUseLocationServices = NO;
        self.enableAdvertisingTracking = YES;
        self.shouldUseBluetooth = NO;
        self.flushAt = 20;
        self.flushInterval = 30;
        self.maxQueueSize = 1000;
        self.payloadFilters = @{
            @"(fb\\d+://authorize#access_token=)([^ ]+)": @"$1((redacted/fb-auth-token))"
        };
        _factories = [NSMutableArray array];
        Class applicationClass = NSClassFromString(@"UIApplication");
        if (applicationClass) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            _application = [applicationClass performSelector:NSSelectorFromString(@"sharedApplication")];
#pragma clang diagnostic pop
        }
    }
    return self;
}

- (void)use:(id<SEGIntegrationFactory>)factory
{
    [self.factories addObject:factory];
}

@end
