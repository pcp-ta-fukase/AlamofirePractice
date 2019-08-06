//
//  ViewControllerObjectiveC.m
//  alamofirePractice
//
//  Created by ta_fukase on 2019/08/06.
//  Copyright © 2019 ta_fukase. All rights reserved.
//

#import <SafariServices/SafariServices.h>

#import "ViewControllerObjectiveC.h"
#import "alamofirePractice-Swift.h"

@interface ViewControllerObjectiveC ()<SFSafariViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *qiitaTitleLabel;

- (IBAction)onTapSafari:(id)sender;
@end

@implementation ViewControllerObjectiveC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [APIProvider setLatestQiitaTitleOn:_qiitaTitleLabel];
}


- (IBAction)onTapSafari:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://nlogic.jp"];
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:url];
    safari.delegate = self;
    [self presentViewController:safari animated:YES completion:^{
        NSLog(@"presentViewController completion");
    }];
}
@end
