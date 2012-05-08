#ifndef __DIRECTIONSET_HH__
# define __DIRECTIONSET_HH__

typedef struct	s_dir
{
  short		angle;
  short		distance;
}		t_dir;

typedef struct		s_dirlist
{
  t_dir			dir;
  struct s_dirlist	*next;
}			t_dirlist;

class		directionSet
{
public:
  directionSet();						// Contructor: initialises variables

  void		clearSet();

  bool		addDistance(t_dir dir);				// add a direction info (t_dir structure) to chained list

  bool		addDistance(short angle, short distance);	// add a direction info (couple angle/distance) to chained list
    
  t_dir		getDistance(short angle);			// returns the couple angle/distance for the closest angle of the one passed in argument

  t_dir		getOptimal(short angle = -1, short offset = 10);// without arguments, returns the stored angle with the biggest distance. With arguments,
								// it returns the biggest distance for specified angle on the remaining angle offset.
protected:
  bool		checkIfExist(short angle);

private:
  t_dirlist		*_getEnd();
  void			_init(t_dir dir);
  t_dirlist		*_dirlist;				// pointer to the direction list
};

#endif /* !__DIRECTIONSET_HH__ */
