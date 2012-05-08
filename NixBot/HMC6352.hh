#ifndef __HMC6352_HH__
# define __HMC6352_HH__

# define HMC6352_ADDR		0x42


class		HMC6352
{
public:
  HMC6352(unsigned char powerpin);		// pin to enable HMC6352 power
  ~HMC6352();
  short int	getHeading();			// returns the 2 byte value (short int) this value should be divided by 10.0 to get the angle in degree
  float		getDegree();			// CALLS getHeading ! gives the result directly in degree (float .1 precision)
  short int	getAngle();			// CALLS getHeading ! gives the result directly in degree (short int, degree trunkated)
  void		enterCalibration();		// Tells HMC6352 to enter Calibration mode
  void		exitCalibration();		// Tells HMC6352 to exit from Calibration mode
  void		powerOn();			// Turns the HMC6352 power pin on
  void		powerOff();			// cuts off the HMC6352 power
  void		updateBridgeOffset();		// Tells HMC6352 to update the bridge offset (?)
  void		wake();				// Tells HMC6352 to wake up from sleep
  void		sleep();			// Tells HMC6352 to enter sleep mode
  void		saveConfig();			// Tells HMC6352 to save parameters from RAM to EEPROM
  bool		rotationSense();		// returns the _rotation value
  bool		rotationSense(bool rotation);	// sets the _rotation value
private:
  int		_status;
  int		_slaveaddr;
  unsigned char	_pwrpin;
  bool		_rotation;		// stores true if clock rotation increase degrees (0 > 360) or false if decrease (360 > 0) 
};

#endif // !__HMC6352_HH__
