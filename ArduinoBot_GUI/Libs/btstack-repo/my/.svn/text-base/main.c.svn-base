#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <btstack/btstack.h>
#include "BTLayer.h"
#include "BTScan.h"
#include "CTools.h"


int	main(int argc, char **argv)
{
  printf("main::init...\n");
  bt_begin();
  printf("main::scan...\n");
  bt_scan();
  while (bt_scandone() == 0)
    {
      printf("waiting ...\n");
      sleep(1);
    }
  printf("main::end...\n");
  bt_end();
  return (0);
}
