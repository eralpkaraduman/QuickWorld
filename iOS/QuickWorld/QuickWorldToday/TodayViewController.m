//
//  TodayViewController.m
//  QuickWorldToday
//
//  Created by Eralp Karaduman on 15/10/14.
//  Copyright (c) 2014 eralpkaraduman. All rights reserved.
//

#import "TodayViewController.h"
#import "QuestionRotatorViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property QuestionRotatorViewController *rotatorVC;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    self.preferredContentSize = CGSizeMake(320,100);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.preferredContentSize = CGSizeMake(320,100);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"embedRotator"]){
        self.rotatorVC = segue.destinationViewController;
        [self.rotatorVC reload];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {

    if(self.rotatorVC){
        [self.rotatorVC reload];
    }
    
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
