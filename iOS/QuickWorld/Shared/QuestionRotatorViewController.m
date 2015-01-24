//
//  QuestionRotatorViewController.m
//  QuickWorld
//
//  Created by Eralp Karaduman on 16/10/14.
//  Copyright (c) 2014 eralpkaraduman. All rights reserved.
//

#import "QuestionRotatorViewController.h"
#import "WorldData.h"
#import <UIImage+GIF.h>
#include <AudioToolbox/AudioToolbox.h>

#define INSTANTIATE_MAIN(viewController) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:viewController]

#define STORYBOARD_NAME     [[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"]
#define INSTANTIATE(viewController)     [[UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil] instantiateViewControllerWithIdentifier:viewController]

static NSArray *success_gifs;
static NSArray *fail_gifs;

@interface QuestionRotatorViewController (){
    UIImageView *iv_bg;
    UIImageView *iv;
    UITapGestureRecognizer *tapGesture;
    NSUInteger lastIndex_success;
    NSUInteger lastIndex_fail;
    
    SystemSoundID successSound;
    SystemSoundID failSound;
    
    UILabel *scoreView;
}
@property QuestionViewController *currentQuestionVC;
@property (strong, nonatomic) IBOutlet UIView *resultContainer;
@property UIActivityIndicatorView *spinner;
@end

@implementation QuestionRotatorViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *successSoundPath = [[NSBundle mainBundle]
                            pathForResource:@"success" ofType:@"mp3"];
    NSURL *successSoundURL = [NSURL fileURLWithPath:successSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)successSoundURL, &successSound);
    
    NSString *failSoundPath = [[NSBundle mainBundle]
                                  pathForResource:@"fail" ofType:@"mp3"];
    NSURL *failSoundURL = [NSURL fileURLWithPath:failSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)failSoundURL, &failSound);
    
    if(scoreView==nil){
        CGRect scoreViewRect = self.view.bounds;
        scoreViewRect.size.height = 20.0f;
        scoreViewRect.origin.x = 6.0f;
        
        scoreView = [[UILabel alloc] initWithFrame:scoreViewRect];
        [scoreView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [scoreView setFont:[UIFont systemFontOfSize:12]];
        [scoreView setUserInteractionEnabled:NO];
        
        [self.view addSubview:scoreView];
    }
    
    [self updateScore];
    
    [self reload];

}

-(void)updateScore{
    
    NSNumber *score = [self getScore];
    [scoreView setText:[NSString stringWithFormat:@"Score : %@",score]];
    [scoreView setTextColor:[UIColor greenColor]];
    [self.view addSubview:scoreView];
    
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
    
    [self updateScore];
}

-(NSNumber*)getScore{
    
    NSNumber *score;
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.eralpkaraduman.QuickWorld"];
    score = [sharedDefaults objectForKey:@"SCORE"];
    
    if(score == nil) score = [NSNumber numberWithInt:0];
    
    return score;
}

-(void)increaseScore{
    NSNumber *score = [self getScore];
    score = @(score.integerValue + 1);
    [self setScore:score];
    
    [self updateScore];
}

-(void)setScore:(NSNumber*)score{
    
    if(score==nil)score = [NSNumber numberWithInt:0];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.eralpkaraduman.QuickWorld"];
    [sharedDefaults setObject:score forKey:@"SCORE"];
    [sharedDefaults synchronize];
    
}

-(void)resetScore{
    
    NSNumber *score = [NSNumber numberWithInt:0];
    [self setScore:score];
    
    [self updateScore];
    
}

-(void)nextQuestion{
    
    
    
    [WorldData capitalsWithCompletionBlock:^(Question *question) {
        
        if(question){
            
            [self.spinner stopAnimating];
            
            
            [WorldData saveLastQuestion:question];
            
            [self animateToQuestion:question];
            
            
            
        }
    }];
    
    [self updateScore];
    
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

-(void)showResultCorrect:(BOOL)correct question:(Question*)question withCompletionBlock:(void (^)())block{
    
    if(correct)[self increaseScore]; else [self resetScore];
                                           
    
    AudioServicesPlaySystemSound(correct?successSound:failSound);
    
    iv.alpha = 0;
    iv_bg.alpha = 0;
    
    [self setGif:[self getGifForSuccess:correct]];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [self.currentQuestionVC.view setAlpha:0];
        iv.alpha = 1;
        iv_bg.alpha = 1;
        
    } completion:^(BOOL finished) {

        if(block)block();
        
    }];
}

-(UIImage*)getGifForSuccess:(BOOL)success{
    /*
    if(success_gifs==nil){
        success_gifs = @[[UIImage sd_animatedGIFNamed:@"success_001"],
                         [UIImage sd_animatedGIFNamed:@"success_002"],
                         [UIImage sd_animatedGIFNamed:@"success_003"],
                         [UIImage sd_animatedGIFNamed:@"success_004"],
                         [UIImage sd_animatedGIFNamed:@"success_005"],
                         [UIImage sd_animatedGIFNamed:@"success_006"],
                         [UIImage sd_animatedGIFNamed:@"success_007"],
                         [UIImage sd_animatedGIFNamed:@"success_008"],
                         [UIImage sd_animatedGIFNamed:@"success_009"],
                         [UIImage sd_animatedGIFNamed:@"success_010"],
                         [UIImage sd_animatedGIFNamed:@"success_011"]
                         ];
    }
    
    if(fail_gifs==nil){
        fail_gifs = @[[UIImage sd_animatedGIFNamed:@"fail_001"],
                      [UIImage sd_animatedGIFNamed:@"fail_002"],
                      [UIImage sd_animatedGIFNamed:@"fail_003"],
                      [UIImage sd_animatedGIFNamed:@"fail_004"],
                      [UIImage sd_animatedGIFNamed:@"fail_005"],
                      [UIImage sd_animatedGIFNamed:@"fail_006"],
                      [UIImage sd_animatedGIFNamed:@"fail_007"],
                      [UIImage sd_animatedGIFNamed:@"fail_008"]];
    }
    */
    
    if(success_gifs==nil){
        success_gifs = @[//@"success_001",
                         //@"success_002",
                         @"success_003",
                         @"success_004",
                         //@"success_005",
                         //@"success_006",
                         //@"success_007",
                         //@"success_008",
                         @"success_009",
                         //@"success_010",
                         @"success_011"
                         ];
    }
    
    if(fail_gifs==nil){
        fail_gifs = @[@"fail_001",
                      @"fail_002",
                      //@"fail_003",
                      //@"fail_004",
                      @"fail_005",
                      @"fail_006",
                      //@"fail_007",
                      @"fail_008"];
    }
    
    NSUInteger lastIndex = success?lastIndex_success:lastIndex_fail;
    NSArray* gifList = success?success_gifs:fail_gifs;
    

    
    NSUInteger randomIndex = arc4random() % [gifList count];
    while (randomIndex==lastIndex) {
        randomIndex = arc4random() % [gifList count];
    }
    

    
    if(success)lastIndex_success = randomIndex;
    else lastIndex_fail = randomIndex;

    NSString *name = gifList[randomIndex];
    
    NSLog(@"name %@",name);
    
    return [UIImage sd_animatedGIFNamed:name];
    
}

-(void)setGif:(UIImage*)gifImage{
    
    
    if(iv_bg==nil){
        iv_bg = [[UIImageView alloc] initWithImage:gifImage];
        iv_bg.contentMode = UIViewContentModeScaleAspectFill;
        iv_bg.frame = self.view.frame;
    }else{
        [iv_bg setImage:gifImage];
    }
    [self.view addSubview:iv_bg];
    
    if(iv==nil){
        iv = [[UIImageView alloc] initWithImage:gifImage];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.frame = self.view.frame;
    }else{
        [iv setImage:gifImage];
    }
    [self.view addSubview:iv];
    
}

-(void)questionViewController:(QuestionViewController*)questionViewController completedWithCorrectAnswer:(BOOL)correct{
    
    if(tapGesture == nil){
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapEverything)];
    }
    
    [self showResultCorrect:correct question:questionViewController.question withCompletionBlock:^{
        
        [self.view addGestureRecognizer:tapGesture];
        
        
        //[self nextQuestion];
    }];
    
    
}

-(void)onTapEverything{
    
    [self.view removeGestureRecognizer:tapGesture];
    
    [self nextQuestion];
    
    [UIView animateWithDuration:0.3 animations:^{
        iv.alpha = iv_bg.alpha = 0;
    } completion:^(BOOL finished) {
        [iv setImage:nil];
        [iv_bg setImage:nil];
    }];
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
