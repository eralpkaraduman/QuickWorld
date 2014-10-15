//
//  QuestionRotatorViewController.h
//  QuickWorld
//
//  Created by Eralp Karaduman on 16/10/14.
//  Copyright (c) 2014 eralpkaraduman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionViewController.h"

@interface QuestionRotatorViewController : UIViewController
-(void)questionViewController:(QuestionViewController*)questionViewController completedWithCorrectAnswer:(BOOL)correct;
@end
