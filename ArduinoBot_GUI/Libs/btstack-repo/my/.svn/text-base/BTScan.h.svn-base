/*
 *  BTScan.h
 *  BOTRemote
 *
 *  Created by nix on 26/12/10.
 *  Copyright 2010 Epitech. All rights reserved.
 *
 */


#define MAX_DEVICES 10
struct device {
	bd_addr_t  address;
	uint16_t   clockOffset;
	uint32_t   classOfDevice;
	uint8_t	   pageScanRepetitionMode;
	uint8_t    rssi;
	uint8_t    state; // 0 empty, 1 found, 2 remote name tried, 3 remote name found
};

typedef struct		s_device
{
	char		name[255];
	bd_addr_t	address;
	uint16_t	clockOffset;
	uint32_t	classOfDevice;
	uint8_t		pageScanRepetitionMode;
	uint8_t		rssi;
	uint8_t		state; // 0 empty, 1 found, 2 remote name tried, 3 remote name found
	struct s_device	*next;
}			t_device;

typedef struct	s_buffers
{
	void	*inbuff;
	int	inbuff_len;
	void	*outbuff;
	int	outbuff_len;
}		t_buffers;

typedef struct		s_flags
{
  uint16_t		source_cid;
  hci_con_handle_t	con_handle;
  uint8_t		msc_resp_send;
  uint8_t		msc_resp_received;
  uint8_t		credits_used;
  uint8_t		credits_free;	
}			t_flags;

typedef	struct	s_btmanager
{
  char		status;	// 0 init, 1 scan mode, 2 rfcomm connected mode
  char		pin[5];
  bd_addr_t	addr;
  t_buffers	buffers;
  t_flags	connflags;
  t_device	*root;
  char		scanretries;
	char		scandone;
}		t_btmanager;

typedef struct	s_glfunc
{
  unsigned char	packet_type;		// type of packet
  int		packet[4];		// first bytes to match on packet, -1 if no need of match
  int		size;			// size to match
  int		(*fct)(uint8_t *packet, uint16_t size);
}		t_glfunc;

#define INQUIRY_INTERVAL 5


void		bt_scan_clear_chain(t_device *root);
t_btmanager	*bt_accessor(t_btmanager *tmp);
t_device	*btscan_find_node(t_device *root, bd_addr_t  address);
t_device	*btscan_add_node(t_device *root, t_device *new);
t_device	*btscan_getdevices();
int		btscan_count_node(t_device *root);

	// "Public" Functions
int				bt_begin();
int				bt_scan();
t_device	*bt_getdevicebyname(char *name);
t_device	*bt_getdevicebymac(bd_addr_t address);
int				bt_scandone();
int				bt_end();


