
#include <WProgram.h>
#include <Wire/Wire.h>
#include "cppfix.hh"
#include "HMC6352.hh"

HMC6352::HMC6352(unsigned char powerpin)
{
  Wire.begin();
  _pwrpin = powerpin;
  _slaveaddr = HMC6352_ADDR >> 1;
  this->powerOn();
}

HMC6352::~HMC6352()
{
  
}

void
HMC6352::enterCalibration()
{
  Wire.beginTransmission(_slaveaddr);
  Wire.send((char *)("C"));
  Wire.endTransmission();
}

void
HMC6352::exitCalibration()
{
  Wire.beginTransmission(_slaveaddr);
  Wire.send((char *)("E"));
  Wire.endTransmission();
}

void
HMC6352::updateBridgeOffset()
{
  Wire.beginTransmission(_slaveaddr);
  Wire.send((char *)("O"));
  Wire.endTransmission();
}

void
HMC6352::powerOn()
{
  pinMode(_pwrpin, OUTPUT);
  digitalWrite(_pwrpin, HIGH); // Set to High
}

void
HMC6352::powerOff()
{
  digitalWrite(_pwrpin, LOW); // Set to Low
}

void
HMC6352::saveConfig()
{
  Wire.beginTransmission(_slaveaddr);
  Wire.send((char *)("L"));
  Wire.endTransmission();
}

void
HMC6352::wake()
{
  Wire.beginTransmission(_slaveaddr);
  Wire.send((char *)("W"));
  Wire.endTransmission();  
}

void
HMC6352::sleep()
{
  Wire.beginTransmission(_slaveaddr);
  Wire.send((char *)("S"));
  Wire.endTransmission();
}

short int
HMC6352::getHeading()
{
  char		i;
  unsigned char	data[2];
  short		res;

  Wire.beginTransmission(_slaveaddr);
  Wire.send((char *)("A"));              // The "Get Data" command
  Wire.endTransmission();
  delay(10);
  Wire.requestFrom(_slaveaddr, 2);        // Request the 2 byte heading (MSB comes first)
  i = 0;
  while(Wire.available() && i < 2)
    { 
      data[(byte)i] = ((unsigned char)(Wire.receive()));
      i++;
    }
  res = data[0]*256 + data[1];  // Put the MSB and LSB together
  return (res);
}

short int
HMC6352::getAngle()
{
  return ((short int)(this->getHeading() / 10));
}

bool
HMC6352::rotationSense()
{
  return (_rotation);
}

bool
HMC6352::rotationSense(bool rotation)
{
  return ((_rotation = rotation));
}

float
HMC6352::getDegree()
{
  return ((float)(this->getHeading() / 10.0));
}
