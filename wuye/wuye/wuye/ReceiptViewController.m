//
//  ReceiptViewController.m
//  wuye
//
//  Created by Chaojun Sun on 14-6-1.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "ReceiptViewController.h"
#import "ServiceMethods.h"
#import "Utilities.h"
#import "GroupCellTableViewCell.h"

#define GROUP_CELL_REUSE_IDENTIFIER @"GROUP_CELL_REUSE_IDENTIFIER"

@interface ReceiptViewController ()

@end

@implementation ReceiptViewController

@synthesize btnNext;
@synthesize txtCell;
@synthesize deliveryNo;
@synthesize groupselector;
@synthesize lblgroup;

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
    groups = [NSMutableArray array];
    NSDictionary *userinfo = [Utilities getUserInfo];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"KeyboardCancel", @"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"KeyboardDone", @"Done") style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtCell.inputAccessoryView = numberToolbar;
    UINib *nib = [UINib nibWithNibName:@"GroupCellTableViewCell" bundle:nil];
    [self.groupselector registerNib:nib forCellReuseIdentifier:GROUP_CELL_REUSE_IDENTIFIER];
    NSString *cellno = [userinfo objectForKey:@"wuyemobile"];
    NSArray *arr = [Utilities getGroups:cellno];
    if (arr!=nil) {
        groups = [NSMutableArray arrayWithArray:arr];
        if ((groups!=nil) && ([groups count]>0)) {
            [self.lblgroup setText:[groups objectAtIndex:0]];
            [self.groupselector reloadData];
            [self.groupselector selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    [[ServiceMethods getInstance] getGroupNames:cellno onSuceess:^(NSArray *groupNames) {
        NSLog(@"groups loaded");
        [groups removeAllObjects];
        [groups addObjectsFromArray:groupNames];
        [Utilities saveGroups:cellno GroupInfo:groupNames];
        //[NSThread sleepForTimeInterval:3];
        [self.groupselector reloadData];
    } onFail:^(NSError *error) {
        NSLog(@"groups failed");
        //[groups removeAllObjects];
        //[self.picker reloadAllComponents];
    }];
}

-(IBAction)selectGroup:(id)sender
{
    [UIView transitionWithView:self.groupselector
                      duration:0.6
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [self.groupselector setHidden:![self.groupselector isHidden]];
}

-(void)cancelNumberPad{
    [self.txtCell resignFirstResponder];
    self.txtCell.text = @"";
}

-(void)doneWithNumberPad{
    [self.txtCell resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)next:(id)sender
{
    NSString *cell = [self.txtCell.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t\r\n"]];
    if (![Utilities isValidCellnumber:cell]) {
        [Utilities showError:@"" Message:@"请输入正确收件人手机号"];
        return;
    }
    NSDictionary *userinfo = [Utilities getUserInfo];
    NSString *fmt = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:[NSLocale systemLocale]];
    NSDateFormatter *fmtr = [[NSDateFormatter alloc] init];
    [fmtr setDateFormat:fmt];
    NSString *groupname = [self.lblgroup text];
    NSDictionary *customer = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:0], @"customerId",
                              cell, @"mobile",
                              @"", @"username",
                              @"1", @"gender",
                              @"", @"province",
                              @"", @"city",
                              @"", @"district",
                              @"", @"campname",
                              @"", @"bldNumber",
                              @"", @"unitNumber",
                              @"", @"roomNumber",
                              @"", @"validationCode",
                              [[UIDevice currentDevice].identifierForVendor UUIDString], @"deviceinfo",
                              @"0", @"type",
                              @"", @"communityId",
                              @"", @"campCode",
                              [fmtr stringFromDate:[NSDate date]], @"validationCodeTime",
                              nil];
    NSDictionary *pacel =[NSDictionary dictionaryWithObjectsAndKeys:
                          @"", @"pacelId",
                          [fmtr stringFromDate:[NSDate date]], @"arrivedData",
                          @"", @"signDate",
                          @"", @"signname",
                          @"", @"customerId",
                          @"", @"province",
                          @"", @"city",
                          @"", @"district",
                          @"", @"campname",
                          @"", @"bldNumber",
                          @"", @"unitNumber",
                          @"", @"roomNumber",
                          @"", @"type",
                          @"", @"communityId",
                          deliveryNo.text, @"logisticsId",
                          @"", @"twoDCode",
                          nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          customer, @"customer",
                          [userinfo objectForKey:@"wuyemobile"], @"wuyemobile",
                          groupname, @"groupName",
                          pacel, @"pacel",
                          nil];
    [Utilities startLoadingUI:self];
    [[ServiceMethods getInstance] registerDeliveryNo:dict onSuceess:^(NSInteger code) {
        [Utilities stopLoadingUI];
        [self.txtCell setText:@""];
        [self.deliveryNo setText:@""];
        [Utilities showError:@"" Message:@"通知短信发送成功，快件已记录"];
    } onFail:^(NSError *error) {
        [Utilities stopLoadingUI];
        [Utilities showError:@"出错了" Message:[error description]];
    }];
}

-(IBAction)txtInputDone:(id)sender
{
    [sender resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [groups count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"picker title %d", (int)row);
    return [groups objectAtIndex:row];
}

//table data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GROUP_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    NSString *groupname = [groups objectAtIndex:indexPath.row];
    [cell.lblgroup setText:groupname];
    return cell;
}
//end of table data source

// table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *group = [groups objectAtIndex:indexPath.row];
    [self.lblgroup setText:group];
    //[self selectGroup:nil];
}
// end of table delegate

@end
