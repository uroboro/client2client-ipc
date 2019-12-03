#import <rocketbootstrap/rocketbootstrap.h>
#import "CPDistributedMessagingCenter.h"


@interface YourTweakServer : NSObject {
	CPDistributedMessagingCenter * _messagingCenter;
}
@property (nonatomic, strong) NSMutableDictionary * configuration;
@property (nonatomic, retain) NSArray * supportedMessageNames;
@end

@implementation YourTweakServer

+ (void)load {
	[self sharedInstance];
}

+ (instancetype)sharedInstance {
	static dispatch_once_t once = 0;
	__strong static id sharedInstance = nil;
	dispatch_once(&once, ^{
		sharedInstance = [self new];
	});
	return sharedInstance;
}

- (instancetype)init {
	if ((self = [super init])) {
		self.configuration = [NSMutableDictionary new];
		self.supportedMessageNames = @[@"get", @"set"];

		_messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.your.tweak"];
		rocketbootstrap_distributedmessagingcenter_apply(_messagingCenter);

		[_messagingCenter runServerOnCurrentThread];
		for (NSString * messageName in self.supportedMessageNames) {
			[_messagingCenter registerForMessageName:messageName target:self selector:@selector(handleMessageNamed:withUserInfo:)];
		}
	}

	return self;
}

- (NSDictionary *)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
	switch ([self.supportedMessageNames indexOfObject:name]) {
		case 0: // get
			return self.configuration;

		case 1: // set
			[self.configuration addEntriesFromDictionary:userInfo];

			CFNotificationCenterPostNotification(
				CFNotificationCenterGetDarwinNotifyCenter(),
				CFSTR("com.your.tweak/set"),
				NULL,
				NULL,
				YES);
			return nil;
		
		default:
			return nil;
	}
}

@end
