//
//  TESimpleViewController.m
//  TabbedExp
//
//  Created by yu_hao on 10/9/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import "TESimpleViewController.h"

@interface TESimpleViewController ()

@end

@implementation TESimpleViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cArray = [[NSMutableArray alloc] init];
        self.cAuthorArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = self.mainTitle;
    [self.webView loadData:self.htmlData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TECommentViewController"]) {
        TECommentViewController *destViewController = segue.destinationViewController;
        destViewController.currentID = self.currentID;
        destViewController.cArray = self.cArray;
        destViewController.cAuthorArray = self.cAuthorArray;
    }
}

@end
