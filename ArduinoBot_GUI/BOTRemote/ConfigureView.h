//
//  Configuration.h
//  BOTRemote
//
//  Created by nix on 23/12/10.
//  Copyright 2010 Epitech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PocketsphinxController;

#import <OpenEars/OpenEarsEventsObserver.h> // We need to import this here in order to use the delegate.

@interface ConfigureView : UIViewController <OpenEarsEventsObserverDelegate>  {
	IBOutlet UITextField				*enter_pincode_textfield;
	IBOutlet UILabel					*enter_pincode_label;
	IBOutlet UILabel					*status_label;
	IBOutlet UIButton					*connect_nixBOT_button;
	IBOutlet UIButton					*search_nixBOT_button;
	IBOutlet UIButton					*test_comm_button;
	IBOutlet UIActivityIndicatorView	*search_nixBOT_activity;
	IBOutlet UIActivityIndicatorView	*connect_nixBOT_activity;
	IBOutlet NSTimer									*searchtimer;
	IBOutlet NSTimer									*connecttimer;
	IBOutlet UIButton									*quit_app;
    
    IBOutlet UILabel *speech_recognition_label;
    IBOutlet UIButton *start_detection_button;

    OpenEarsEventsObserver *openEarsEventsObserver; 
    PocketsphinxController *pocketsphinxController; 
    
    NSString *pathToGrammarToStartAppWith;
	NSString *pathToDictionaryToStartAppWith;
    
    bool speech_detection_started;
	
}
@property (nonatomic, retain) IBOutlet UIButton					*search_nixBOT_button;
@property (nonatomic, retain) IBOutlet UITextField				*enter_pincode_textfield;
@property (nonatomic, retain) IBOutlet UILabel					*enter_pincode_label;
@property (nonatomic, retain) IBOutlet UILabel					*status_label;
@property (nonatomic, retain) IBOutlet UIButton					*connect_nixBOT_button;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView	*search_nixBOT_activity;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView	*connect_nixBOT_activity;
@property (nonatomic, retain) IBOutlet UIButton					*test_comm_button;

@property (nonatomic, retain) IBOutlet UILabel                  *speech_recognition_label;
@property (nonatomic, retain) IBOutlet UIButton		*quit_app;
@property (nonatomic, retain) IBOutlet UIButton*        start_detection_button;

@property (nonatomic, strong) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, strong) PocketsphinxController *pocketsphinxController;

@property (nonatomic, copy) NSString *pathToGrammarToStartAppWith;
@property (nonatomic, copy) NSString *pathToDictionaryToStartAppWith;

@end
