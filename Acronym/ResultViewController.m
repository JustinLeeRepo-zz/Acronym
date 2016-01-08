//
//  ResultViewController.m
//  Acronym
//
//  Created by Justin Lee on 1/7/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

#import "ResultViewController.h"
#import "NetworkAccess.h"
#import "MBProgressHUD.h"

@interface ResultViewController ()

@property (nonatomic,retain) UITableView * tableView;
@property (nonatomic,retain) NSMutableArray* acronymArray;
@property (nonatomic,retain) UILabel * headerLabel;

@end

@implementation ResultViewController

@synthesize acronymArray;
@synthesize headerLabel;

- (void)backButtonNormal:(UIButton *)sender
{
	//self.backButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:102.2/255.0 alpha:0.9];
}
- (void)backTouchDown:(UIButton *) sender
{
	//self.backButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:71.0/255.0 blue:71.2/255.0 alpha:0.9];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initTableView
{
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80) style:UITableViewStylePlain];
	self.view.backgroundColor = [UIColor colorWithRed:181.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0];
	self.tableView.dataSource =self;
	self.tableView.delegate = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.view addSubview:self.tableView];
	[self.view sendSubviewToBack:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([acronymArray count] == 0) {
		return 1;
		
	}
	else {
		return [acronymArray count];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	static NSString *CellIdentifier = @"ListingIdentifier";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
		cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
		cell.textLabel.textColor = [UIColor colorWithRed:108.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0];
		
	}
	if ([acronymArray count] == 0) {
		cell.textLabel.text = @"No results found. Press back & try again.";
	}
	else {
		cell.textLabel.text = [[acronymArray objectAtIndex:row] objectForKey:@"lf"];
	}
	return cell;
}

- (void)viewWillAppear:(BOOL)animated{
	[headerLabel setText:self.acronym];
	[HUD show:YES];
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^ {
		[NetworkAccess accessServer:self.acronym success:^(NSURLSessionTask *task, NSArray *responseObject){
			dispatch_async(dispatch_get_main_queue(), ^ {
				if([responseObject count] > 0){
					acronymArray = [[responseObject objectAtIndex:0] objectForKey:@"lfs"];
				}
				else {
					[acronymArray removeAllObjects];
				}
				[HUD hide:YES];
				[self initTableView];
			});
		} failure:^(NSURLSessionTask *operation, NSError *error){
			dispatch_async(dispatch_get_main_queue(), ^ {
				[HUD hide:YES];
			});
		}];
	});

	[self.tableView reloadData];
	[self.tableView setContentOffset:CGPointMake(0, 0)];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithRed:181.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0];
	
	UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
	
	headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, headerView.frame.size.width, 30)];
	[headerLabel setText:self.acronym];
	[headerLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[headerLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
	[headerLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0]];
	headerLabel.textAlignment = NSTextAlignmentCenter;
	
	UIView * headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y + headerView.frame.size.height, self.view.frame.size.width, 1)];
	headerLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.2/255.0 alpha:1.0];
	
	UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState :UIControlStateNormal];
	backButton.tintColor = [UIColor whiteColor];
	backButton.frame = CGRectMake(15, 35, 30, 30);
	[backButton addTarget:self action:@selector(backTouchDown:) forControlEvents:UIControlEventTouchDown];
	[backButton addTarget:self action:@selector(backButtonNormal:) forControlEvents:UIControlEventTouchUpInside];
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Acronym Results";
	//	HUD.mode = MBProgressHUDModeAnnularDeterminate;
	//	[HUD showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
	
	
	[headerView addSubview:headerLabel];
	[headerView addSubview:backButton];
	[headerView addSubview:headerLine];
	[self.view addSubview:HUD];
	[self.view addSubview:headerView];
	[self.view bringSubviewToFront:headerView];
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