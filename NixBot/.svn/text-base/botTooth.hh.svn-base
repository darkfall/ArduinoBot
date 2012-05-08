#ifndef __BOTTOOTH_HH__
# define __BOTTOOTH_HH__


# define BUFFLEN	64

class botTooth : public botCmdLine
{
public:
  botTooth(HardwareSerial *s, nixBOT *bot, unsigned char pwrpin = 0);
  void			configBTM();
  void			checkCmdLine();
  bool			isconnected() { return (_conn); }
private:
  nixBOT		*_bot() { return (this->p_getNixBOT()); }
  HardwareSerial	*_serial() { return (this->p_getSerial()); }
  unsigned char		_pwrpin;
  bool			_conn;
  char			_buff[BUFFLEN];
  unsigned short	_ptr;
};

#endif // !__BOTTOOTH_HH__
