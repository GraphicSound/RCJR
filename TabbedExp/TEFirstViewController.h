//
//  TEFirstViewController.h
//  TabbedExp
//
//  Created by yu_hao on 10/8/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESimpleViewController.h"
#import "TECustomizeCell.h"
#import "Reachability.h"

@interface TEFirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    int pCount;
    NSMutableArray *pTitleArray;
    NSMutableArray *pThumbnailArray;
    NSMutableArray *pContentArray;
    NSMutableArray *pEntryArray;
    NSMutableArray *pIDArray;
    
    NSMutableArray *cArrayAll;
    //NSMutableArray *cArray;
    NSMutableArray *cAuthorArrayAll;
    //NSMutableArray *cAuthorArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)refresh:(id)sender;

- (NSString *)stringFromStatus:(NetworkStatus) status;

@end
