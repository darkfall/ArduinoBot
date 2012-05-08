#include "NixBot.hh"
#include "botCmdLine.hh"

void initbutton();

nixBOT::nixBOT()
{
  _urm37 = new botURM37(&URMSERIAL, URMPWRPIN, URMENABLEPIN, URMSERVOPIN, URMSERVOPWRPIN); 
  _active = false;
//  attachInterrupt(INITINTR, &initbutton, RISING);
  _leftmotor = new botMotor(LEFTMOTORSPEEDPIN, LEFTMOTORDIRPIN);
  _rightmotor = new botMotor(RIGHTMOTORSPEEDPIN, RIGHTMOTORDIRPIN);
  _hmc = new HMC6352(HMCPWRPIN);
  _dirRetries = 0;
  _usbCmdLine = new botCmdLine(&CMDSERIAL, this);
  Serial2.begin(115200);
  _toothCmdLine = new botCmdLine(&Serial2, this);
#ifdef DEBUGMODE
  DEBUGINIT;
#endif
}

bool
nixBOT::localize()
{
//  int	dst;
//  short	angle;

//   PRINTDBG("Asking Angle");
  this->_north = this->_hmc->getAngle();
//   PRINTDBG("Angle to north is ");
//   PRINTDBG(angle);
//   PRINTDBG(" Degree");
//  dst = _urm37->getDistance();
//  PRINTDBG(dst);
  return (true);
}

bool
nixBOT::getDirection(t_dir *dir)
{
  dir = dir;
  return (true);
}

bool
nixBOT::goAhead()
{
  _leftmotor->setSpeed(60);
  _rightmotor->setSpeed(60);
  return (true);
}

bool
nixBOT::stop()
{
  _leftmotor->setSpeed(0);
  _rightmotor->setSpeed(0);
  return (true);
}


bool
nixBOT::forward()
{
  this->_dirRetries = 0;
  this->goAhead();
  while (this->_urm37->getDistance() > MINDIST)
    delay(200);
  this->stop();
  return (true);
}

void
nixBOT::cmdLines()
{
  this->_usbCmdLine->checkCmdLine();
  if (this->_toothCmdLine)
    this->_toothCmdLine->checkCmdLine();
}

void
nixBOT::initSensors()
{
  int	k;
  short	angles[2];
  bool	sense;

  // HMC Init
  //  PRINTDBG("INIT\n");
  this->_hmc->enterCalibration();
  this->_leftmotor->setDirection(false);		// we need to make approximatively 2 rotations
  this->_rightmotor->setDirection(true);		// of the entire robot during 20 sec.
  this->_leftmotor->setSpeed(70);
  this->_rightmotor->setSpeed(70);
  delay(10000);
  this->_rightmotor->setSpeed(0);
  this->_leftmotor->setSpeed(0);
  this->_leftmotor->setDirection(true);		// Inverting
  this->_rightmotor->setDirection(false);		// Rotation
  this->_leftmotor->setSpeed(70);
  this->_rightmotor->setSpeed(70);
  delay(10000);
  this->_rightmotor->setSpeed(0);
  this->_leftmotor->setSpeed(0);
  this->_rightmotor->setDirection(true);		// re establishing forward state
  this->_hmc->exitCalibration();
  this->_hmc->saveConfig();
  // End HMC Init
  // One HMC is init, need to find the rotation angle increase sense
  this->_leftmotor->setDirection(true);		// Inverting
  this->_rightmotor->setDirection(false);		// Rotation
  this->_leftmotor->setSpeed(50);
  this->_rightmotor->setSpeed(50);
  angles[0] = 0;
  angles[1] = 0;
  sense = true;
  k = 0;
  while (k < 3)
    {
      angles[0] = this->_hmc->getAngle();
      delay(100);
      angles[1] = this->_hmc->getAngle();
//       PRINTDBG("NORTH ROTATION ANGLES");
//       PRINTDBG(angles[0]);
//       PRINTDBG(angles[1]);
      if ((angles[0] - angles[1]) > 0 && sense == false)
	k++;
      if ((angles[0] - angles[1]) > 0 && sense == true)
	{
	  k = 0;
	  sense = false;
	}
      if ((angles[0] - angles[1]) < 0 && sense == true)
	k++;
      if ((angles[0] - angles[1]) < 0 && sense == false)
	{
	  k = 0;
	  sense = true;
	}
    }
  this->_rightmotor->setSpeed(0);
  this->_leftmotor->setSpeed(0);
  this->_rightmotor->setDirection(true);	// re establishing forward state
  this->_leftmotor->setDirection(true);		// re establishing forward state
  //   PRINTDBG((sense == true ? "SENSE IS TRUE" : "SENSE IS FALSE" ));
  this->_hmc->rotationSense(sense);
}

void
nixBOT::initButtonPressed()
{
  this->_active = true;
}

void
nixBOT::scanDirections()
{
  int	i;
  int	dst;

  this->_dirRetries++;
  dst = this->_urm37->getDistance();
//   PRINTDBG("Distance is ");
//   PRINTDBG(dst);
  this->_dir.addDistance(90, dst);
  this->_urm37->setangle(0);
  delay(1000);
  for (i = 0; i <= 180; i += 20)
    {
      this->_urm37->setangle(i);
      delay (500);
      dst = _urm37->getDistance();
      this->_dir.addDistance(i, dst);
//       PRINTDBG("For angle");
//       PRINTDBG(i);
//       PRINTDBG("Distance is ");
//       PRINTDBG(dst);
    }
  this->_urm37->setangle(90);
}


bool
nixBOT::checkRetries()
{
  if (this->_dirRetries >= 4)
    return (true);
  return (false);
}

bool
nixBOT::setDirection()
{
  t_dir	res;
  short	angle;
  short diff;
  short	actual;
  short	goal;

  res = this->_dir.getOptimal();
//   PRINTDBG("OPTIMAL ANGLE");
//   PRINTDBG(res.angle);
//   PRINTDBG("OPTIMAL DISTANCE");
//   PRINTDBG(res.distance);
  this->_dir.clearSet();
  this->_dst = res.distance;
  angle = this->_hmc->getAngle();
  if (res.angle == 90)
    return (true);
  if (res.angle > 0 && res.angle < 90)
    {
      diff = 90 - res.angle;
      goal = (this->_hmc->rotationSense() ? ((angle + diff) % 360) : (angle - diff < 0 ? (angle + 360) - diff : angle - diff));
//       PRINTDBG("first condition, GOAL IS ");
//       PRINTDBG(goal);
      this->_leftmotor->setDirection(true);
      this->_rightmotor->setDirection(false);
      this->_leftmotor->setSpeed(50);
      this->_rightmotor->setSpeed(50);
      actual = this->_hmc->getAngle();
      while (!(actual >= (goal - 2) && actual <= (goal + 2)))
	actual = this->_hmc->getAngle();
    }
  if (res.angle > 90 && res.angle <= 180)
    {
      diff = res.angle - 90;
      goal = (this->_hmc->rotationSense() ? (angle - diff < 0 ? (angle + 360) - diff : angle - diff) : ((angle + diff) % 360));
//       PRINTDBG("second condition, GOAL IS ");
//       PRINTDBG(goal);
      this->_leftmotor->setDirection(false);
      this->_rightmotor->setDirection(true);
      this->_leftmotor->setSpeed(50);
      this->_rightmotor->setSpeed(50);
      actual = this->_hmc->getAngle();
      while (!(actual >= (goal - 2) && actual <= (goal + 2)))
	actual = this->_hmc->getAngle();
    }
  this->_leftmotor->setSpeed(0);
  this->_rightmotor->setSpeed(0);
  this->_leftmotor->setDirection(true);
  this->_rightmotor->setDirection(true);
  return (false);
}

//
// End Main Class code, now C like Arduino functions
//

nixBOT		*bot;

void initbutton()
{
  bot->initButtonPressed();
}


void	setup()
{
  bot = new nixBOT();
}

void	loop()
{
  bot->cmdLines();
  if (bot->isActive())
    {
      bot->initSensors();
      while (bot->isActive())
	{
	  bot->cmdLines();
	  bot->localize();
	  delay(500);
	  bot->scanDirections();
	  delay(1000);
	  if (bot->setDirection() || bot->checkRetries())
	    bot->forward();
	}
    }
  else
    {
      //     bot->stop();
      delay(10);
      //      delay(1000);
    }

//   char	c;

//   Serial.print("Begin\n");
//   while (true)
//     if (Serial.available() > 0)
//       {
// 	c = Serial.read();
// 	Serial.print(c);
// 	Serial2.print(c);
//       }
//     else
//       {
// 	if (Serial2.available() > 0)
// 	  {
// 	    Serial.print(Serial2.read());
// 	  }
// 	else
// 	  delay(200);
//       }
}
