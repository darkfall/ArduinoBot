//
//  ArduinoConfig.h
//  BOTRemote
//
//  Created by Griffin me on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef BOTRemote_ArduinoConfig_h
#define BOTRemote_ArduinoConfig_h


enum ArduinoOperations {
    AO_MoveLeftDown = 1,
    AO_MoveRightDown = 2,
    AO_MoveUpDown = 3,
    AO_MoveDownDown = 4,
    AO_MoveLeftUp = 5,
    AO_MoveRightUp = 6,
    AO_MoveUpUp = 7,
    AO_MoveDownUp = 8,
    AO_MoveStop = 9,
    
    AO_LeftSpeedUp = 20,
    AO_LeftSpeedDown = 21,
    AO_RightSpeedUp = 22,
    AO_RightSpeedDown = 23,
    AO_LeftSpeedReset = 24,
    AO_RightSpeedReset = 25,
    AO_AllSpeedReset = 26,
    AO_AllSpeedUp = 27,
    AO_AllSpeedDown = 28,
    
    AO_ServoLeftAttach = 40,
    AO_ServoRightAttach = 41,
    AO_ServoLeftDetach = 42,
    AO_ServoRightDetach = 43,
    
    AO_LedOn = 128,
    AO_LedOff = 129
};

static const char* ArduinoBTPin = "1234";
static const char* ArduinoBTDeviceName = "RN42-B874";

#endif
