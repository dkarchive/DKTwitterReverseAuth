//
//  ViewController.m
//  Demo
//
//  Created by Daniel Khamsing on 9/30/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "ViewController.h"

// DKTWReverseAuth
#import "DKTwitterReverseAuth.h"

// Keys
#import "DktwreverseauthdemoKeys.h"

// Frameworks
@import Accounts;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DktwreverseauthdemoKeys *keys = [[DktwreverseauthdemoKeys alloc] init];
    [[DKTwitterReverseAuth sharedInstance] configureConsumerKey:keys.twitterConsumerKey consumerSecret:keys.twitterConsumerSecret];
}

#pragma mark Private

- (IBAction)actionReverseTwitterAuth:(UIButton *)sender {
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self AlertErrorMessage:@"Please enable access to Twitter in Settings → Privacy."];
            });
        }
        else {
            NSArray *accounts = [store accountsWithAccountType:accountType];
            if (accounts.count==0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self AlertErrorMessage:@"Please add a Twitter account in Settings → Twitter."];
                });
            }
            else {
                if (accounts.count==1) {
                    [self twitterLoginWithAccount:accounts.firstObject];
                    return ;
                }
                
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                [accounts enumerateObjectsUsingBlock:^(ACAccount * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIAlertAction *twitter = [UIAlertAction actionWithTitle:obj.username style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self twitterLoginWithAccount:obj];
                    }];
                    [controller addAction:twitter];
                }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                [controller addAction:cancel];
                
                controller.popoverPresentationController.sourceView = self.view;
                controller.popoverPresentationController.sourceRect = sender.frame;
                controller.popoverPresentationController.permittedArrowDirections = 0;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:controller animated:YES completion:nil];
                });
            }
        }
    }];
}

- (void)AlertErrorMessage:(NSString *)message {
    [self alertTitle:@"Error" message:message];
}

- (void)alertTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)twitterLoginWithAccount:(ACAccount *)account {
    [[DKTwitterReverseAuth sharedInstance] performReverseAuthForAccount:account withHandler:^(NSDictionary *responseJson, NSError *error) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"There was a problem with Twitter login (reverse auth process error: %@).", error.localizedDescription];
            [self AlertErrorMessage:message];
            return ;
        }
        
        NSString *message = ({
            __block NSString *message = @"";
            [responseJson enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                message = [message stringByAppendingFormat:@"%@: %@\n\n", key, obj];
            }];
            
            message;
        });
        
        [self alertTitle:@"😊" message:message];
        
        NSLog(@"👍🏻 got oauth token: %@", responseJson[tw_key_oauth_token]);
    }];
}

@end
