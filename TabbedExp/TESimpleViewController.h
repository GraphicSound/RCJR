//
//  TESimpleViewController.h
//  TabbedExp
//
//  Created by yu_hao on 10/9/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECommentViewController.h"

@interface TESimpleViewController : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *mainTitle;
@property (nonatomic, strong) NSData *htmlData;
@property (nonatomic, strong) NSString *currentID;

@property (nonatomic, strong) NSMutableArray *cArray;
@property (nonatomic, strong) NSMutableArray *cAuthorArray;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
