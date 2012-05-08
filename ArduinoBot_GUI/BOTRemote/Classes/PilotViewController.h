//
//  FirstViewController.h
//  BOTRemote
//
//  Created by nix on 23/12/10.
//  Copyright Epitech 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PilotViewController : UIViewController {
	IBOutlet UISlider		*left_motor_slide;
	IBOutlet UISlider		*right_motor_slide;
	IBOutlet UISlider		*head_angle_slide;
	IBOutlet UILabel		*maintext;
	IBOutlet UITextField	*head_angle_textfield;
	IBOutlet UITextField	*left_motor_textfield;
	IBOutlet UITextField	*right_motor_textfield;	
	IBOutlet UIButton		*reset_left_motor;
	IBOutlet UIButton		*reset_right_motor;
	IBOutlet UIButton		*reset_head_angle;
	IBOutlet UIButton		*equal_left_motor;
	IBOutlet UIButton		*equal_right_motor;
	IBOutlet UIButton		*increase_motors;
	IBOutlet UIButton		*decrease_motors;
	IBOutlet UIButton		*reset_motors;

}

@property (nonatomic, retain) IBOutlet UISlider		*left_motor_slide;
@property (nonatomic, retain) IBOutlet UISlider		*right_motor_slide;
@property (nonatomic, retain) IBOutlet UISlider		*head_angle_slide;
@property (nonatomic, retain) IBOutlet UILabel		*maintext;
@property (nonatomic, retain) IBOutlet UITextField	*head_angle_textfield;
@property (nonatomic, retain) IBOutlet UITextField	*left_motor_textfield;
@property (nonatomic, retain) IBOutlet UITextField	*right_motor_textfield;
@property (nonatomic, retain) IBOutlet UIButton		*reset_left_motor;
@property (nonatomic, retain) IBOutlet UIButton		*reset_right_motor;
@property (nonatomic, retain) IBOutlet UIButton		*reset_head_angle;
@property (nonatomic, retain) IBOutlet UIButton		*equal_left_motor;
@property (nonatomic, retain) IBOutlet UIButton		*equal_right_motor;
@property (nonatomic, retain) IBOutlet UIButton		*increase_motors;
@property (nonatomic, retain) IBOutlet UIButton		*decrease_motors;
@property (nonatomic, retain) IBOutlet UIButton		*reset_motors;

@end
