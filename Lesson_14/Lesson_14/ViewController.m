//
//  ViewController.m
//  Lesson_14
//
//  Created by maxud on 26.09.17.
//  Copyright © 2017 lesson_1. All rights reserved.
//

#import "ViewController.h"

typedef void (^CompletionBlock)(BOOL success, NSError *error);
static NSString *const kWeatherURL = @"http://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b1b15e88fa797225412429c1c50c122a1";

@interface ViewController ()

@property (nonatomic,copy) void (^SomeBlock)(void);
@property (nonatomic,copy) NSInteger (^SomeBlock_2)(void);
@property (nonatomic,copy) NSInteger (^SomeBlock_3)(NSString *name, NSInteger age);

@property (nonatomic,copy) NSString*(^BlockWithBlock)(NSString*name ,void(^block)(NSString* string));
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    CompletionBlock block = (^)(){
//        NSLog(@"Some String");
//    }
    
    
    
    
    self.BlockWithBlock = ^NSString *(NSString *name, void (^block)(NSString *string)) {
        if (block)
        {
            block(name);
        }
        return [NSString stringWithFormat:@"string:%@",name];
    };
   
    self.BlockWithBlock(@"John",nil);
    
    self.SomeBlock_3 = ^NSInteger(NSString *name,NSInteger age) {
        return name.length;
    };

    __block NSInteger value = 0;
    
    void (^TestBlock)(void) = ^{
        NSLog(@"Test Block Code Here... %lu",value);
        value = 4;
    };
    
    TestBlock();
    NSLog(@"Test Block Code Here... %lu",value);
    
    
    NSInteger (^blockNAme)(void) = ^NSInteger()
    {
        return 24;
    };
    NSInteger someIntValue = blockNAme();
    NSLog(@"Some Value = %lu",someIntValue);
    
    [self runWithCompletionBlock:TestBlock];//
    [self runWithCompletionBlock:nil];
    [self runWithCompletionBlock:^{
        NSLog(@"Run BLock With Method..");
    }];
    [self runWithBlockWithParameters:^(NSString *name, NSUInteger age) {
        NSLog(@"Name:%@,Age:%lu",name,age);
    }];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kWeatherURL]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *jsonError = nil;
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            // Error Parsing JSON
            NSLog(@"%@",jsonError.localizedDescription);
        } else {
            // Success Parsing JSON
            // Log NSDictionary response:
            NSLog(@"%@",jsonResponse);
        }
    }];
    
    [dataTask resume];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self displayAlertController];
}

- (void)runWithBlockWithParameters:(void(^)(NSString *name,NSUInteger age))completionBlock
{
    if(completionBlock)
       {
           completionBlock(@"John",23);
       }
}

- (void)runWithCompletionBlock:(void(^)(void))completionBlock
{
   if(completionBlock)
   {
       completionBlock();
   }
    if (self.SomeBlock_3)
    {
        self.SomeBlock_3(@"Name",32);
    }
}

- (void)runWithTypeDefBlock:(CompletionBlock)completionBlock
{
    if(completionBlock)
    {
        completionBlock(YES,nil);
    }
}


- (void)displayAlertController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:@"Do you want to become iOS Developer?"
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1 UIAlertControllerStyleActionSheet
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"NO"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button NO");
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"YES"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed button YES");
                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
}
@end
