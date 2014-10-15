//
//  QuestionViewController.m
//  QuickWorld
//
//  Created by Eralp Karaduman on 16/10/14.
//  Copyright (c) 2014 eralpkaraduman. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionRotatorViewController.h"

@interface QuestionViewController ()
@property IBOutlet UILabel *answerLeft;
@property IBOutlet UILabel *answerRight;
@property IBOutlet UILabel *questionLabel;
@property IBOutlet NSLayoutConstraint *paneHorizontalCenter;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.answerLeft.text = self.question.answers.firstObject;
    self.answerRight.text = self.question.answers.lastObject;
    self.questionLabel.text = self.question.question;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onTapLeftButton:(id)sender{
    [self checkIndex:0];
}

-(IBAction)onTapRightButton:(id)sender{
    [self checkIndex:1];
}

-(void)checkIndex:(NSInteger)index{
    
    BOOL correct = index == self.question.correctIndex;
    
    QuestionRotatorViewController *rotator = (QuestionRotatorViewController*)self.parentViewController;
    [rotator questionViewController:self completedWithCorrectAnswer:correct];
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
