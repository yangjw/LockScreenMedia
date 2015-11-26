//
//  VC1.m
//  LockScreenMedia
//
//  Created by njdby on 15/11/20.
//  Copyright © 2015年 njdby. All rights reserved.
//

#import "VC1.h"

@interface VC1 ()<NSUserActivityDelegate,UISearchDisplayDelegate,UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UISearchDisplayController *searchController;
}
@property (weak, nonatomic) IBOutlet UITableView *addTab;
@property (nonatomic, strong) UISearchController *newsearchController;
@end

@implementation VC1

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
     CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) + 16, 44)];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    searchBar.delegate = self;
    self.addTab.tableHeaderView  = searchBar;
    self.addTab.sectionIndexColor = [UIColor grayColor];
    
//    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    
//    searchController.searchResultsDataSource = self;
//    searchController.searchResultsDelegate = self;
//    
//    searchController.searchBar.barTintColor = [UIColor colorWithRed:0.125 green:0.675 blue:0.875 alpha:1.000];
    
    self.newsearchController= [[UISearchController alloc] initWithSearchResultsController:nil];
    self.newsearchController.searchResultsUpdater = self;
    
    self.newsearchController.delegate = self;
    [self.newsearchController.searchBar sizeToFit];
    self.newsearchController.searchBar.delegate = self;
    
    self.newsearchController.dimsBackgroundDuringPresentation = NO;
    
    self.addTab.tableHeaderView = self.newsearchController.searchBar;
    
    //    BEGINSWITH 开始
//    ENDSWITH 结束
//    CONTAINS 包含
//    NSPredicate *pr = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",@"123"];
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self creatHandOffUserActivity];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                @[@"2",@"12",@"2",@"2",@"12",@"2"]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
//            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
            NSArray *arr =  @[@"2",@"12",@"2",@"2",@"12",@"2"];
            
            return [arr count];
        }
    }
}







- (void)creatHandOffUserActivity
{
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 8) {
        if (self.userActivity !=nil) {
            self.userActivity = nil;
        }
        self.userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.handoffdemo.dosomething"];
        self.userActivity.title = @"oneVC";
        self.userActivity.delegate = self;
        self.userActivity.userInfo = @{@"jumpId":@"1",@"info":@"由VC1跳转到第二个VC2"};
        self.userActivity.needsSave = YES;
        self.userActivity.webpageURL = [NSURL URLWithString:@"http://www.baidu.com"];
        [self.userActivity becomeCurrent];
    }
}

- (void)userActivityWillSave:(NSUserActivity *)userActivity
{
    
}

-(void)userActivityWasContinued:(NSUserActivity *)userActivity
{
    NSLog(@"这个软件已经在另一台设备上打开");
}

-(void)restoreUserActivityState:(NSUserActivity *)activity
{
    NSString *jumpto = [[activity userInfo] objectForKey:@"jumpId"];
    if ([jumpto isEqualToString:@"0"]) {
        NSString *info = [[activity userInfo] objectForKey:@"info"];
        NSLog(@"---->%@",info);
    }
    [super restoreUserActivityState:activity];
}


- (void)updateUserActivityState:(NSUserActivity *)activity
{
    if ([activity.activityType isEqualToString:@"com.handoffdemo.dosomething"]) {
        
        [activity addUserInfoEntriesFromDictionary:@{@"jumpId":@"1",@"info":@"由VC1跳转到第二个VC2更新信息"}];
        
    }
    
    [super updateUserActivityState:activity];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
//废弃  userActivity
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.userActivity invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
