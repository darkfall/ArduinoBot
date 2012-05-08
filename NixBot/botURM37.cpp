#include "NixBot.hh"

botURM37::botURM37(HardwareSerial *s, unsigned char powerpin, unsigned char enablepin, unsigned char servopin, unsigned char servopwrpin)
{
  _serial = s;
  _enablepin = enablepin;
  _powerpin = powerpin;
  pinMode(enablepin, OUTPUT);
  pinMode(powerpin, OUTPUT);
  _servopin = servopin;
  _servopwrpin = servopwrpin;
  pinMode(_servopwrpin, OUTPUT);
  digitalWrite(_servopwrpin, HIGH); // Set to High
  _servo.attach(_servopin);
  _servoenabled = true;
  _serial->begin(9600);
  this->activate();
}
botURM37::botURM37(HardwareSerial *s, unsigned char powerpin, unsigned char enablepin)
{
  _serial = s;
  pinMode(enablepin, OUTPUT);
  pinMode(powerpin, OUTPUT);
  _servoenabled = false;
  _serial->begin(9600);
  this->activate();
}


bool
botURM37::waitByte()
{
  int count = 0;

  while (_serial->available() <= 0 && count < RETRIES)
    {
      delay(TIMEDELAY);
      count++;
    }
  if (count >= RETRIES)
    return false;
  return (true);
}

int
botURM37::getDistance()
{
  uint8_t       data[4] = { 0x22, 0x00, 0x00, 0x22};
  int		count = 3;
  int		i;
  unsigned char	buffer[BUFFSIZE];
  int		res;

  for (i = 0; i < 4; i++)
    _serial->print(data[i], BYTE);
  delay(75);
  //  PRINTDBG("Distance Order Sent...");
  if (this->waitByte() == false)
    return (-1);
  i = 0;
  //  PRINTDBG("Will now loop for bytes...");
  while (count)
    if (_serial->available() > 0)
      {
	count = 3;
	//	PRINTDBG("READ: ");
	buffer[i] = _serial->read();
	//	PRINTDBG(((int)buffer[i]));
	i++;
	if (i > BUFFSIZE)
	  return (-3);
      }
    else
      {
	delay(TIMEDELAY);
	count--;
      }
//   PRINTDBG("DUMPING DATA:");
//   PRINTDBG(((int)buffer[0]));
//   PRINTDBG(((int)buffer[1]));
//   PRINTDBG(((int)buffer[2]));
//   PRINTDBG(((int)buffer[3]));
//   PRINTDBG("END DUMP");
  res = CALCDST(buffer);
  return (res);
}

int
botURM37::getTemperature()
{
  return (0); // Not Implemented for now
}

bool
botURM37::activate()
{
  digitalWrite(_enablepin, HIGH); // Set to High
  digitalWrite(_powerpin, HIGH); // Set to High
  _active = true;
  delay(200);
  return (true);
}

bool
botURM37::sleep()
{
  digitalWrite(_enablepin, LOW); // Set to High
  digitalWrite(_powerpin, LOW); // Set to High
  _active = false;
  return (true);
}

bool
botURM37::rotate(int angle)
{
  if (_servoenabled == false)
    return (false);
  _servoangle = (unsigned char)(((int)(_servoangle + angle)) >= 180 ? 180 : (((int)(_servoangle + angle)) < 0 ? 0 : ((int)(_servoangle + angle))));
  _servo.write(_servoangle);
  return (true);
}

bool
botURM37::setangle(int angle)
{
  if (_servoenabled == false)
    return (false);
  if (angle > 180 || angle < 0)
    return (false);
  _servoangle = angle;
  _servo.write(_servoangle);
  // CODE HERE !!
  return (true);
}




//   bool                  _servoEnabled;
//   unsigned char         _servoPin;
//   HardwareSerial        *_serial;
//   unsigned char_servoAngle;
