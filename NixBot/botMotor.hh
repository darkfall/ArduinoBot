#ifndef __BOTMOTOR_HH__
# define __BOTMOTOR_HH__

class botMotor
{
public:
  botMotor();
  botMotor(char speedpin, char dirpin);
  bool			begin(char speedpin, char dirpin);
  bool			setSpeed(unsigned char speed);
  unsigned char		getSpeed();
  bool			setDirection(bool dir);
  bool			getDirection();
private:
  char			_speedpin;
  char			_dirpin;
  bool			_dir;
  unsigned char		_speed;
  bool			_init;
};

#endif // !__BOTMOTOR_HH__
