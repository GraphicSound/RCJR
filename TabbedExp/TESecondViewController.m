//
//  TESecondViewController.m
//  TabbedExp
//
//  Created by yu_hao on 10/8/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import "TESecondViewController.h"

@interface TESecondViewController ()

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestPosts [NSURL URLWithString:@"http://118.228.173.165/love/?json=get_category_posts&slug=news"] //2

@end

@implementation TESecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    pCount = 0;
    self.title = @"最新扰闻";//为什么不是self.navigationController.title？
    self.navigationController.tabBarItem.title = @"最新扰闻";
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 90)];
//    footer.backgroundColor = [UIColor clearColor];
//    self.tableView.tableFooterView = footer;
    
    float currentVersion = 7.0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg_2_long"]];
    } else
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg_2"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TECustomizeCell *cell = (TECustomizeCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TECustomizeCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TECustomizeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = indexPath.row % 2
    ? [UIColor colorWithRed: 0.98 green: 0.98 blue: 0.98 alpha: 0.7]
    : [UIColor whiteColor];
    cell.nameLabel.text = [pTitleArray objectAtIndex:indexPath.row];
    if ([pThumbnailArray objectAtIndex:indexPath.row] == nil) {
        NSLog(@"图片有问题");
    } else
    {
        cell.thumbnailImageView.image = [pThumbnailArray objectAtIndex:indexPath.row];
    }
    //cell.thumbnailImageView.image = [UIImage imageNamed:@"logo"];
    cell.prepTimeLabel.text = [pEntryArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return pCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tv
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     TESimpleViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SimpleViewController"];
     destViewController.mainTitle = [pTitleArray objectAtIndex:indexPath.row];
     destViewController.image = [pThumbnailArray objectAtIndex:indexPath.row];
     destViewController.text = [pContentArray objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:destViewController animated:YES];
     */
    [tv deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          options:kNilOptions
                          error:&error];
    pCount = [[json objectForKey:@"count"] integerValue];
    NSArray* latestPosts = [json objectForKey:@"posts"]; //2
    pTitleArray = [[NSMutableArray alloc] init];
    pContentArray = [[NSMutableArray alloc] init];
    pThumbnailArray = [[NSMutableArray alloc] init];
    pEntryArray = [[NSMutableArray alloc] init];
    pIDArray = [[NSMutableArray alloc] init];
    cArrayAll = [[NSMutableArray alloc] init];
    cAuthorArrayAll = [[NSMutableArray alloc] init];
    
    for (int i=0; i<latestPosts.count; i++) {
        UIImage *oneImage = [UIImage imageNamed:@"logo"];
        NSString *oneTitle = [[latestPosts objectAtIndex:i] objectForKey:@"title"];
        [pTitleArray addObject:oneTitle];
        //NSMutableString *oneContent = [[latestPosts objectAtIndex:i] objectForKey:@"content"];
        //[pContentArray addObject:oneContent];
        NSString *excerpt = [[latestPosts objectAtIndex:i] objectForKey:@"excerpt"];
        NSMutableString *mutableExcerpt = [[NSMutableString alloc] initWithString:excerpt];
        [mutableExcerpt deleteCharactersInRange:NSMakeRange(0, 3)];
        NSString *finalExcerpt = [mutableExcerpt substringToIndex:mutableExcerpt.length - 5];//为什么第二次用deleteCharactersInRange老是崩溃，狗日的字符串真难处理！
        [pEntryArray addObject:finalExcerpt];
        NSString *oneContent = [[latestPosts objectAtIndex:i] objectForKey:@"content"];
        [pContentArray addObject:oneContent];
        NSString *oneID = [[latestPosts objectAtIndex:i] objectForKey:@"id"];
        [pIDArray addObject:oneID];
        
        /*
         NSArray *attach = [[latestPosts objectAtIndex:i] objectForKey:@"attachments"];
         if ([attach count] != 0) {
         NSDictionary *attachDic = [attach objectAtIndex:0];
         NSString *oneURLString = [attachDic objectForKey:@"url"];
         NSLog(@"%@", oneURLString);
         NSURL *oneURL = [NSURL URLWithString:oneURLString];
         NSError* error = nil;
         NSData *oneImageData = [NSData dataWithContentsOfURL:oneURL options:NSDataReadingUncached error:&error];
         if (error) {
         NSLog(@"%@", [error localizedDescription]);
         } else {
         NSLog(@"Data has loaded successfully.");
         }
         oneImage = [[UIImage alloc] initWithData:oneImageData];
         }
         */
        //if ([oneContent hasPrefix:@"http"]) {
        //NSLog(@"string contains substring!");
        //}
        
        //以下主要是获得图片的url
        NSString *string1 = @"applicationimage";
        if ([oneContent rangeOfString:string1].location == NSNotFound) {
            NSLog(@"没有在网页中找到episode对应的图片");
        } else {
            NSLog(@"发现图片，并开始提取url");
            NSRange range1 = [oneContent rangeOfString:string1];
            //NSLog(@"%i", range.location);
            NSString *urlString1 = [oneContent substringToIndex:range1.location+20];
            NSLog(@"%@", urlString1);
            
            NSString *string2 = @"http://118.228.173.165/love/";
            NSRange range2 = [oneContent rangeOfString:string2];
            NSString *urlString2 = [urlString1 substringFromIndex:range2.location];
            NSLog(@"%@", urlString2);
            
            NSURL *oneURL = [NSURL URLWithString:urlString2];
            NSError* error = nil;
            NSData *oneImageData = [NSData dataWithContentsOfURL:oneURL options:NSDataReadingUncached error:&error];
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                NSLog(@"成功接收图片数据！");
            }
            oneImage = [[UIImage alloc] initWithData:oneImageData];
        }
        [pThumbnailArray addObject:oneImage];
        
        NSMutableArray *cArray = [[NSMutableArray alloc] init];
        NSMutableArray* cAuthorArray = [[NSMutableArray alloc] init];
        NSArray *pComments = [[latestPosts objectAtIndex:i] objectForKey:@"comments"];
        for (int i=0; i<pComments.count; i++)
        {
            NSString *oneComment = [[pComments objectAtIndex:i] objectForKey:@"content"];
            [cArray addObject:oneComment];
            NSString *oneAuthor = [[pComments objectAtIndex:i] objectForKey:@"name"];
            [cAuthorArray addObject:oneAuthor];
        }
        [cArrayAll addObject:cArray];
        [cAuthorArrayAll addObject:cAuthorArray];
    }
    [self.tableView reloadData];
}

- (IBAction)refresh:(id)sender {
    //开始向服务器查询json
    dispatch_async(kBgQueue, ^{
        NSError* error = nil;
        NSData* data = [NSData dataWithContentsOfURL:kLatestPosts
                                             options:NSDataReadingUncached
                                               error:&error];//居然能如此简单！！！
        if (error) {
            [self performSelectorOnMainThread:@selector(showAlert)
                                   withObject:nil
                                waitUntilDone:YES];
        } else
        {
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:data
                                waitUntilDone:YES];
        }
    });
}

- (void)showAlert
{
    NSLog(@"服务器出现故障");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"蛋疼啊！" message:@"未连接校园网或者服务器出问题了" delegate:nil cancelButtonTitle:@"我能理解" otherButtonTitles:nil];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TESimpleViewController"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TESimpleViewController *destViewController = segue.destinationViewController;
        destViewController.mainTitle = [pTitleArray objectAtIndex:indexPath.row];
        destViewController.image = [pThumbnailArray objectAtIndex:indexPath.row];
        destViewController.text = [pContentArray objectAtIndex:indexPath.row];
        destViewController.currentID = [pIDArray objectAtIndex:indexPath.row];
        destViewController.cArray = [cArrayAll objectAtIndex:indexPath.row];
        destViewController.cAuthorArray = [cAuthorArrayAll objectAtIndex:indexPath.row];
        
        NSMutableString* htmlContent = [NSMutableString stringWithString:@"<html><head><title></title></head><body></body></html>"];
        //<img src='logo.png' />可以利用本地文件
        NSRange range = [htmlContent rangeOfString:@"<body>"];
        [htmlContent insertString:[pContentArray objectAtIndex:indexPath.row] atIndex:range.location+6];
        NSData *data = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
        destViewController.htmlData = data;
    }
}

@end
