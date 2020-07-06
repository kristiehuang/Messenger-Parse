//
//  ViewController.m
//  Parse-Chat
//
//  Created by Kristie Huang on 7/6/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)signupButtonTapped:(id)sender {
    if ([self.usernameLabel.text isEqualToString:@""] || [self.passwordLabel.text isEqualToString:@""]) {
        NSLog(@"errroor empty text fields");
        UIAlertController *alert = [self createAlertWithTitle:@"Empty text field!" message:@"Please fill in a username and password."];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameLabel.text;
    newUser.password = self.passwordLabel.text;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"uh oh %@", error.localizedDescription);
        } else {
            NSLog(@"yeppy");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];

        }
    }];
    
}
- (IBAction)loginButtonTapped:(id)sender {
    if ([self.usernameLabel.text isEqualToString:@""] || [self.passwordLabel.text isEqualToString:@""]) {
        NSLog(@"errroor empty text fields");
        UIAlertController *alert = [self createAlertWithTitle:@"Empty text field!" message:@"Please fill in a username and password."];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }

    [PFUser logInWithUsernameInBackground:self.usernameLabel.text password:self.passwordLabel.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"uh oh bad login %@", error.localizedDescription);
        } else {
            NSLog(@"yeppy");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (UIAlertController*)createAlertWithTitle:(NSString*) title message:(NSString*) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    return alert;
}

@end
