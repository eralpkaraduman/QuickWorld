//
//  QuestionViewController.m
//  QuickWorld
//
//  Created by Eralp Karaduman on 16/10/14.
//  Copyright (c) 2014 eralpkaraduman. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionRotatorViewController.h"
#import "UIImage+Color.h"

@interface QuestionViewController (){
    BOOL completed;
}
@property IBOutlet UILabel *answerLeft;
@property IBOutlet UILabel *answerRight;
@property IBOutlet UILabel *questionLabel;
@property IBOutlet NSLayoutConstraint *paneHorizontalCenter;

@property IBOutlet UIButton *leftButton;
@property IBOutlet UIButton *rightButton;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.answerLeft.text = self.question.answers.firstObject;
    self.answerRight.text = self.question.answers.lastObject;
    self.questionLabel.text = self.question.question;
    
    UIColor *selectedColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    
    [self.leftButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    
    [self.leftButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    
    [self.leftButton setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:UIControlStateHighlighted];
    
    [self.leftButton setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:UIControlStateSelected];
    
    [self.rightButton setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:UIControlStateHighlighted];
    
    [self.rightButton setBackgroundImage:[UIImage imageWithColor:selectedColor] forState:UIControlStateSelected];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onTapLeftButton:(id)sender{
    [self.leftButton setSelected:YES];
    
    [self checkIndex:0];
    
    //
}

-(IBAction)onTapRightButton:(id)sender{
    [self.rightButton setSelected:YES];
    
    
    [self checkIndex:1];
    
    //
}

-(void)checkIndex:(NSInteger)index{
    
    if(completed)return;
    
    self.view.userInteractionEnabled = false;
    
    BOOL correct = index == self.question.correctIndex;
    
    QuestionRotatorViewController *rotator = (QuestionRotatorViewController*)self.parentViewController;
    [rotator questionViewController:self completedWithCorrectAnswer:correct];
    
    completed = true;
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
