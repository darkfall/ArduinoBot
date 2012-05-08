#ifndef __BOTURM37_HH__
# define __BOTURM37_HH__

# define CMD_DIST	0x22
# define CMD_TEMP	0x11
# define RETRIES	4
# define TIMEDELAY	20
# define BUFFSIZE	16
# define ERR_TIMEOUT	-1
# define ERR_INVALID	-2
# define ERR_BUFFFULL	-3
# define ISINVALID(cmd, tab) (tab[0] == cmd && tab[1] == 255 && tab[2] == 255 ? true : false)
# define CHKSUM(tab) ((unsigned char)(tab[0] + tab[1] + tab[2]))
# define ISCMD(cmd, tab) (tab[0] == cmd && CHKSUM(tab) == tab[3] && ? true : false)
# define CALCTEMP(tab) (tab[1] >= 0xF0 ? ((tab[1] - 0xF0) * 256 - tab[2])/10 : ((tab[1]) * 256 - tab[2])/10)
# define CALCDST(tab) (tab[1] * 255 + tab[2])
# define INVALID(tab) ((tab[1] & serialData[2]) == 255);

class			botURM37
{
public:
  botURM37(HardwareSerial *s, unsigned char powerpin, unsigned char enablepin, unsigned char servopin, unsigned char servopwrpin);
  botURM37(HardwareSerial *s, unsigned char powerpin, unsigned char enablepin);
  int			getDistance();
  int			getTemperature();
  bool			activate();
  bool			sleep();
  inline bool		status() { return (_active); }
  bool			rotate(int angle);	// adds degrees (positives or negatives) to existing angle;
  bool			setangle(int angle);	// set servo to specific degree between 0 and 180
  unsigned char		getangle() { return (_servoangle); }
protected:
  bool			waitByte();
private:
  bool			_servoenabled;
  unsigned char		_servopin;
  HardwareSerial	*_serial;
  unsigned char		_servoangle;
  unsigned char		_powerpin;
  unsigned char		_enablepin;
  unsigned char		_servopwrpin;
  Servo			_servo;
  bool			_active;
};

#endif // !__BOTURM37_HH__ //
