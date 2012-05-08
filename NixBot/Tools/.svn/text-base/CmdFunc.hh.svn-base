#ifndef __CMDFUNC_HH__
# define __CMDFUNC_HH__

class nixBOT;

bool	leftmotor(HardwareSerial *s, nixBOT *bot, char **args);
bool	rightmotor(HardwareSerial *s, nixBOT *bot, char **args);
bool	motors(HardwareSerial *s, nixBOT *bot, char **args);
bool	active(HardwareSerial *s, nixBOT *bot, char **args);
bool    serial2(HardwareSerial *s, nixBOT *bot, char **args);
bool    serial3(HardwareSerial *s, nixBOT *bot, char **args);
bool    urmsetangle(HardwareSerial *s, nixBOT *bot, char **args);
bool	urmgetdistance(HardwareSerial *s, nixBOT *bot, char **args);


double     my_getnbr(char *str);
typedef struct	s_cmdfunc
{
  char	        *name;
  char		*help;
  bool		(*fct)(HardwareSerial *s, nixBOT *bot, char **args);
}		t_cmdfunc;

typedef struct		s_menulist
{
  char			*name;
  char			*help;
  t_cmdfunc		*cmdfunc;
  struct s_menulist	*next;
}			t_menulist;

#endif /* !__CMDFUNC_HH__ */
