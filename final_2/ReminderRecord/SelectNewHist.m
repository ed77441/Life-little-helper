//
//  SelectNewHist.m
//  final_2
//
//  Created by eb211-22 on 2019/12/26.
//  Copyright © 2019 Yuntech. All rights reserved.
//

#import "SelectNewHist.h"
#import "ViewHistory.h"

@interface SelectNewHist ()

@end

@implementation SelectNewHist

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    NSLog(@"tabbar did load");

    
}

- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    UINavigationController *navi2 = [self.viewControllers objectAtIndex: 1];
    ViewHistory *page2 =  (ViewHistory*)navi2.topViewController;
    
    
    if (item == [tabBar.items objectAtIndex: 1]) {
        if ([page2 isKindOfClass: [ViewHistory class]]) {
            [page2 reloadTable];
        }
        
        NSLog(@"ReloadTable");
    }
}


@end
