//
//  ViewController.m
//  QuickWorld
//
//  Created by Eralp Karaduman on 15/10/14.
//  Copyright (c) 2014 eralpkaraduman. All rights reserved.
//

#import "ViewController.h"
#import "WorldData.h"

@interface ViewController () <UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self showAlert];
}

- (IBAction)onTapSDG:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://superdamage.com?ref=quickworld"];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (IBAction)onTapTitle:(id)sender {
    [self showAlert];
}

-(void)showAlert{
    
    //
    
    [[[UIAlertView alloc] initWithTitle:@"ACHIEVEMENT UNLOCKED!" message:@"You downloaded the app! Awesome! Thanks! You won A FREE WIDGET. You can install your widget right now. If you don't know how, just tap \"Learn How\" below." delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:@"Learn How", nil] show];
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        NSURL *url = [NSURL URLWithString:@"http://www.youtube.com/watch?v=gxi0WsBJfcE"];
        if([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
