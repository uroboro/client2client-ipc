#import <Foundation/Foundation.h>

@interface CPDistributedMessagingCenter: NSObject
+ (instancetype)centerNamed:(NSString *)name;
- (void)runServerOnCurrentThread;
- (void)registerForMessageName:(NSString *)name target:(id)target selector:(SEL)selector;
- (BOOL)sendMessageName:(NSString *)name userInfo:(id)userInfo;
- (id)sendMessageAndReceiveReplyName:(NSString *)name userInfo:(id)userInfo;
@end
