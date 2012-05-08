#ifndef __BOTCMDLINE_HH__
# define __BOTCMDLINE_HH__

# include "Tools/CmdFunc.hh"


class	botCmdLine
{
public:
  botCmdLine(HardwareSerial *s, nixBOT *bot);
  ~botCmdLine() { free(_line); }
  void			checkCmdLine();
  HardwareSerial	*cmdSerial();

protected:
  HardwareSerial	*p_getSerial() { return (_serial); }
  nixBOT		*p_getNixBOT() { return (_bot); }

private:
  bool			_readLine();
  void			_clearLine();
  void			_prompt();
  bool			_interpreteLine();
  nixBOT		*_bot;
  HardwareSerial	*_serial;
  char			*_line;
  short			_endline;
  short			_linelen;
  t_menulist		*_actualmenu;
};


#endif // !__BOTCMDLINE_HH__
