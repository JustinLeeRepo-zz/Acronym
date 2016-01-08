//
//  ResultViewController.h
//  Acronym
//
//  Created by Justin Lee on 1/7/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface ResultViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	MBProgressHUD *HUD;
}

@property (strong,nonatomic) NSString *acronym;

@end
