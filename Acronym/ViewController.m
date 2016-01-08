//
//  ViewController.m
//  Acronym
//
//  Created by Justin Lee on 1/7/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)doSomeFunkyStuff {
	float progress = 0.0;
	
	while (progress < 1.0) {
		progress += 0.01;
		HUD.progress = progress;
		usleep(50000);
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	HUD.labelText = @"Doing funky stuff...";
	HUD.detailsLabelText = @"Just relax";
//	HUD.mode = MBProgressHUDModeAnnularDeterminate;
//	[HUD showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
	
	[self.view addSubview:HUD];
	[HUD show:YES];
	
	self.view.backgroundColor = [UIColor whiteColor];
	NSDictionary *parameters = @{@"sf": @"HMM", @"lf": @""};
	NSString *urlString = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";//@"https://api.github.com/users/justinleerepo";
	NSURL *url = [NSURL URLWithString:urlString];
	
	AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
	[manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask * task, id responseObject) {
		NSLog(@"success %@", responseObject);
		[HUD hide:YES];
	} failure:^(NSURLSessionTask *operation, NSError * error) {
		NSLog(@"failed %@", error);
		[HUD hide:YES];
	}];
	
	NSLog(@"yoyoma");
	
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
