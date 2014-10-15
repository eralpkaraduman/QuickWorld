//
//  QuestionRotatorViewController.m
//  QuickWorld
//
//  Created by Eralp Karaduman on 16/10/14.
//  Copyright (c) 2014 eralpkaraduman. All rights reserved.
//

#import "QuestionRotatorViewController.h"
#import "WorldData.h"


#define STORYBOARD_NAME     [[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"]
#define INSTANTIATE(viewController)     [[UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil] instantiateViewControllerWithIdentifier:viewController]

@interface QuestionRotatorViewController ()
@property QuestionViewController *currentQuestionVC;
@end

@implementation QuestionRotatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self nextQuestion];
    
    // Do any additional setup after loading the view.
}

-(void)nextQuestion{
    
    [WorldData capitalsWithCompletionBlock:^(Question *question) {
        if(question){
            
            QuestionViewController *questionVC = INSTANTIATE(@"QuestionViewController");
            questionVC.question = question;
            
            
            if(self.currentQuestionVC){
                
                CGRect initRect = self.view.bounds;
                initRect.origin.y = -initRect.size.height;
                
                CGRect endRect = self.view.bounds;
                endRect.origin.y = +initRect.size.height;
                
                questionVC.view.frame = initRect;
                [questionVC beginAppearanceTransition:YES animated:NO];
                [self.view addSubview:questionVC.view];
                [self addChildViewController:questionVC];
                
                [self.currentQuestionVC beginAppearanceTransition:NO animated:YES];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.currentQuestionVC.view setFrame:endRect];
                    [questionVC.view setFrame:self.view.bounds];
                    
                } completion:^(BOOL finished) {
                    [self.currentQuestionVC removeFromParentViewController];
                    [self.currentQuestionVC.view removeFromSuperview];
                    [self.currentQuestionVC endAppearanceTransition];
                    self.currentQuestionVC = nil;
                    
                    self.currentQuestionVC = questionVC;
                }];
                
                /*
                [UIView transitionFromView:self.currentQuestionVC.view toView:questionVC.view duration:0.5 options:UIViewAnimationOptionTransitionNone completion:^(BOOL finished) {
                    self.currentQuestionVC = questionVC;
                }];
                */
                

                
            }else{
                QuestionViewController *questionVC = INSTANTIATE(@"QuestionViewController");
                questionVC.question = question;
                [questionVC beginAppearanceTransition:YES animated:NO];
                questionVC.view.frame = self.view.bounds;
                [self.view addSubview:questionVC.view];
                [self addChildViewController:questionVC];
                [questionVC endAppearanceTransition];
                
                self.currentQuestionVC = questionVC;
            }
            
            
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)questionViewController:(QuestionViewController*)questionViewController completedWithCorrectAnswer:(BOOL)correct{
    [self nextQuestion];
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
