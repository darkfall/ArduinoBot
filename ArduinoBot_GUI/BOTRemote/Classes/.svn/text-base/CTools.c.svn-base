/*
 *  CTools.c
 *  BOTRemote
 *
 *  Created by nix on 26/12/10.
 *  Copyright 2010 Epitech. All rights reserved.
 *
 */

#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <termios.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include "CTools.h"

void	str_error(char *str)
{
	write(2, str, strlen(str));
	exit (-1);
}

void	*xmalloc(size_t size)
{
	void	*tmp;
	
	tmp = malloc(size);
	if (!tmp)
		str_error("Error in Malloc\n");
	return (tmp);
}

void	*xrealloc(void *ptr, size_t size)
{
	void	*tmp;
	
	tmp = realloc(ptr, size);
	if (!tmp)
		str_error("Error in Realloc\n");
	return (tmp);
}

void	xfree(void *ptr)
{
	free(ptr);
}

pid_t	xfork(void)
{
	pid_t	pid;
	
	pid = fork();
	if (pid == -1)
		str_error("Error in Fork\n");
	return (pid);
}
