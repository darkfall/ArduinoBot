//
//  Configuration.m
//  BOTRemote
//
//  Created by nix on 23/12/10.
//  Copyright 2010 Epitech. All rights reserved.
//

#import <btstack/btstack.h>
#import "ConfigureView.h"
#import "BOTRemoteAppDelegate.h"
#import "CTools.h"
#import "BTScan.h"
#import "BTLayer.h"

@implementation ConfigureView

@synthesize enter_pincode_textfield,enter_pincode_label,status_label,connect_nixBOT_button,search_nixBOT_button,test_comm_button,search_nixBOT_activity,connect_nixBOT_activity,quit_app;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)QuitAppButtonClick:(id)sender {
	bt_end();
	exit (0);
}

- (IBAction)EnterPinCodeEnd:(id)sender {
	[sender resignFirstResponder];
	if (enter_pincode_textfield.text.length == 4)
	{
		connect_nixBOT_button.hidden = FALSE;
	}
	else
	{
		UIAlertView* alertView = [[UIAlertView alloc] init];
		alertView.title = @"PinCode Error";
		alertView.message = @"Invalid Piko Code length\n"
		"Please make sure that your Pin Code is configured correctly.";
		[alertView addButtonWithTitle:@"Dismiss"];
		[alertView show];		
	}
}

- (IBAction)ConnectButtonClick:(id)sender
{
	if (bt_connectdone() == 0)
	{
		connect_nixBOT_button.enabled = FALSE;
		connect_nixBOT_activity.hidden = FALSE;
		status_label.text = @"Status: Connecting";
		[connect_nixBOT_activity startAnimating]; connecttimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(CheckConnect) userInfo:nil repeats:YES];
		t_device *device = bt_getdevicebyname("nixBOT");
		bt_rfcomm_connect(device, [enter_pincode_textfield.text UTF8String]);
	}
	else
	{
			//		bt_rfcomm_disconnect();
		bt_end();
		test_comm_button.enabled = FALSE;
		test_comm_button.hidden = TRUE;
		search_nixBOT_button.hidden = FALSE;
		enter_pincode_textfield.hidden = TRUE;
		enter_pincode_label.hidden = TRUE;
		[connect_nixBOT_button setTitle: @"Connect NixBOT" forState: UIControlStateNormal ];
		connect_nixBOT_button.hidden = TRUE;
		status_label.text = @"Status: Disconnected";
	}
}

- (IBAction)TestButtonClick:(id)sender
{
	unsigned int size;
	char *tmp = bt_rfcomm_receive(&size);
	if (tmp != 0)
	{
		tmp[size - 1] = 0;
		printf("Data Received: %s\n", tmp);

		UIAlertView* alertView = [[UIAlertView alloc] init];
		alertView.title = @"Data Received";
		alertView.message = [NSString stringWithUTF8String: tmp];
		[alertView addButtonWithTitle:@"Dismiss"];
		[alertView show];
		free(tmp);
	}	
	bt_rfcomm_send("up\rpilot\rurmangle 180\r", strlen("up\rpilot\rurmangle 180\r"));
	printf("Test Command Sent.\n");
}

-(void)CheckConnect
{
	if (bt_connectdone() != 0)
	{
		[connect_nixBOT_activity stopAnimating];
		connect_nixBOT_activity.hidden = TRUE;
		connect_nixBOT_button.enabled = FALSE;
		status_label.text = @"Status: Connected";
		connect_nixBOT_button.hidden = FALSE;
		test_comm_button.enabled = TRUE;
		test_comm_button.hidden = FALSE;
		//		bt_rfcomm_send("pilot\r\nurmangle 180\r\n", strlen("pilot\r\nurmangle 180\r\n"));
		//		unsigned int size;
		//		char *tmp = bt_rfcomm_receive(&size);
		//		if (tmp != 0)
		//		{
		//		tmp[size - 1] = 0;
		//		printf("Data Received: %s.\n", tmp);
		//		UIAlertView* alertView = [[UIAlertView alloc] init];
		//		alertView.title = @"Data Received";
		//		alertView.message = [NSString stringWithUTF8String: tmp];
		//		[alertView addButtonWithTitle:@"Dismiss"];
		//		[alertView show];
		//		free(tmp);
		//		[connecttimer invalidate];
		//	}
	}
}

-(IBAction)backgroundTouched:(id)sender
{
	[enter_pincode_textfield resignFirstResponder];
}


- (IBAction)SearchNixBOTClick:(id)sender {
	search_nixBOT_activity.hidden = FALSE;
	[search_nixBOT_activity startAnimating]; searchtimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(CheckScan) userInfo:nil repeats:YES];
	bt_scan();
}

-(void)CheckScan { //do your url request process

	if (bt_scandone())
	{
		[search_nixBOT_activity stopAnimating];
		t_device *device = bt_getdevicebyname("nixBOT");
		if (device)
		{
			status_label.text = @"Status: nixBOT Found";
			enter_pincode_label.hidden = FALSE;
			search_nixBOT_activity.hidden = TRUE;
			enter_pincode_textfield.hidden = FALSE;
			search_nixBOT_button.hidden = TRUE;
			[searchtimer invalidate];
		}
		else
		{
			status_label.text = @"Status: nixBOT not found !!\n"
			"Search again ?";
		}

	}
}

 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);

// return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
