//
//  TECommentViewController.h
//  TabbedExp
//
//  Created by yu_hao on 10/18/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECustomizeCell2.h"
//#include <sys/sysctl.h>
#import <sys/utsname.h>//用于获得设备型号

@interface TECommentViewController : UIViewController <UITextFieldDelegate>
{
    CGRect originalViewFrame;
}

@property (nonatomic, strong) NSString *currentID;
@property (nonatomic, strong) NSMutableArray *cArray;
@property (nonatomic, strong) NSMutableArray *cAuthorArray;
@property (nonatomic, strong) NSString *oneComment;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

- (NSString *)getModel;

@end
