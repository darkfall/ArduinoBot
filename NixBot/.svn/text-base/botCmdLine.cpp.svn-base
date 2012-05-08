
#include "NixBot.hh"
#include "botCmdLine.hh"

t_cmdfunc       gl_pilot[] = {
  { "leftmotor", "set/display speed for left motor ex: leftmotor [-100 => 100]", leftmotor },
  { "rightmotor", "set/display speed for right motor ex: rightmotor [-100 => 100]", rightmotor },
  { "motors", "set/display speed for both left and right motors ex: motors [left: -100 => 100] [right: -100 => 100]", motors },
  { "urmangle", "set the angle of the URM37 head, ex: urmangle <angle>", urmsetangle },
  { "urmdistance", "returns the distance, and, if specified, sets the angle of the URM37 head before getting distance, ex: urmdistance [angle]", urmgetdistance },
  {0, 0, 0}
};

t_cmdfunc	gl_status[] = {
  {"active", "set/display if bot is active, ex: active [on,off]", active},
  {0, 0, 0}
};

t_cmdfunc	gl_comm[] = {
  {"serial2", "open serial connection with Serial2, default baud 9600 ex: serial2 [baud]", serial2},
  {"serial3", "open serial connection with Serial3, default baud 9600 ex: serial3 [baud]", serial3},
  {0, 0, 0}
};

t_menulist      gl_submenu1[] = {
  { "pilot", "functions to drive the nixBOT", gl_pilot, 0},
  { "status", "different status of the nixBOT himself or one of its parts", gl_status, 0},
  { "comm", "communication function to dialog with different hardware, serials etc ...", gl_comm, 0},
  {0, 0, 0, 0}
};


t_menulist      gl_main_menu[] = {
  { "main menu", "type list/help to see", 0, gl_submenu1},
  {0, 0, 0, 0}
};

botCmdLine::botCmdLine(HardwareSerial *s, nixBOT *bot)
{
  _bot = bot;
  _serial = s;
  _linelen = 16;
  _endline = 0;
  _line = (char *)(xmalloc(sizeof(*_line) * (_linelen + 1)));
  memset(_line, 0, _linelen);
  _actualmenu = gl_main_menu;
  this->_prompt();
}


HardwareSerial *
botCmdLine::cmdSerial()
{
  return (this->_serial);
}

void
botCmdLine::_clearLine()
{
  free(_line);
  _linelen = 16;
  _endline = 0;
  _line = (char *)(xmalloc(sizeof(*_line) * (_linelen + 1)));
  memset(_line, 0, _linelen);
}

bool
botCmdLine::_readLine()
{
  while (_serial->available())
    {
      _line[_endline] = _serial->read();
      //      CMDSERIAL.println(_line[_endline], DEC);
      if (_line[_endline] == 0x08 && _endline > 0)
	{
	  _serial->print('\b');
	  _serial->print(' ');
	  _serial->print('\b');
	  _endline = _endline - 1;
	  break ;
	}
      _serial->print(_line[_endline]);
      if (_line[_endline] == '\r')
	{
	  _serial->println("");
	  return (true);
	}
      _endline++;
      if (_endline >= _linelen)
	{
	  _linelen *= 2;
	  char *tmp = (char *)(xmalloc(sizeof(*tmp) * (_linelen + 1)));
	  memset(tmp, 0, _linelen);
	  memcpy(tmp, _line, sizeof(*_line) * (_endline));
	  free(_line);
	  this->_line = tmp;
	}
    }
  return (false);
}

void
botCmdLine::checkCmdLine()
{
  if (this->_readLine())
    {
      //      PRINTDBG("INTERPRETING");
      this->_interpreteLine();
      //      PRINTDBG("CLEARING");
      this->_clearLine();
      //      PRINTDBG("PROMPTING");
      this->_prompt();
    }

}

bool
botCmdLine::_interpreteLine()
{
  int		i;
  int		c;
  char		**args;
  t_menulist	*t;
  t_cmdfunc	*f;

  if (this->_endline <= 1)
    return (false);
  for (i = 0, c = 0; i <= this->_endline; i++)
    if (this->_line[i] == ' ' || this->_line[i] == '\r' || this->_line[i] == '\n' || this->_line[i] == '\t')
      {
	this->_line[i] = 0;
	c++;
      }
  args = (char **)(xmalloc(sizeof(*args) * (c + 2)));
  memset(args, 0, sizeof(*args) * (c + 2));
  for (i = 0; this->_line[i] == 0 && i <= this->_endline; i++)
    ;
  args[0] = ((this->_line) + i);
  for (i = 0, c = 1; i <= this->_endline; i++)
    if (this->_line[i] == 0 && this->_line[i + 1])
      {
	args[c] = ((this->_line) + i + 1);
	c++;
      }
  for (t = _actualmenu->next; t && t->name; t++)
    if ((i = strcmp(t->name, args[0])) == 0)
      {
	_actualmenu = t;
	break ;
      }
  for (f = _actualmenu->cmdfunc; f && f->name; f++)
    if ((i = strcmp(f->name, args[0])) == 0)
      {
	f->fct(this->_serial, _bot, args);
	break ;
      }
  if (strcmp(args[0], "up") == 0 || strcmp(args[0], "end") == 0 || strcmp(args[0], "exit") == 0 || strcmp(args[0], "main") == 0)
    _actualmenu = gl_main_menu;
  if (strcmp(args[0], "list") == 0 || strcmp(args[0], "help") == 0)
    {
      _serial->println("Functions: ");
      _serial->println("");
      if (_actualmenu->cmdfunc)
	for (f = _actualmenu->cmdfunc; f && f->name; f++)
	  {
	    _serial->print(f->name);
	    _serial->print(": ");
	    _serial->println(f->help);
	  }
      else
	_serial->println("No Functions available on this menu\r\n\r\n");
      _serial->println("Menus: ");
      _serial->println("");
      if (_actualmenu->next)
	for (t = _actualmenu->next; t && t->name; t++)
	  {
	    _serial->print(t->name);
	    _serial->print(": ");
	    _serial->println(t->help);
	  }
      else
	_serial->println("No sub menus available on this menu\r\n\r\n");
    }
  free(args);
  return (true);
}

void
botCmdLine::_prompt()
{
  _serial->print("[nixBOT: ");
  _serial->print(_actualmenu->name);
  _serial->print(" ]> ");
}
