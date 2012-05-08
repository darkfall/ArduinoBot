#include "../NixBot.hh"

// TOOLS

double		my_getnbr(char *str)
{
  double	res;

  if (*str == '-')
    return (-my_getnbr(str+1));
  for (res = 0; *str; str++)
    {
      res *= 10;
      res += *str - '0';
    }
  return (res);
}

// END TOOLS

bool		leftmotor(HardwareSerial *s, nixBOT *bot, char **args)
{
  char		speed;

  if (args[0] == 0 || args[1] == 0)
    return (false);
  speed = (char)(my_getnbr(args[1]));
  bot->getLeftMotor()->setDirection((speed < 0 ? false : true));
  bot->getLeftMotor()->setSpeed((speed < 0 ? -speed : speed));
  return (true);
}

bool		rightmotor(HardwareSerial *s, nixBOT *bot, char **args)
{
  char		speed;
  if (args[0] == 0 || args[1] == 0)
    return (false);
  speed = (char)(my_getnbr(args[1]));
  bot->getRightMotor()->setDirection((speed < 0 ? false : true));
  bot->getRightMotor()->setSpeed((speed < 0 ? -speed : speed));
  return (true);
}

bool		motors(HardwareSerial *s, nixBOT *bot, char **args)
{
  char		speedleft;
  char		speedright;

  if (args[0] == 0 || args[1] == 0 || args[2] == 0)
    return (false);
  speedleft = (char)(my_getnbr(args[1]));
  speedright = (char)(my_getnbr(args[2]));
  bot->getLeftMotor()->setDirection((speedleft < 0 ? false : true));
  bot->getLeftMotor()->setSpeed((speedleft < 0 ? -speedleft : speedleft));
  bot->getRightMotor()->setDirection((speedright < 0 ? false : true));
  bot->getRightMotor()->setSpeed((speedright < 0 ? -speedright : speedright));
  return (true);
}

bool		active(HardwareSerial *s, nixBOT *bot, char **args)
{
 if (args[0] != 0 && args[1] != 0)
   {
     if (strcmp(args[1], "on") == 0)
       bot->Activate(true);
     if (strcmp(args[1], "off") == 0)
       bot->Activate(false);
   }
 s->print("bot is ");
 s->println((bot->isActive() ? "active" : "inactive"));
 return (true);
}

bool		urmsetangle(HardwareSerial *s, nixBOT *bot, char **args)
{
  botURM37	*u;
  int		angle;

  if (!args[1])
    return (false);
  angle = my_getnbr(args[1]);
  if (angle > 180 || angle < 0)
    return (false);
  u = bot->getURM37();
  u->setangle(angle);
  s->println(((int)(u->getangle())));
  return (true);
}

bool		urmgetdistance(HardwareSerial *s, nixBOT *bot, char **args)
{
  botURM37	*u;
  int		angle;

  u = bot->getURM37();
  if (args[1])
    {
      angle = my_getnbr(args[1]);
      if (angle > 180 || angle < 0)
	return (false);
      u->setangle(angle);
      delay(500);
    }
  s->print(((int)(u->getangle())));
  s->print(":");
  s->println(u->getDistance());
  return (true);
}

bool		serial2(HardwareSerial *s, nixBOT *bot, char **args)
{
  char		c;
  double	baud;

  baud = 9600;
  if (args && args[1])
    baud = my_getnbr(args[1]);
  Serial2.begin(baud);
  s->print("Begin at ");
  s->println(baud);
  while (true)
    if (s->available() > 0)
      {
	if ((c = s->read()) == 29)
	  break ;
	if (c == '\r')
	  s->println("");
	else
	  s->print(c);
	Serial2.print(c);
      }
    else
      if (Serial2.available() > 0)
	{
	  if ((c = Serial2.read()) == '\r')
	    s->println("");
	  else
	    s->print(c);
	}
      else
	delay(50);
  Serial2.end();
  return (true);
}

bool		serial3(HardwareSerial *s, nixBOT *bot, char **args)
{
  char		c;

  if (args && args[1])
    Serial3.begin(my_getnbr(args[1]));
  else
    Serial3.begin(9600);
  s->print("Begin\n");
  while (true)
    if (s->available() > 0)
      {
	c = s->read();
	if (c == 29)
	  break ;
	if (c == '\r')
	  s->println("");
	else
	  s->print(c);
	Serial3.print(c);
      }
    else
      if (Serial3.available() > 0)
	{
	  if ((c = Serial3.read()) == '\r')
	    s->println("");
	  else
	    s->print(c);
	}
      else
	delay(50);
  Serial3.end();
  return (true);
}
