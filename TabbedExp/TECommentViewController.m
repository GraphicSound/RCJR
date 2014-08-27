//
//  TECommentViewController.m
//  TabbedExp
//
//  Created by yu_hao on 10/18/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import "TECommentViewController.h"

@interface TECommentViewController ()

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@end

@implementation TECommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cArray = [[NSMutableArray alloc] init];
        self.cAuthorArray = [[NSMutableArray alloc] init];
        //self.tabBarController.tabBar.hidden = YES;//不起作用呢
        //http://118.228.173.165/love/?json=respond.submit_comment&post_id=83&name=me&email=163@163.com&content=again/
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"评论";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TECustomizeCell2 *cell = (TECustomizeCell2 *)[self.tableView dequeueReusableCellWithIdentifier:@"TECustomizeCell2"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TECustomizeCell2" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.comment.text = [self.cArray objectAtIndex:([self.cArray count]-1-indexPath.row)];
    cell.name.text = [NSString stringWithFormat:@"%@: ", [self.cAuthorArray objectAtIndex:([self.cAuthorArray count]-1-indexPath.row)]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [self.cArray count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 78;
//}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tv
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.commentTextField isFirstResponder]) {
        [self.commentTextField resignFirstResponder];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's
    // coordinate system. The bottom of the text view's frame should align with the top
    // of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    originalViewFrame = self.view.bounds;//保存view的大小
    CGRect newViewFrame = self.view.bounds;
    newViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect newTextFrame = self.commentTextField.frame;
    newTextFrame = [self.view convertRect:newTextFrame fromView:nil];
    newTextFrame.origin.y = keyboardTop-38;
    
    self.tableView.frame = newViewFrame;
    self.commentTextField.frame = newTextFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSLog(@"键盘将要被隐藏");
    NSDictionary *userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.tableView.frame = self.view.frame;
    [UIView commitAnimations];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length] > 0) {
        self.oneComment = textField.text;
        NSLog(@"%@", self.oneComment);
        NSString *urlString = [NSString stringWithFormat:@"http://118.228.173.165/love/?json=respond.submit_comment&post_id=%@&name=%@&email=user@rcjr.com&content=%@/", self.currentID, [self getModel], textField.text];
        NSLog(@"%@", urlString);
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//很重要！不饶很容易出现URLWithString返回nil的情况
        NSURL *commentURL = [NSURL URLWithString:urlString];
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:commentURL];//居然能如此简单！！！
            if (nil == data) {
                NSLog(@"没有请求成功");
            } else
            {
                NSLog(@"请求成功，开始解析返回值");
                [self performSelectorOnMainThread:@selector(fetchedData:)
                                       withObject:data
                                    waitUntilDone:YES];
            }
        });
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)fetchedData:(NSData *)responseData
{
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          options:kNilOptions
                          error:&error];
    NSString *commentStatus = [json objectForKey:@"status"];
    NSLog(@"发表状态: %@", commentStatus);
    if ([commentStatus isEqualToString:@"ok"]) {
        NSLog(@"评论发表成功");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"若诚就扰-评论" message:@"发表成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        self.commentTextField.text = @" ";
        [self.cAuthorArray addObject:[self getModel]];
        [self.cArray addObject:self.oneComment];
        [self.tableView reloadData];
    }
}

- (NSString *)getModel {
//    size_t size;
//    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//    char *model = malloc(size);
//    sysctlbyname("hw.machine", model, &size, NULL, 0);
//    NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
//    free(model);
//    return deviceModel;
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *sDeviceModel = [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
    
    if ([sDeviceModel isEqual:@"iPhone3,1"]) return @"来自iPhone4"; //iPhone 4 - AT&T
    if ([sDeviceModel isEqual:@"iPhone4,1"]) return @"来自iPhone4S"; //iPhone 4S
    if ([sDeviceModel isEqual:@"iPhone5,1"]) return @"来自iPhone5"; //iPhone 5 (GSM)
    if ([sDeviceModel isEqual:@"iPhone6,1"]) return @"来自iPhone5s";
    if ([sDeviceModel isEqual:@"iPod4,1"])   return @"来自iPod4"; //iPod Touch 4G
    if ([sDeviceModel isEqual:@"iPod5,1"])   return @"来自iPod5";
    if ([sDeviceModel isEqual:@"iPad1,1"])   return @"来自iPad1"; //iPad Wifi
    if ([sDeviceModel isEqual:@"iPad2,1"])   return @"来自iPad2"; //iPad 2 (WiFi)
    if ([sDeviceModel isEqual:@"iPad3,1"])   return @"来自iPad3";
    if ([sDeviceModel isEqual:@"iPad3,4"])   return @"来自iPad4"; //iPad 2 (WiFi)
    else
    return sDeviceModel;
}

@end
