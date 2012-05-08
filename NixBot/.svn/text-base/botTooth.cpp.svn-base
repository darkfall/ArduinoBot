
#include "NixBot.hh"
#include "botCmdLine.hh"

botTooth::botTooth(HardwareSerial *s, nixBOT *bot, unsigned char pwrpin) : botCmdLine(s, bot)
{
  _pwrpin = pwrpin;
  _ptr = 0;
  memset(_buff, 0, BUFFLEN);
}

void
botTooth::configBTM()
{

}

void
botTooth::checkCmdLine()
{
  if (_ptr > BUFFLEN)
    {
      _ptr = 0;
      memset(_buff, 0, BUFFLEN);
    }  
  while (this->_serial()->available() && _ptr < BUFFLEN)
    {
      _buff[_ptr] = this->_serial()->read();
      _ptr++;
    }
}
