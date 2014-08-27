//
//  TEThirdViewController.m
//  TabbedExp
//
//  Created by yu_hao on 10/8/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import "TEThirdViewController.h"

@interface TEThirdViewController ()

@end

@implementation TEThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"投稿报名";//为什么不是self.navigationController.title？
    self.navigationController.tabBarItem.title = @"投稿报名";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
