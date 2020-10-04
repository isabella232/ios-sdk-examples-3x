//
//  ClassicTableViewManagedByTaboolaController.m
//  TaboolaSDKExampleObjective-C
//
//  Created by Liad Elidan on 01/06/2020.
//  Copyright © 2020 Liad Elidan. All rights reserved.
//

#import "ClassicTableViewManagedByTaboolaController.h"
#import <TaboolaSDK/TaboolaSDK.h>
#import "RandomColor.h"

@interface ClassicTableViewManagedByTaboolaController () <TBLClassicPageDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewManagedByTaboola;

// TBLClassicPage holds Taboola Widgets/Feed for a specific view
@property (nonatomic, strong) TBLClassicPage* classicPage;
// TBLClassicUnit object represnting Widget/Feed
@property (nonatomic, strong) TBLClassicUnit* taboolaWidgetPlacement;
@property (nonatomic, strong) TBLClassicUnit* taboolaFeedPlacement;

@end

@implementation ClassicTableViewManagedByTaboolaController

#pragma mark - ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self taboolaInit];
}

-(void)taboolaInit {
    _classicPage = [[TBLClassicPage alloc]initWithPageType:@"article" pageUrl:@"http://www.example.com" delegate:self scrollView:_tableViewManagedByTaboola];
    
    _taboolaWidgetPlacement = [_classicPage createUnitWithPlacementName:@"Below Article" mode:@"alternating-widget-without-video-1x4" placementType:PlacementTypeWidget];
     [_taboolaWidgetPlacement fetchContent];
    
    _taboolaFeedPlacement = [_classicPage createUnitWithPlacementName:@"Feed without video" mode:@"thumbs-feed-01" placementType:PlacementTypeFeed];
    [_taboolaFeedPlacement fetchContent];
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == taboolaWidgetSection) {
        return [_taboolaWidgetPlacement tableView:tableView cellForRowAtIndexPath:indexPath withBackground:nil];
    
    }
    else if (indexPath.section == taboolaFeedSection) {
        return [_taboolaFeedPlacement tableView:tableView cellForRowAtIndexPath:indexPath withBackground:nil];
    }
    else {
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"RandomCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [RandomColor setRandomColor];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return totalSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == taboolaWidgetSection) {
        return [_taboolaWidgetPlacement tableView:tableView heightForRowAtIndexPath:indexPath withUIInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    else if (indexPath.section == taboolaFeedSection) {
        return [_taboolaFeedPlacement tableView:tableView heightForRowAtIndexPath:indexPath withUIInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return 200;
}

-(void)dealloc {
    [_taboolaWidgetPlacement reset];
    [_taboolaFeedPlacement reset];
}

#pragma mark - TBLClassicPageDelegate

-(void)taboolaView:(UIView *)taboolaView didLoadOrChangeHeightOfPlacementNamed:(NSString *)placementName withHeight:(CGFloat)height {
    NSLog(@"%@", placementName);
}

- (void)taboolaView:(UIView *)taboolaView didFailToLoadPlacementNamed:(NSString *)placementName withErrorMessage:(NSString *)error {
    NSLog(@"%@", error);
}

- (BOOL)onItemClick:(NSString *)placementName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {
    if (!organic) {
        return NO;
    }
    return YES;
}

@end