//
//  feedback.m
//  TabbedExp
//
//  Created by yu_hao on 10/19/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import "feedback.h"

@interface feedback ()

@end

@implementation feedback

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];//为什么这个能在子窗口调用呢，明明就是之前的controller触发的presentViewController或者使用segue modal的啊
}
@end
