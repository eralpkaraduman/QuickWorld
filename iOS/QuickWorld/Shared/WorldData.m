//
//  WorldData.m
//  QuickWorld
//
//  Created by Eralp Karaduman on 15/10/14.
//  Copyright (c) 2014 eralpkaraduman. All rights reserved.
//

#import "WorldData.h"
#import <NSMutableArray+Shuffle.h>


@implementation WorldData

+(void)capitalsWithCompletionBlock:(void (^)(Question *question))block{
    
    [WorldData countriesWithBlock:^(NSArray *countries) {
        
        NSDictionary *pair = [WorldData randomCountryPairFromCountries:countries];
        if(pair){
            NSInteger correctIndex = [[pair objectForKey:@"correctIndex"] integerValue];
            NSArray *countries = [pair objectForKey:@"countries"];
            NSDictionary *correctCountry = [countries objectAtIndex:correctIndex];
            
            Question *q = [[Question alloc] init];
            q.question = [NSString stringWithFormat:@"Capital of %@?",[correctCountry valueForKeyPath:@"name.common"]];
            NSMutableArray *m_answers = [NSMutableArray array];
            for(NSDictionary *country in countries){
                NSString *capital = [country valueForKey:@"capital"];
                if(capital.length<=1){
                    capital = @"N/A";
                }
                [m_answers addObject:capital];
            }
            q.answers = [NSArray arrayWithArray:m_answers];
            q.correctIndex = correctIndex;
            
            if(block)block(q);
            
        }else{
            
            if(block)block(nil);
        }
        
    }];
    
}

+(NSDictionary*)randomCountryPairFromCountries:(NSArray*)countries{
    
    if(countries == nil)return nil;
    if(countries.count < 2)return nil;
    
    NSMutableArray *shuffledArray = [NSMutableArray arrayWithArray:countries];
    [shuffledArray shuffle];

    
    NSMutableArray *m_countries = [NSMutableArray array];
    
    NSInteger pickIndex = roundf(((float)rand() / RAND_MAX) * shuffledArray.count);
    
    while (m_countries.count<2) {
        [m_countries addObject:[shuffledArray objectAtIndex:pickIndex]];
        pickIndex++;
        if(pickIndex>=shuffledArray.count)pickIndex=0;
    }
    
    NSInteger correct = roundf(((float)rand() / RAND_MAX));
    
    return @{@"countries":[NSArray arrayWithArray:m_countries],
             @"correctIndex":@(correct)};
}



+(void)countriesWithBlock:(void (^)(NSArray *countries))block{
    
    __block NSArray *countries = [[NSUserDefaults standardUserDefaults] objectForKey:@"WorldData"];
    if(countries){
        if(block)block(countries);
    }else{
        [WorldData loadWorldDataWithCompletionBlock:^(NSError *error) {
            
            countries = [[NSUserDefaults standardUserDefaults] objectForKey:@"WorldData"];
            
            if(countries == nil)countries = [NSArray array];
            if(block)block(countries);
        }];
    }
    
}


+(AFHTTPRequestOperation*)loadWorldDataWithCompletionBlock:(void (^)(NSError *error))block{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    return [manager GET:@"https://raw.githubusercontent.com/eralpkaraduman/countries/master/countries.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"WorldData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if(block)block(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(block)block(error);
    }];
    
}

@end

@implementation Question
@end
