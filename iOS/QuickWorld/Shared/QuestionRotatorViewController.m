//
//  QuestionRotatorViewController.m
//  QuickWorld
//
//  Created by Eralp Karaduman on 16/10/14.
//  Copyright (c) 2014 eralpkaraduman. All rights reserved.
//

#import "QuestionRotatorViewController.h"
#import "WorldData.h"

#define INSTANTIATE_MAIN(viewController) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:viewController]

#define STORYBOARD_NAME     [[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"]
#define INSTANTIATE(viewController)     [[UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil] instantiateViewControllerWithIdentifier:viewController]

@interface QuestionRotatorViewController ()
@property QuestionViewController *currentQuestionVC;
@property UIActivityIndicatorView *spinner;
@end

@implementation QuestionRotatorViewController



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self reload];

}

-(void)reload{
    
    [self.view setClipsToBounds:YES];
    
    if(self.spinner==nil){
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //self.spinner.center = self.view.center;
        
        [self.spinner setUserInteractionEnabled:NO];
        
        [self.view addSubview:self.spinner];
        [self.spinner setHidesWhenStopped:YES];
    }
    self.spinner.frame = self.view.bounds;
    
    [self.spinner startAnimating];
    
    
    Question *lastQuestion = [WorldData lastQuestion];
    if(lastQuestion){
        [self animateToQuestion:lastQuestion];
    }else{
        [self nextQuestion];
    }
    
    //[self nextQuestion];
}

-(void)nextQuestion{
    
    
    
    [WorldData capitalsWithCompletionBlock:^(Question *question) {
        
        if(question){
            
            [self.spinner stopAnimating];
            
            
            [WorldData saveLastQuestion:question];
            
            [self animateToQuestion:question];
            
            
            
        }
    }];
    
}

-(void)animateToQuestion:(Question*)question{
    
    [self.spinner stopAnimating];
    
    QuestionViewController *questionVC = INSTANTIATE_MAIN(@"QuestionViewController");
    questionVC.question = question;
    
    if([self.currentQuestionVC.question.question isEqualToString:question.question]){
        [self.currentQuestionVC removeFromParentViewController];
        [self.currentQuestionVC.view removeFromSuperview];
        [self.currentQuestionVC endAppearanceTransition];
        self.currentQuestionVC = nil;
    }
    
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
        [UIView animateWithDuration:0.25 animations:^{
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
         
         CGRect initRect = self.view.bounds;
         //initRect.origin.y = -initRect.size.height;
         
         CGRect endRect = self.view.bounds;
         //endRect.origin.y = +initRect.size.height;
         
         questionVC.view.frame = initRect;
         
         [questionVC beginAppearanceTransition:YES animated:NO];
         [self.view addSubview:questionVC.view];
         [self addChildViewController:questionVC];
         
         [self.currentQuestionVC beginAppearanceTransition:NO animated:YES];
         [UIView animateWithDuration:0.25 animations:^{
         //[self.currentQuestionVC.view setFrame:endRect];
         //[questionVC.view setFrame:self.view.bounds];
         
         } completion:^(BOOL finished) {
         [self.currentQuestionVC removeFromParentViewController];
         [self.currentQuestionVC.view removeFromSuperview];
         [self.currentQuestionVC endAppearanceTransition];
         self.currentQuestionVC = nil;
         
         self.currentQuestionVC = questionVC;
         }];
         
         */
        
        
    }else{
        [questionVC beginAppearanceTransition:YES animated:NO];
        questionVC.view.frame = self.view.bounds;
        [self.view addSubview:questionVC.view];
        [self addChildViewController:questionVC];
        [questionVC endAppearanceTransition];
        
        self.currentQuestionVC = questionVC;
    }
    
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
