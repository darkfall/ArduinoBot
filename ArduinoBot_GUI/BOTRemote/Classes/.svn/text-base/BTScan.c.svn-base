/*
 *  BTScan.c
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
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <string.h>
#include <btstack/btstack.h>
#include "CTools.h"
#include "BTScan.h"
#include "BTLayer.h"

t_glfunc	glfunc[] = {
  {L2CAP_DATA_PACKET, {0x03, BT_RFCOMM_UA, -1, -1}, 4, rfcomm_ack1},
  {L2CAP_DATA_PACKET, {-1, BT_RFCOMM_UIH, -1, BT_RFCOMM_PN_RSP}, 14, rfcomm_uih_nego},
  {L2CAP_DATA_PACKET, {((RFCOMM_CHANNEL_ID << 3) | 3), BT_RFCOMM_UA, -1, -1}, 4, rfcomm_ack2},
  {L2CAP_DATA_PACKET, {-1, BT_RFCOMM_UIH, -1, BT_RFCOMM_MSC_CMD}, 8, rfcomm_msc_cmd},
  {L2CAP_DATA_PACKET, {-1, BT_RFCOMM_UIH, -1, BT_RFCOMM_MSC_RSP}, 8, rfcomm_msc_rsp},
  {L2CAP_DATA_PACKET, {((RFCOMM_CHANNEL_ID<<3)|1), BT_RFCOMM_UIH, -1, -1}, -1, rfcomm_received_data},
  {L2CAP_DATA_PACKET, {((RFCOMM_CHANNEL_ID<<3)|1), BT_RFCOMM_UIH_PF, -1, -1}, -1, rfcomm_received_data},
  {HCI_EVENT_PACKET, {BTSTACK_EVENT_POWERON_FAILED, -1, -1, -1}, -1, hci_poweron_failed},
  {HCI_EVENT_PACKET, {BTSTACK_EVENT_STATE, -1, HCI_STATE_WORKING, -1}, -1, hci_working},
  {HCI_EVENT_PACKET, {HCI_EVENT_LINK_KEY_REQUEST, -1, -1, -1}, -1, hci_link_key_request},
  {HCI_EVENT_PACKET, {HCI_EVENT_PIN_CODE_REQUEST, -1, -1, -1}, -1, hci_pin_code_request},
  {HCI_EVENT_PACKET, {L2CAP_EVENT_CHANNEL_OPENED, -1, -1, -1}, -1, hci_connected},
  {HCI_EVENT_PACKET, {HCI_EVENT_DISCONNECTION_COMPLETE, -1, -1, -1}, -1, hci_disconnected},
  {HCI_EVENT_PACKET, {HCI_EVENT_COMMAND_COMPLETE, -1, -1, -1}, -1, hci_command_completed},
  {HCI_EVENT_PACKET, {HCI_EVENT_INQUIRY_RESULT, -1, -1, -1}, -1, hci_inquiry_result},
  {HCI_EVENT_PACKET, {HCI_EVENT_INQUIRY_RESULT_WITH_RSSI, -1, -1, -1}, -1, hci_inquiry_result},
  {HCI_EVENT_PACKET, {BTSTACK_EVENT_REMOTE_NAME_CACHED, -1, -1, -1}, -1, btstack_remote_name},
  {HCI_EVENT_PACKET, {HCI_EVENT_REMOTE_NAME_REQUEST_COMPLETE, -1, -1, -1}, -1, hci_name_request},
  {HCI_EVENT_PACKET, {HCI_EVENT_INQUIRY_COMPLETE, -1, -1, -1}, -1, hci_inquiry_complete},

  {0, 0, 0, 0}
};

t_btmanager		*bt_accessor(t_btmanager *tmp)
{
  static t_btmanager	*bt_tmp = 0;

  if (tmp)
    bt_tmp = tmp;
  return (bt_tmp);
}

int				btscan_count_node(t_device *root)
{
	t_device *t;
	int				i;
	
	for (i = 0, t = root; t; t = t->next)
		i++;
	return (i);
}

t_device	*btscan_find_node(t_device *root, bd_addr_t  address)
{
  t_device *t;
  
  for (t = root; t; t = t->next)
    if (BD_ADDR_CMP(address, t->address) == 0)
      return (t);
  return (0);
}

t_device	*btscan_add_node(t_device *root, t_device *new)
{
  t_device *tmp;
  t_device *t;

  tmp = xmalloc(sizeof(*tmp));
  memcpy(tmp, new, sizeof(*tmp));
  tmp->next = 0;
  for (t = root; t && t->next; t = t->next);
  if (t)
    t->next = tmp;
  else
    root = tmp;
  return (root);
}

void	bt_scan_clear_chain(t_device *root)
{
	if (root == 0)
		return ;
	if (root->next)
	{
		bt_scan_clear_chain(root->next);
		free (root);
	}
	else
	{
		free (root);
	}

}

t_device	*btscan_getdevices()
{
	return ((bt_accessor(0) ? bt_accessor(0)->root : 0));
}

void			bt_packet_handler(uint8_t packet_type, uint16_t channel, uint8_t *packet, uint16_t size)
{
	int			i;
	uint8_t send_creds = 0;

	printf("Received packet, trying match\n packet_type %x \n", packet_type);
	for (i = 0; glfunc[i].fct; i++)
	  {
	    /*	    printf("\nComparing: packet_type %x to %x packet[0] %x to %x packet[1] %x to %x packet[2] %x to %x packet[3] %x to %x\n\n\n",
		   packet_type, glfunc[i].packet_type,
		   packet[0], glfunc[i].packet[0],
		   packet[1], glfunc[i].packet[1],
		   packet[2], glfunc[i].packet[2],
		   packet[3], glfunc[i].packet[3]);*/
	    if (packet_type == glfunc[i].packet_type &&
					(packet[0] == glfunc[i].packet[0] || glfunc[i].packet[0] == -1) &&
					(packet[1] == glfunc[i].packet[1] || glfunc[i].packet[1] == -1) &&
					(packet[2] == glfunc[i].packet[2] || glfunc[i].packet[2] == -1) &&
					(packet[3] == glfunc[i].packet[3] || glfunc[i].packet[3] == -1) &&
					(size == glfunc[i].size || glfunc[i].size == -1))
	      {
					printf("Matched, now running fct...\n");
					if (glfunc[i].fct(packet, size))
						printf("Unhandled packet\n");
					break ;
	      }
	  }
	if (glfunc[i].fct == 0)
	  {
	    printf("Unmatched packet !!!\n");
	    //bt_end();
	    //exit (1);
	  }
	if (bt_accessor(0)->connflags.credits_used >= NR_CREDITS)
	{
		send_creds = 1;
		bt_accessor(0)->connflags.credits_used -= NR_CREDITS;
	}
	if (bt_accessor(0)->connflags.msc_resp_send && bt_accessor(0)->connflags.msc_resp_received)
	{
		send_creds = 1;
		bt_accessor(0)->connflags.msc_resp_send = 0;
		bt_accessor(0)->connflags.msc_resp_received = 0;
		bt_accessor(0)->connectdone = 1;
		printf("RFCOMM Connected\n");
	}
	if (send_creds)
	{
		// send 0x30 credits
		uint8_t initiator = 1;
		uint8_t address = (1 << 0) | (initiator << 1) |  (initiator << 1) | (RFCOMM_CHANNEL_ID << 3); 
		rfcomm_send_packet(bt_accessor(0)->connflags.source_cid, address, BT_RFCOMM_UIH_PF, NR_CREDITS, NULL, 0);
	}
}

int	bt_begin()
{
  int err;
  t_btmanager	*bt;

  bt = xmalloc(sizeof(*bt));
  memset(bt, 0, sizeof(*bt));
	bt->buffers.outbuff = xmalloc(1024 * sizeof(*(bt->buffers.outbuff)));
  memset(bt->buffers.outbuff, 0, 1024 * sizeof(*(bt->buffers.outbuff)));
  bt_accessor(bt);
	run_loop_init(RUN_LOOP_COCOA);
	//  run_loop_init(RUN_LOOP_POSIX);
  if ((err = bt_open()))
    {
      printf("Failed to open connection to BTdaemon\n");
      return (1);
    }
  return (0);
}

int	bt_scan()
{
  bt_accessor(0)->status = 1;
	printf("registering hooks ...\n");
  bt_register_packet_handler(bt_packet_handler);
  bt_send_cmd(&btstack_set_power_mode, HCI_POWER_ON);
  printf("starting scan ...\n");
  bt_send_cmd(&hci_inquiry, HCI_INQUIRY_LAP, INQUIRY_INTERVAL, 0);
		//  run_loop_execute();
  return (0);
}


int bt_end()
{
	if (bt_accessor(0)->connflags.con_handle)
		bt_send_cmd(&hci_disconnect, bt_accessor(0)->connflags.con_handle, 0x03);    
	bt_send_cmd(&btstack_set_power_mode, HCI_POWER_OFF);
	bt_close();	
	bt_scan_clear_chain(bt_accessor(0)->root);
	free(bt_accessor(0));
	return (0);
}

int	bt_scandone()
{
	return (bt_accessor(0)->scandone);
}

int bt_connectdone()
{
	return (bt_accessor(0)->connectdone);	
}


int	bt_rfcomm_connect(t_device *t, const char *pin)
{
	bt_accessor(0)->status = 2;
	memcpy(bt_accessor(0)->pin, pin, (strlen(pin) > 4 ? 4 : strlen(pin)));
	memcpy(&(bt_accessor(0)->addr), t->address, sizeof(bd_addr_t));
	bt_send_cmd(&btstack_set_power_mode, HCI_POWER_ON);
	return (0);
}

int	bt_rfcomm_disconnect()
{
	bt_accessor(0)->status = 1;
	if (bt_accessor(0)->connflags.con_handle)
		bt_send_cmd(&hci_disconnect, bt_accessor(0)->connflags.con_handle, 0x03);
	memset(&(bt_accessor(0)->connflags), 0, sizeof(bt_accessor(0)->connflags));
	if (bt_accessor(0)->buffers.inbuff)
	{
		free(bt_accessor(0)->buffers.inbuff);
		bt_accessor(0)->buffers.inbuff = 0;	
	}
	bt_accessor(0)->buffers.inbuff_len = 0;
	if (bt_accessor(0)->buffers.outbuff)
	{
		free(bt_accessor(0)->buffers.outbuff);
		bt_accessor(0)->buffers.outbuff = 0;
	}
	bt_accessor(0)->buffers.outbuff_len = 0;
	bt_accessor(0)->connectdone = 0;
	return (0);
}

void	*bt_rfcomm_receive(unsigned int *size)
{
	void *tmp;
	
	tmp = bt_accessor(0)->buffers.inbuff;
	bt_accessor(0)->buffers.inbuff = 0;
	*size = bt_accessor(0)->buffers.inbuff_len;
	bt_accessor(0)->buffers.inbuff_len = 0;
	return(tmp);
}

int	bt_rfcomm_send(void *data, uint16_t len)
{
	if (bt_accessor(0)->status != 2)
		return (1);
	_bt_rfcomm_send_uih_data(bt_accessor(0)->connflags.source_cid, 1, RFCOMM_CHANNEL_ID, data, len);
	return (0);
}

int	bt_rfcomm_send_string(const char *str)
{
	return(bt_rfcomm_send((void *)str, strlen(str)));
}


t_device	*bt_getdevicebyname(char *name)
{
  t_device *t;
	
  for (t = bt_accessor(0)->root; t; t = t->next)
    if (strcmp(name, t->name) == 0)
      return (t);
  return (0);
}


t_device	*bt_getdevicebymac(bd_addr_t address)
{
  t_device *t;

  for (t = bt_accessor(0)->root; t; t = t->next)
    if (BD_ADDR_CMP(address, t->address) == 0)
      return (t);
  return (0);
}

