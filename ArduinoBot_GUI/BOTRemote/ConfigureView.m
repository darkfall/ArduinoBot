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
#import "ArduinoConfig.h"

#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/LanguageModelGenerator.h>


@implementation ConfigureView

@synthesize enter_pincode_textfield,enter_pincode_label,status_label,connect_nixBOT_button,search_nixBOT_button,test_comm_button,search_nixBOT_activity,connect_nixBOT_activity,quit_app;

@synthesize openEarsEventsObserver;
@synthesize pathToGrammarToStartAppWith;
@synthesize pathToDictionaryToStartAppWith;
@synthesize pocketsphinxController;
@synthesize speech_recognition_label;
@synthesize start_detection_button;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
- (PocketsphinxController *)pocketsphinxController { 
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}

// Lazily allocated OpenEarsEventsObserver.
- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.openEarsEventsObserver setDelegate:self];
    
    self.pathToGrammarToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"OpenEars1.languagemodel"]; 
    self.pathToDictionaryToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"OpenEars1.dic"]; 
    
    NSArray *languageArray = [[NSArray alloc] initWithArray:[NSArray arrayWithObjects: // All capital letters.
                                                             @"LEFT",
                                                             @"RIGHT",
                                                             @"GO",
                                                             @"BACK",
                                                             @"STOP",
                                                             @"LED",
                                                             nil]];
    
    LanguageModelGenerator *languageModelGenerator = [[LanguageModelGenerator alloc] init]; 

    NSError *error = [languageModelGenerator generateLanguageModelFromArray:languageArray withFilesNamed:@"OpenEarsDynamicGrammar"];
    
	NSDictionary *dynamicLanguageGenerationResultsDictionary = nil;
	if([error code] != noErr) {
		NSLog(@"Dynamic language generator reported error %@", [error description]);	
	} else {
		dynamicLanguageGenerationResultsDictionary = [error userInfo];
		
		// A useful feature of the fact that generateLanguageModelFromArray:withFilesNamed: always returns an NSError is that when it returns noErr (meaning there was
		// no error, or an [NSError code] of zero), the NSError also contains a userInfo dictionary which contains the path locations of your new files.
		
		// What follows demonstrates how to get the paths for your created dynamic language models out of that userInfo dictionary.
		NSString *lmFile = [dynamicLanguageGenerationResultsDictionary objectForKey:@"LMFile"];
		NSString *dictionaryFile = [dynamicLanguageGenerationResultsDictionary objectForKey:@"DictionaryFile"];
		NSString *lmPath = [dynamicLanguageGenerationResultsDictionary objectForKey:@"LMPath"];
		NSString *dictionaryPath = [dynamicLanguageGenerationResultsDictionary objectForKey:@"DictionaryPath"];
		
		NSLog(@"Dynamic language generator completed successfully, you can find your new files %@\n and \n%@\n at the paths \n%@ \nand \n%@", lmFile,dictionaryFile,lmPath,dictionaryPath);	
		
		// pathToDynamicallyGeneratedGrammar/Dictionary aren't OpenEars things, they are just the way I'm controlling being able to switch between the grammars in this sample app.
		self.pathToGrammarToStartAppWith = lmPath; // We'll set our new .languagemodel file to be the one to get switched to when the words "CHANGE MODEL" are recognized.
		self.pathToDictionaryToStartAppWith = dictionaryPath; // We'll set our new dictionary to be the one to get switched to when the words "CHANGE MODEL" are recognized.
    }
    
   /* if(dynamicLanguageGenerationResultsDictionary) {
        
		// startListeningWithLanguageModelAtPath:dictionaryAtPath:languageModelIsJSGF always needs to know the grammar file being used, 
		// the dictionary file being used, and whether the grammar is a JSGF. You must put in the correct value for languageModelIsJSGF.
		// Inside of a single recognition loop, you can only use JSGF grammars or ARPA grammars, you can't switch between the two types.
		
		// An ARPA grammar is the kind with a .languagemodel or .DMP file, and a JSGF grammar is the kind with a .gram file.
		[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
        
	}*/
    
    speech_detection_started = false;
    self.speech_recognition_label.text = @"Detection Stopped";
}

- (IBAction)QuitAppButtonClick:(id)sender {
    bt_rfcomm_send_byte(AO_MoveStop);
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
		t_device *device = bt_getdevicebyname(ArduinoBTDeviceName);
		bt_rfcomm_connect(device, ArduinoBTPin);
	}
	else
	{
			//		bt_rfcomm_disconnect();
		bt_end();
		search_nixBOT_button.hidden = FALSE;
		enter_pincode_textfield.hidden = TRUE;
		enter_pincode_label.hidden = TRUE;
		[connect_nixBOT_button setTitle: @"Connect ArduinoBot" forState: UIControlStateNormal ];
		connect_nixBOT_button.hidden = TRUE;
		status_label.text = @"Status: Disconnected";
	}
}

static bool led_flag = false;

- (IBAction)TestButtonClick:(id)sender
{/*
	unsigned int size;
	char *tmp = bt_rfcomm_receive(&size);
	if (tmp != 0)
	{
		tmp[size - 1] = 0;
		printf("Data Received: %s\n", tmp);

    }	*/
    unsigned char k = 129;
    if(!led_flag) {
        k = 128;
        led_flag = true;
    } else {
        led_flag = false;
    }
	bt_rfcomm_send(&k, 1);
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
    status_label.text = @"Status: Connecting";

	[search_nixBOT_activity startAnimating]; searchtimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(CheckScan) userInfo:nil repeats:YES];
	bt_scan();
}

-(IBAction)upButtonTouchDown:(id)sender
{
    bt_rfcomm_send_byte(AO_MoveUpDown);
}

-(IBAction)upButtonTouchRelease:(id)sender
{
    bt_rfcomm_send_byte(AO_MoveUpUp);
}

-(IBAction)downButtonTouchDown:(id)sender
{
    bt_rfcomm_send_byte(AO_MoveDownDown);
}

-(IBAction)downButtonTouchRelease:(id)sender
{
    bt_rfcomm_send_byte(AO_MoveDownUp);
}

-(IBAction)leftButtonTouchDown:(id)sender
{
    bt_rfcomm_send_byte(AO_MoveLeftDown);
}

-(IBAction)leftButtonTouchRelease:(id)sender
{
    bt_rfcomm_send_byte(AO_MoveLeftUp);
    
}

-(IBAction)rightButtonTouchDown:(id)sender
{
    bt_rfcomm_send_byte(AO_MoveRightDown);
}

-(IBAction)rightButtonTouchRelease:(id)sender
{
    bt_rfcomm_send_byte(AO_MoveRightUp);
    
}

-(void)CheckScan { //do your url request process

	if (bt_scandone())
	{
		[search_nixBOT_activity stopAnimating];
		t_device *device = bt_getdevicebyname(ArduinoBTDeviceName);
		if (device)
		{
			status_label.text = @"Status: ArduinoBot Found";
		
            //enter_pincode_label.hidden = FALSE;
			search_nixBOT_activity.hidden = TRUE;
			//enter_pincode_textfield.hidden = FALSE;
			search_nixBOT_button.hidden = TRUE;
            
            if (bt_connectdone() == 0)
            {
                connect_nixBOT_button.enabled = FALSE;
                connect_nixBOT_button.hidden = TRUE;
                connect_nixBOT_activity.hidden = FALSE;
                
                status_label.text = @"Status: Connecting";
                [connect_nixBOT_activity startAnimating]; connecttimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(CheckConnect) userInfo:nil repeats:YES];
                bt_rfcomm_connect(device, ArduinoBTPin);
            }
            
			[searchtimer invalidate];
		}
		else
		{
			status_label.text = @"Status: ArduinoBot not found !!\n"
			"Search again ?";
		}

	}
}

- (IBAction) stopVoiceRecognition { // This is the action for the button which shuts down the recognition loop.
	[self.pocketsphinxController stopListening];
}

- (IBAction) startVoiceRecoginition { // This is the action for the button which starts up the recognition loop again if it has been shut down.
    if(!speech_detection_started) {
        [self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
        self.pocketsphinxController.secondsOfSilenceToDetect = 0.5f;
        speech_detection_started = true;
        
        self.start_detection_button.titleLabel.text = @"Stop";
        self.speech_recognition_label.text = @"Listening";
    }
	else {
        [self.pocketsphinxController stopListening];
        speech_detection_started = false;
        
        self.start_detection_button.titleLabel.text = @"Start";
        self.speech_recognition_label.text = @"Detection Stopped";
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
    [speech_recognition_label release];
    speech_recognition_label = nil;
    [start_detection_button release];
    start_detection_button = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [speech_recognition_label release];
    [start_detection_button release];
    [super dealloc];
}

- (void) doVoiceRecognition: (NSString*) hypothesis {
    if([hypothesis isEqualToString:@"GO"]) {
        bt_rfcomm_send_byte(AO_MoveUpDown);
    } else if([hypothesis isEqualToString:@"BACK"]) {
        bt_rfcomm_send_byte(AO_MoveDownDown);
    } else if([hypothesis isEqualToString:@"STOP"]) {
        bt_rfcomm_send_byte(AO_MoveStop);
    } else if([hypothesis isEqualToString:@"LEFT"]) {
        bt_rfcomm_send_byte(AO_MoveLeftDown);
    } else if([hypothesis isEqualToString:@"RIGHT"]) {
        bt_rfcomm_send_byte(AO_MoveRightDown);
    } else if([hypothesis isEqualToString:@"LED"]) {
        unsigned char k = 129;
        if(!led_flag) {
            k = 128;
            led_flag = true;
        } else {
            led_flag = false;
        }
        bt_rfcomm_send(&k, 1);
    }
}


- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID); // Log it.
    
    self.speech_recognition_label.text = [NSString stringWithFormat:@"You Said: %@", hypothesis];
    
    [self doVoiceRecognition:hypothesis];
	
}

// An optional delegate method of OpenEarsEventsObserver which informs that there was an interruption to the audio session (e.g. an incoming phone call).
- (void) audioSessionInterruptionDidBegin {
	NSLog(@"AudioSession interruption began."); // Log it.
	//self.statusTextView.text = @"Status: AudioSession interruption began."; // Show it in the status box.
	[self.pocketsphinxController stopListening]; // React to it by telling Pocketsphinx to stop listening since it will need to restart its loop after an interruption.
}

// An optional delegate method of OpenEarsEventsObserver which informs that the interruption to the audio session ended.
- (void) audioSessionInterruptionDidEnd {
	NSLog(@"AudioSession interruption ended."); // Log it.
	//self.statusTextView.text = @"Status: AudioSession interruption ended."; // Show it in the status box.
    // We're restarting the previously-stopped listening loop.
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

// An optional delegate method of OpenEarsEventsObserver which informs that the audio input became unavailable.
- (void) audioInputDidBecomeUnavailable {
	NSLog(@"The audio input has become unavailable"); // Log it.
	//self.statusTextView.text = @"Status: The audio input has become unavailable"; // Show it in the status box.
	[self.pocketsphinxController stopListening]; // React to it by telling Pocketsphinx to stop listening since there is no available input
}

// An optional delegate method of OpenEarsEventsObserver which informs that the unavailable audio input became available again.
- (void) audioInputDidBecomeAvailable {
	NSLog(@"The audio input is available"); // Log it.
	//self.statusTextView.text = @"Status: The audio input is available"; // Show it in the status box.
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

// An optional delegate method of OpenEarsEventsObserver which informs that there was a change to the audio route (e.g. headphones were plugged in or unplugged).
- (void) audioRouteDidChangeToRoute:(NSString *)newRoute {
	NSLog(@"Audio route change. The new audio route is %@", newRoute); // Log it.
	//self.statusTextView.text = [NSString stringWithFormat:@"Status: Audio route change. The new audio route is %@",newRoute]; // Show it in the status box.
    
	[self.pocketsphinxController stopListening]; // React to it by telling the Pocketsphinx loop to shut down and then start listening again on the new route
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop hit the calibration stage in its startup.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx. Another good reason to know when you're in the middle of
// calibration is that it is a timeframe in which you want to avoid playing any other sounds including speech so the calibration will be successful.
- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx calibration has started."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop completed the calibration stage in its startup.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx.
- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx calibration is complete."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop has entered its actual loop.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx.
- (void) pocketsphinxRecognitionLoopDidStart {
    
	NSLog(@"Pocketsphinx is starting up."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx is starting up."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is now listening for speech.
- (void) pocketsphinxDidStartListening {
	
	NSLog(@"Pocketsphinx is now listening."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx is now listening."; // Show it in the status box.
	
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx detected speech and is starting to process it.
- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx has detected speech."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx detected a second of silence, indicating the end of an utterance. 
// This was added because developers requested being able to time the recognition speed without the speech time. The processing time is the time between 
// this method being called and the hypothesis being returned.
- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a second of silence, concluding an utterance."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx has detected finished speech."; // Show it in the status box.
}


// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx has exited its recognition loop, most 
// likely in response to the PocketsphinxController being told to stop listening via the stopListening method.
- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx has stopped listening."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is still in its listening loop but it is not
// Going to react to speech until listening is resumed.  This can happen as a result of Flite speech being
// in progress on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
// or as a result of the PocketsphinxController being told to suspend recognition via the suspendRecognition method.
- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx has suspended recognition."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is still in its listening loop and after recognition
// having been suspended it is now resuming.  This can happen as a result of Flite speech completing
// on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
// or as a result of the PocketsphinxController being told to resume recognition via the resumeRecognition method.
- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx has resumed recognition."; // Show it in the status box.
}

// An optional delegate method which informs that Pocketsphinx switched over to a new language model at the given URL in the course of
// recognition. This does not imply that it is a valid file or that recognition will be successful using the file.
- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OPENEARSLOGGING in OpenEarsConfig.h to learn more."); // Log it.
	//self.statusTextView.text = @"Status: Not possible to start recognition loop."; // Show it in the status box.	
}



@end
