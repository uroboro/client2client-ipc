# client2client-ipc
Transfer data using CPDistributedMessagingCenter between 2 or more clients.


## How to send data to the server

This will dispatch the same data to all listening clients:

```objc
CPDistributedMessagingCenter * center = [CPDistributedMessagingCenter centerNamed:@"com.your.tweak"];
NSDictionary * dictionary = @{ @"key" : @"value" };
[center sendMessageName:@"set" userInfo:dictionary];
```

## How to retrieve data from the server

This will dispatch the same data to all listening clients:

```objc
CPDistributedMessagingCenter * center = [CPDistributedMessagingCenter centerNamed:@"com.your.tweak"];
NSDictionary * reply = [center sendMessageAndReceiveReplyName:@"get" userInfo:nil];
NSLog(@"current configuration: %@", reply);
```
