//
//  ChatViewController.m
//  Parse-Chat
//
//  Created by Kristie Huang on 7/6/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *chatMessageTextField;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (nonatomic, strong) NSArray * posts;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshOnTimer) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}
- (IBAction)sendButtonTapped:(id)sender {
    PFObject *chatMsg = [PFObject objectWithClassName:@"Message_fbu2020"];
    chatMsg[@"text"] = self.chatMessageTextField.text;
    chatMsg[@"user"] = PFUser.currentUser;
    [chatMsg saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"hell ya");
            self.chatMessageTextField.text = @"";
        }
    }];
}

-(void)refreshOnTimer {
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2020"];
//    [query whereKey:@"likesCount" greaterThan:@100]
    query.limit = 50;
//    [query includeKey:@"text"];
    
    [query includeKeys:[NSArray arrayWithObjects:@"text", @"user", nil]];
    [query orderByDescending:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray * posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = posts;
            [self.chatTableView reloadData];
        } else {
            NSLog(@"oopsies");
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [self.chatTableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    NSDictionary *chatMsg = self.posts[indexPath.row];
    PFUser *user = chatMsg[@"user"];
    if (user != nil) {
        cell.usernameLabel.text = user.username;
    } else {
        cell.usernameLabel.text = @"Default username";
    }
    cell.chatTextLabel.text = chatMsg[@"text"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
