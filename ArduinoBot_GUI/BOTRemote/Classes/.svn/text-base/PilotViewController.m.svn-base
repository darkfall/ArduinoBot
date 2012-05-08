//
//  FirstViewController.m
//  BOTRemote
//
//  Created by nix on 23/12/10.
//  Copyright Epitech 2010. All rights reserved.
//

#import <btstack/btstack.h>
#import "PilotViewController.h"
#import "CTools.h"
#import "BTScan.h"
#import "BTLayer.h"


@implementation PilotViewController

@synthesize left_motor_slide,right_motor_slide,head_angle_slide,maintext,head_angle_textfield,left_motor_textfield,right_motor_textfield,reset_left_motor,reset_right_motor,reset_head_angle,equal_left_motor,equal_right_motor,increase_motors,decrease_motors,reset_motors;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	CGAffineTransform trans =  CGAffineTransformMakeRotation(M_PI * 1.5);
	
	left_motor_slide.transform = trans;
	right_motor_slide.transform = trans;
	
	left_motor_textfield.text = [NSString stringWithFormat:@"%.0f", left_motor_slide.value];
	right_motor_textfield.text = [NSString stringWithFormat:@"%.0f", right_motor_slide.value];	
	head_angle_textfield.text = [NSString stringWithFormat:@"%.0f", head_angle_slide.value];	
}


- (IBAction)LeftMotorChangeValidate:(id)sender {
	if (bt_connectdone() != 0)
		bt_rfcomm_send_string([[NSString stringWithFormat:@"\rpilot\rleftmotor %.0f\r", left_motor_slide.value] UTF8String]);
}

- (IBAction)RightMotorChangeValidate:(id)sender {
	if (bt_connectdone() != 0)
		bt_rfcomm_send_string([[NSString stringWithFormat:@"\rpilot\rrightmotor %.0f\r", right_motor_slide.value] UTF8String]);
}

- (IBAction)HeadAngleChangeValidate:(id)sender {
	if (bt_connectdone() != 0)
		bt_rfcomm_send_string([[NSString stringWithFormat:@"\rpilot\rurmangle %.0f\r", 180 - head_angle_slide.value] UTF8String]);
}

- (IBAction)LeftMotorChange:(id)sender {
	float roundedval = left_motor_slide.value;
	roundedval = (float)(((int)(roundedval)) - ((int)roundedval % 10));
	left_motor_slide.value = roundedval;
	left_motor_textfield.text = [NSString stringWithFormat:@"%.0f", left_motor_slide.value];
		//NSString *test = [[NSString stringWithFormat:@"pilot\rleftmotor %.0f", left_motor_slide.value] UTF8String];
		//
}

- (IBAction)RightMotorChange:(id)sender {
	float roundedval = right_motor_slide.value;
	roundedval = (float)(((int)(roundedval)) - ((int)roundedval % 10));
	right_motor_slide.value = roundedval;	
	right_motor_textfield.text = [NSString stringWithFormat:@"%.0f", right_motor_slide.value];
}

- (IBAction)HeadAngleChange:(id)sender {
	head_angle_textfield.text = [NSString stringWithFormat:@"%.0f", 180 - head_angle_slide.value];
}


- (IBAction)ResetLeftMotorClick:(id)sender {
	float roundedval = 0;
	left_motor_slide.value = roundedval;
	left_motor_textfield.text = [NSString stringWithFormat:@"%.0f", left_motor_slide.value];
	if (bt_connectdone() != 0)
		bt_rfcomm_send_string([[NSString stringWithFormat:@"\rpilot\rleftmotor %.0f\r", left_motor_slide.value] UTF8String]);
}

- (IBAction)ResetRightMotorClick:(id)sender {
	float roundedval = 0;
	right_motor_slide.value = roundedval;
	right_motor_textfield.text = [NSString stringWithFormat:@"%.0f", right_motor_slide.value];
	if (bt_connectdone() != 0)
		bt_rfcomm_send_string([[NSString stringWithFormat:@"\rpilot\rrightmotor %.0f\r", right_motor_slide.value] UTF8String]);
}

- (IBAction)ResetHeadAngleClick:(id)sender {
	head_angle_slide.value = 90;
	head_angle_textfield.text = [NSString stringWithFormat:@"%.0f", head_angle_slide.value];
	if (bt_connectdone() != 0)
		bt_rfcomm_send_string([[NSString stringWithFormat:@"\rpilot\rurmangle %.0f\r", 180 - head_angle_slide.value] UTF8String]);
}

- (IBAction)EqualLeftMotorClick:(id)sender {
	right_motor_slide.value = left_motor_slide.value;
	right_motor_textfield.text = [NSString stringWithFormat:@"%.0f", right_motor_slide.value];	
	if (bt_connectdone() != 0)
		bt_rfcomm_send_string([[NSString stringWithFormat:@"\rpilot\rrightmotor %.0f\r", right_motor_slide.value] UTF8String]);
}

- (IBAction)EqualRightMotorClick:(id)sender {
	left_motor_slide.value = right_motor_slide.value;
	left_motor_textfield.text = [NSString stringWithFormat:@"%.0f", left_motor_slide.value];
	if (bt_connectdone() != 0)
		bt_rfcomm_send_string([[NSString stringWithFormat:@"\rpilot\rleftmotor %.0f\r", left_motor_slide.value] UTF8String]);
}


- (IBAction)IncreaseMotorsClick:(id)sender {
	left_motor_slide.value += 10;
	right_motor_slide.value += 10;
	left_motor_textfield.text = [NSString stringWithFormat:@"%.0f", left_motor_slide.value];
	right_motor_textfield.text = [NSString stringWithFormat:@"%.0f", right_motor_slide.value];	
	if (bt_connectdone() != 0)
		bt_rfcomm_send_string([[NSString stringWithFormat:@"\rpilot\rmotors %.0f %.0f\r", left_motor_slide.value, right_motor_slide.value] UTF8String]);
}

- (IBAction)DecreaseMotorsClick:(id)sender {
	left_motor_slide.value -= 10;
	right_motor_slide.value -= 10;
	left_motor_textfield.text = [NSString stringWithFormat:@"%.0f", left_motor_slide.value];
	right_motor_textfield.text = [NSString stringWithFormat:@"%.0f", right_motor_slide.value];	
	if (bt_connectdone() != 0)
		bt_rfcomm_send_string([[NSString stringWithFormat:@"\rpilot\rmotors %.0f %.0f\r", left_motor_slide.value, right_motor_slide.value] UTF8String]);

}

- (IBAction)ResetMotorsClick:(id)sender {
	float roundedval = 0;
	right_motor_slide.value = roundedval;
	left_motor_slide.value = roundedval;
	left_motor_textfield.text = [NSString stringWithFormat:@"%.0f", left_motor_slide.value];
	right_motor_textfield.text = [NSString stringWithFormat:@"%.0f", right_motor_slide.value];
	if (bt_connectdone() != 0)
		bt_rfcomm_send_string([[NSString stringWithFormat:@"\rpilot\rmotors %.0f %.0f\r", left_motor_slide.value, right_motor_slide.value] UTF8String]);
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
 //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
