#include "NixBot.hh"


directionSet::directionSet()
{
  _dirlist = 0;
}


bool
directionSet::addDistance(t_dir dir)
{
  t_dirlist	*l;

  if (_dirlist == 0)
    {
      this->_init(dir);
      return (true);
    }
  if (this->checkIfExist(dir.angle))
    return (false);
  l = this->_getEnd();
  if (l)
    {
      l->next = new t_dirlist;
      l->next->dir = dir;
      l->next->next = 0;
    }
  else
    {
      l = new t_dirlist;
      l->dir = dir;
      l->next = 0;
      _dirlist = l;
    }
  return (true);
}

bool
directionSet::addDistance(short angle, short distance)
{
  t_dirlist	*l;

  if (_dirlist == 0)
    {
      t_dir	dir;
      dir.angle = angle;
      dir.distance = distance;
      this->_init(dir);
      return (true);
    }
  if (this->checkIfExist(angle))
    return (false);
  l = this->_getEnd();
  if (l)
    {
      l->next = new t_dirlist;
      l->next->dir.angle = angle;
      l->next->dir.distance = distance;
      l->next->next = 0;
    }
  else
    {
      l = new t_dirlist;
      l->dir.angle = angle;
      l->dir.distance = distance;
      l->next = 0;
      _dirlist = l;
    }
  return (true);
}

t_dir
directionSet::getDistance(short angle)
{
  t_dirlist	*l;
  t_dir		tmp;

  for (l = _dirlist, tmp.angle = 0, tmp.distance = 0; l != 0; l = l->next)
    if (l->dir.angle == angle)
      return (l->dir);
  return (tmp);
}

t_dir
directionSet::getOptimal(short angle, short offset)
{
  t_dirlist	*l;
  t_dir		tmp;

  tmp.distance = 0;
  tmp.angle = 0;
  if (angle >= 0)
    {
      for (l = _dirlist; l != 0; l = l->next)
	{
	  if (((l->dir.angle - angle) >= 0 && (l->dir.angle - angle) <= offset) || ((l->dir.angle - angle) < 0 && (l->dir.angle - angle) >= -(offset)))
	    {
	      if (l->dir.distance >= tmp.distance)
		{
		  tmp.angle = l->dir.angle;
		  tmp.distance = l->dir.distance;
		}
	    }
	}
    }
  else
    {
      for (l = _dirlist; l != 0; l = l->next)
	{
	  if (l->dir.distance > tmp.distance)
	    {
	      tmp.angle = l->dir.angle;
	      tmp.distance = l->dir.distance;
	    }
	  //	  PRINTDBG("OPTIMAL LOOP");
	}
    }
  return (tmp);
}

t_dirlist *
directionSet::_getEnd()
{
  t_dirlist	*l;

  for ( l = _dirlist; l && l->next != 0; l = l->next)
    ;
  return (l);
}

bool
directionSet::checkIfExist(short angle)
{
  t_dirlist	*l;

  for (l = _dirlist; l != 0; l = l->next)
    {
      if (l->dir.angle == angle)
	return (true);
    }
  return (false);
}

void
directionSet::clearSet()
{
  t_dirlist	*l;
  t_dirlist	*next;

  l = _dirlist;
  while(l != 0)
    {
      next = l->next;
      delete (l);
      l = next;
    }
  _dirlist = 0;
}

void
directionSet::_init(t_dir dir)
{
  _dirlist = new t_dirlist;
  _dirlist->dir = dir;
  _dirlist->next = 0;
}
