#ifndef __NIXBOT_HH__
# define __NIXBOT_HH__

#include <stdint.h>
#include <WProgram.h>
#include <HardwareSerial.h>
#include <wiring.h>

#include "cppfix.hh"
#include "Servo/Servo.h"
#include "botURM37.hh"
#include "directionSet.hh"
#include "botMotor.hh"
#include "HMC6352.hh"
#include "botCmdLine.hh"



# define DEBUGMODE


# ifndef DEBUGMODE
#  define CMDSERIAL	Serial
# endif

#ifdef DEBUGMODE
# define DBGSERIAL	Serial
# define CMDSERIAL	DBGSERIAL
# define DEBUGINIT	DBGSERIAL.begin(9600)
# define PRINTDBG(x) do { DBGSERIAL.print("["); DBGSERIAL.print(__FILE__); DBGSERIAL.print(":"); DBGSERIAL.print(__LINE__); DBGSERIAL.print("] "); DBGSERIAL.println(x); } while (false)
#else
# define PRINTDBG(x)
#endif

# define CMDINIT	CMDSERIAL.begin(115200)
# define PRINTCMD(x) do { CMDSERIAL.print("["); CMDSERIAL.print(__FILE__); CMDSERIAL.print(":"); CMDSERIAL.print(__LINE__); CMDSERIAL.print("] "); CMDSERIAL.println(x); } while (false)

# define INITINTR	0	// interrupt for init button


# define	URMSERIAL	Serial3
// PIN DEFINITIONS 
# define	URMSERVOPIN		3
# define	URMSERVOPWRPIN		5
# define	LEFTMOTORSPEEDPIN	6
# define	LEFTMOTORDIRPIN		7
# define	RIGHTMOTORDIRPIN	8
# define	RIGHTMOTORSPEEDPIN	9
# define	HMCPWRPIN		10
# define	URMPWRPIN		11
# define	URMENABLEPIN		12


# define	MINDIST			30

# define	ABS(x)			(x < 0 ? x * -1 : x)

class nixBOT
{
public:
  nixBOT();
  void		toothOn();
  void		toothOff();
  bool		isActive() {return (_active); }
  bool		localize();
  bool		getDirection(t_dir *dir);
  bool		goAhead();
  bool		stop();
  bool		forward();
  void		cmdLines();
  void		initSensors();
  void		initButtonPressed();
  void		scanDirections();
  bool		setDirection();
  bool		checkRetries();
  void		Activate(bool state) { _active = state; }
  botURM37	*getURM37() {return (_urm37); }
  botMotor	*getLeftMotor() { return (_leftmotor); }
  botMotor	*getRightMotor() { return (_rightmotor); }
  HMC6352	*getHMC6352() { return (_hmc); }
  directionSet	*getDirectionSet() { return (&_dir); }
  short		getNorth() { return (_north); }

private:
  botURM37	*_urm37;
  bool		_active;
  botMotor	*_leftmotor;
  botMotor	*_rightmotor;
  HMC6352	*_hmc;
  directionSet	_dir;
  unsigned char	_dirRetries;
  short		_dst;
  short		_north;
  botCmdLine	*_usbCmdLine;
  botCmdLine	*_toothCmdLine;
};

#endif /* !__NIXBOT_HH__ */
