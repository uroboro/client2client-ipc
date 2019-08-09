#import <rocketbootstrap/rocketbootstrap.h>
#import "CPDistributedMessagingCenter.h"


static void updateConfiguration(NSDictionary * configuration) {
	// Do something with the retrieved data
	NSLog(@"message: %@", configuration);
}

static CPDistributedMessagingCenter * gamePerformerCenter = nil;

static void fetchConfiguration() {
	NSDictionary * reply = [gamePerformerCenter sendMessageAndReceiveReplyName:@"get" userInfo:nil];
	updateConfiguration(reply);
}

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	fetchConfiguration();
}

__attribute__((constructor))
static void ctor(int argc, char **argv, char **env) {
	// Dispatch asynchronously
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		gamePerformerCenter = [CPDistributedMessagingCenter centerNamed:@"com.your.tweak"];
		rocketbootstrap_distributedmessagingcenter_apply(gamePerformerCenter);

		fetchConfiguration();

		CFNotificationCenterAddObserver(
			CFNotificationCenterGetDarwinNotifyCenter(),
			NULL, notificationCallback,
			CFSTR("com.your.tweak/set"), NULL,
			CFNotificationSuspensionBehaviorCoalesce);
	});
}
