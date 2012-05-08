#include "NixBot.hh"

botMotor::botMotor()
{
  _init = false;
}

botMotor::botMotor(char speedpin, char dirpin)
{
  _speedpin = speedpin;
  _dirpin = dirpin;
  pinMode(_speedpin, OUTPUT);
  pinMode(_dirpin, OUTPUT);
  _init = true;
  _dir = true;
  _speed = 0;
}

bool
botMotor::begin(char speedpin, char dirpin)
{
  if (_init)
    return (false);
  _speedpin = speedpin;
  _dirpin = dirpin;
  pinMode(_speedpin, OUTPUT);
  pinMode(_dirpin, OUTPUT);
  _init = true;
  _dir = true;
  _speed = 0;
  return (true);
}

bool
botMotor::setSpeed(unsigned char speed)
{
  if (_init == false)
    return (false);
  analogWrite(_speedpin, speed);
  _speed = speed;
  return (true);
}

unsigned char
botMotor::getSpeed()
{
  if (_init == false)
    return (false);
  return (_speed);
}

bool
botMotor::setDirection(bool dir)
{
  if (_init == false)
    return (false);
  digitalWrite(_dirpin, (dir == true ? LOW : HIGH));
  _dir = dir;
  return (true);
}

bool
botMotor::getDirection()
{
  if (_init == false)
    return (false);
  return (_dir);
}
