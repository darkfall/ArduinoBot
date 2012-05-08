/*
 *  BTLayer.c
 *  BOTRemote
 *
 *  Created by nix on 26/12/10.
 *  Copyright 2010 Epitech. All rights reserved.
 *
 */

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

int	rfcomm_ack1(uint8_t *packet, uint16_t size)
{
	printf("Received RFCOMM unnumbered acknowledgement for channel 0 - multiplexer working\n");
	printf("Sending UIH Parameter Negotiation Command\n");
	_bt_rfcomm_send_uih_pn_command((bt_accessor(0)->connflags.source_cid), 1, RFCOMM_CHANNEL_ID, 100);	
	return (0);
}

int	rfcomm_ack2(uint8_t *packet, uint16_t size)
{
	printf("Received RFCOMM unnumbered acknowledgement for channel %u - channel opened\n", RFCOMM_CHANNEL_ID);
	printf("Sending MSC  'I'm ready'\n");
	_bt_rfcomm_send_uih_msc_cmd(bt_accessor(0)->connflags.source_cid, 1, RFCOMM_CHANNEL_ID, 0x8d);  // ea=1,fc=0,rtc=1,rtr=1,ic=0,dv=1	
	return (0);
}

int	rfcomm_uih_nego(uint8_t *packet, uint16_t size)
{
	printf("UIH Parameter Negotiation Response\n");
	printf("Sending SABM #%u\n", RFCOMM_CHANNEL_ID);
	_bt_rfcomm_send_sabm(bt_accessor(0)->connflags.source_cid, 1, RFCOMM_CHANNEL_ID);	
	return (0);
}

int	rfcomm_msc_cmd(uint8_t *packet, uint16_t size)
{
	printf("Received BT_RFCOMM_MSC_CMD\n");
	printf("Responding to 'I'm ready'\n");
		// fine with this
	uint8_t address = packet[0] | 2; // set response 
	packet[3]  = BT_RFCOMM_MSC_RSP;  //  "      "
	rfcomm_send_packet(bt_accessor(0)->connflags.source_cid, address, BT_RFCOMM_UIH, 0x30, (uint8_t*)&packet[3], 4);
	bt_accessor(0)->connflags.msc_resp_send = 1;
	return (0);
}

int	rfcomm_msc_rsp(uint8_t *packet, uint16_t size)
{
	bt_accessor(0)->connflags.msc_resp_received = 1;
	return (0);
}

int	rfcomm_received_data(uint8_t *packet, uint16_t size)
{	
	int length = size - (packet[0] == BT_RFCOMM_UIH ? 4 : 5);
	int start_of_data = (packet[0] == BT_RFCOMM_UIH ? 3 : 4);

	if (packet[0] == BT_RFCOMM_UIH_PF)
	{
		bt_accessor(0)->connflags.credits_used++;
		bt_accessor(0)->connflags.credits_free = packet[2];
	}
	bt_accessor(0)->buffers.inbuff = xmalloc(((bt_accessor(0)->buffers.inbuff ?
																						 strlen(bt_accessor(0)->buffers.inbuff) : 0)
																						+ length + 1) * sizeof(*packet));
	bt_accessor(0)->buffers.inbuff_len += length;
	memcpy(bt_accessor(0)->buffers.inbuff,  &packet[start_of_data], length * sizeof(*packet));
	return (0);
}

int	hci_poweron_failed(uint8_t *packet, uint16_t size)
{
	printf("HCI Init failed - make sure you have turned off Bluetooth in the System Settings\n");
	return (1);
}

int	hci_working(uint8_t *packet, uint16_t size)
{
  printf("PIKO?\n");
  if (bt_accessor(0)->status == 2)
    bt_send_cmd(&hci_write_authentication_enable, 1);
  if (bt_accessor(0)->status == 1)
    {
      printf("Init Scanning\n");
      bt_send_cmd(&hci_write_inquiry_mode, 0x01); // with RSSI
    }
  printf("PIO?\n");
  return (0);
}

int	hci_link_key_request(uint8_t *packet, uint16_t size)
{
  bd_addr_t event_addr;

  // link key request
  bt_flip_addr(event_addr, &packet[2]);
  bt_send_cmd(&hci_link_key_request_negative_reply, &event_addr);	
  return (0);
}

int	hci_pin_code_request(uint8_t *packet, uint16_t size)
{
  bd_addr_t event_addr;

  // inform about pin code request
  bt_flip_addr(event_addr, &packet[2]); 
  bt_send_cmd(&hci_pin_code_request_reply, &event_addr, 4, bt_accessor(0)->pin);
  printf("Please enter PIN %s on remote device\n", bt_accessor(0)->pin);
  return (0);
}

int	hci_connected(uint8_t *packet, uint16_t size)
{
  bd_addr_t event_addr;
	
  // inform about new l2cap connection
  bt_flip_addr(event_addr, &packet[3]);
  uint16_t psm = READ_BT_16(packet, 11); 
  bt_accessor(0)->connflags.source_cid = READ_BT_16(packet, 13); 
  bt_accessor(0)->connflags.con_handle = READ_BT_16(packet, 9);
  if (packet[2] == 0) {
    printf("Channel successfully opened: ");
    print_bd_addr(event_addr);
    printf(", handle 0x%02x, psm 0x%02x, source cid 0x%02x, dest cid 0x%02x\n",
	   bt_accessor(0)->connflags.con_handle, psm, bt_accessor(0)->connflags.source_cid,  READ_BT_16(packet, 15));
    
    // send SABM command on dlci 0
    printf("Sending SABM #0\n");
    _bt_rfcomm_send_sabm(bt_accessor(0)->connflags.source_cid, 1, 0);
  } else {
    printf("L2CAP connection to device ");
    print_bd_addr(event_addr);
    printf(" failed. status code %u\n", packet[2]);
    return (1);
  }
  return (0);
}

int	hci_disconnected(uint8_t *packet, uint16_t size)
{
  // connection closed -> quit test app
  printf("Basebank connection closed, exit.\n");
  return (0);
}

int	hci_command_completed(uint8_t *packet, uint16_t size)
{
  
  if (bt_accessor(0)->status == 2 && COMMAND_COMPLETE_EVENT(packet, hci_write_authentication_enable))
    bt_send_cmd(&l2cap_create_channel, bt_accessor(0)->addr, 0x03);
  if (bt_accessor(0)->status == 1 && COMMAND_COMPLETE_EVENT(packet, hci_write_inquiry_mode))
    {
      printf("Received HCI_COMMAND_COMPLETED, now running next ...\n");
      
    }
  return (0);
}

int	hci_inquiry_result(uint8_t *packet, uint16_t size)
{
  int numResponses;
  bd_addr_t addr;
  t_device	res;
  int				i;
  
  numResponses = packet[2];
  for (i=0; i< numResponses && btscan_count_node(bt_accessor(0)->root) < MAX_DEVICES;i++)
    {
      bt_flip_addr(addr, &packet[3+i*6]);
      if (btscan_find_node(bt_accessor(0)->root, addr))
	continue;
      memset(&res, 0, sizeof(res));
      memcpy(res.address, addr, 6);
      res.pageScanRepetitionMode =    packet [3 + numResponses*(6)         + i*1];
      res.classOfDevice = READ_BT_24(packet, 3 + numResponses*(packet[0] == HCI_EVENT_INQUIRY_RESULT_WITH_RSSI ?
							       (6+1+1) :
							       (6+1+1+1))+ i*3);
      res.clockOffset = READ_BT_16(packet, 3 + numResponses*(packet[0] == HCI_EVENT_INQUIRY_RESULT_WITH_RSSI ?
							     (6+1+1+3) :
							     (6+1+1+1+3)) + i*2) & 0x7fff;
      res.rssi  = (packet[0] == HCI_EVENT_INQUIRY_RESULT_WITH_RSSI ? packet [3 + numResponses*(6+1+1+3+2) + i*1] : 0);
      res.state = 1;
      printf("Device found: "); 
      print_bd_addr(addr);
      printf(" with COD: 0x%06x, pageScan %u, clock offset 0x%04x\n", res.classOfDevice, res.pageScanRepetitionMode, res.clockOffset);
      bt_accessor(0)->root = btscan_add_node(bt_accessor(0)->root, &res);
    }
  return (0);
}

int	btstack_remote_name(uint8_t *packet, uint16_t size)
{
  bd_addr_t addr;
  t_device	*t;
	
  bt_flip_addr(addr, &packet[3]);
  if ((t = btscan_find_node(bt_accessor(0)->root, addr)))
    if (packet[2] == 0 && t->name[0] == 0)
      {
	printf("Name: '%s'\n", &packet[9]);
	memcpy(t->name, &packet[9], (strlen((char *)(&packet[9])) < 254 ? strlen((char *)(&packet[9])) : 253));
	t->state = 3;
      }
  return (0);
}

int	hci_name_request(uint8_t *packet, uint16_t size)
{
  bd_addr_t addr;
  t_device	*t;
  
  bt_flip_addr(addr, &packet[3]);
  if ((t = btscan_find_node(bt_accessor(0)->root, addr)))
    if (packet[2] == 0 && t->name[0] == 0)
      {
				printf("Name: '%s'\n", &packet[9]);
				memcpy(t->name, &packet[9], (strlen((char *)(&packet[9])) < 254 ? strlen((char *)(&packet[9])) : 253));
				t->state = 3;
      }
  return (0);
}

int		hci_inquiry_complete(uint8_t *packet, uint16_t size)
{
  int		flg = 0;
  t_device	*t;

  printf("Inquiry scan done.\n");
  if (bt_accessor(0)->scanretries < 3)
    for (bt_accessor(0)->scanretries++, t = bt_accessor(0)->root; t; t = t->next)
      {
	printf("PIKO PIKO!\n");
	if (t->state == 2)
	  t->state = 1;
	if (t->name[0] == 0)
	  {
	    printf("Asking Name\n");
	    bt_send_cmd(&hci_remote_name_request, t->address, t->pageScanRepetitionMode, 0, t->clockOffset | 0x8000);
	    flg = 1;
	  }
      }
  else
    {
      printf("Max retries done, ending");
			bt_accessor(0)->scandone = 1;
//			bt_send_cmd(&btstack_set_power_mode, HCI_POWER_OFF);
			return (0);
    }
//  if (flg)
//	{
		bt_send_cmd(&hci_inquiry, HCI_INQUIRY_LAP, INQUIRY_INTERVAL, 0);
    bt_send_cmd(&hci_write_inquiry_mode, 0x01); // with RSSI
//	}
//  else
//	{
//		bt_accessor(0)->scandone = 1;
//		bt_send_cmd(&btstack_set_power_mode, HCI_POWER_OFF);
//	}
  return (0);
}

//
//
//

bd_addr_t addr = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; 
//int RFCOMM_CHANNEL_ID = 1;
char PIN[] = "0000";

int DEBUG = 0;

hci_con_handle_t con_handle;
uint16_t source_cid;
int fifo_fd;

// used to assemble rfcomm packets
uint8_t rfcomm_out_buffer[1000];

/**
 * @param credits - only used for RFCOMM flow control in UIH wiht P/F = 1
 */
void rfcomm_send_packet(uint16_t source_cid, uint8_t address, uint8_t control, uint8_t credits, uint8_t *data, uint16_t len){
	
	uint16_t pos = 0;
	uint8_t crc_fields = 3;
	
	rfcomm_out_buffer[pos++] = address;
	rfcomm_out_buffer[pos++] = control;
	
	// length field can be 1 or 2 octets
	if (len < 128){
		rfcomm_out_buffer[pos++] = (len << 1)| 1;     // bits 0-6
	} else {
		rfcomm_out_buffer[pos++] = (len & 0x7f) << 1; // bits 0-6
		rfcomm_out_buffer[pos++] = len >> 7;          // bits 7-14
		crc_fields++;
	}
	
	// add credits for UIH frames when PF bit is set
	if (control == BT_RFCOMM_UIH_PF){
		rfcomm_out_buffer[pos++] = credits;
	}
	
	// copy actual data
	memcpy(&rfcomm_out_buffer[pos], data, len);
	pos += len;
	
	// UIH frames only calc FCS over address + control (5.1.1)
	if ((control & 0xef) == BT_RFCOMM_UIH){
		crc_fields = 2;
	}
	rfcomm_out_buffer[pos++] =  crc8_calc(rfcomm_out_buffer, crc_fields); // calc fcs
    bt_send_l2cap( source_cid, rfcomm_out_buffer, pos);
}

void _bt_rfcomm_send_sabm(uint16_t source_cid, uint8_t initiator, uint8_t channel)
{
	uint8_t address = (1 << 0) | (initiator << 1) |  (initiator << 1) | (channel << 3); 
	rfcomm_send_packet(source_cid, address, BT_RFCOMM_SABM, 0, NULL, 0);
}

void _bt_rfcomm_send_uih_data(uint16_t source_cid, uint8_t initiator, uint8_t channel, uint8_t *data, uint16_t len) {
	uint8_t address = (1 << 0) | (initiator << 1) |  (initiator << 1) | (channel << 3); 
	rfcomm_send_packet(source_cid, address, BT_RFCOMM_UIH, 0, data, len);
}	

void _bt_rfcomm_send_uih_msc_cmd(uint16_t source_cid, uint8_t initiator, uint8_t channel, uint8_t signals)
{
	uint8_t address = (1 << 0) | (initiator << 1); // EA and C/R bit set - always server channel 0
	uint8_t payload[4]; 
	uint8_t pos = 0;
	payload[pos++] = BT_RFCOMM_MSC_CMD;
	payload[pos++] = 2 << 1 | 1;  // len
	payload[pos++] = (1 << 0) | (1 << 1) | (0 << 2) | (channel << 3); // shouldn't D = initiator = 1 ?
	payload[pos++] = signals;
	rfcomm_send_packet(source_cid, address, BT_RFCOMM_UIH, 0, (uint8_t *) payload, pos);
}

void _bt_rfcomm_send_uih_pn_command(uint16_t source_cid, uint8_t initiator, uint8_t channel, uint16_t max_frame_size){
	uint8_t payload[10];
	uint8_t address = (1 << 0) | (initiator << 1); // EA and C/R bit set - always server channel 0
	uint8_t pos = 0;
	payload[pos++] = BT_RFCOMM_PN_CMD;
	payload[pos++] = 8 << 1 | 1;  // len
	payload[pos++] = channel << 1;
	payload[pos++] = 0xf0; // pre defined for Bluetooth, see 5.5.3 of TS 07.10 Adaption for RFCOMM
	payload[pos++] = 0; // priority
	payload[pos++] = 0; // max 60 seconds ack
	payload[pos++] = max_frame_size & 0xff; // max framesize low
	payload[pos++] = max_frame_size >> 8;   // max framesize high
	payload[pos++] = 0x00; // number of retransmissions
	payload[pos++] = 0x00; // unused error recovery window
	rfcomm_send_packet(source_cid, address, BT_RFCOMM_UIH, 0, (uint8_t *) payload, pos);
}

void comm_packet_handler(uint8_t packet_type, uint16_t channel, uint8_t *packet, uint16_t size){
	bd_addr_t event_addr;
	
	static uint8_t msc_resp_send = 0;
	static uint8_t msc_resp_received = 0;
	static uint8_t credits_used = 0;
	static uint8_t credits_free = 0;
	uint8_t packet_processed = 0;
	
	switch (packet_type) {
			
		case L2CAP_DATA_PACKET:
			// rfcomm: data[8] = addr
			// rfcomm: data[9] = command
			
			// 	received 1. message BT_RF_COMM_UA
			if (size == 4 && packet[1] == BT_RFCOMM_UA && packet[0] == 0x03){
				packet_processed++;
				printf("Received RFCOMM unnumbered acknowledgement for channel 0 - multiplexer working\n");
				printf("Sending UIH Parameter Negotiation Command\n");
				_bt_rfcomm_send_uih_pn_command(source_cid, 1, RFCOMM_CHANNEL_ID, 100);
			}
			
			//  received UIH Parameter Negotiation Response
			if (size == 14 && packet[1] == BT_RFCOMM_UIH && packet[3] == BT_RFCOMM_PN_RSP){
				packet_processed++;
				printf("UIH Parameter Negotiation Response\n");
				printf("Sending SABM #%u\n", RFCOMM_CHANNEL_ID);
				_bt_rfcomm_send_sabm(source_cid, 1, RFCOMM_CHANNEL_ID);
			}
			
			// 	received 2. message BT_RF_COMM_UA
			if (size == 4 && packet[1] == BT_RFCOMM_UA && packet[0] == ((RFCOMM_CHANNEL_ID << 3) | 3) ){
				packet_processed++;
				printf("Received RFCOMM unnumbered acknowledgement for channel %u - channel opened\n", RFCOMM_CHANNEL_ID);
				printf("Sending MSC  'I'm ready'\n");
				_bt_rfcomm_send_uih_msc_cmd(source_cid, 1, RFCOMM_CHANNEL_ID, 0x8d);  // ea=1,fc=0,rtc=1,rtr=1,ic=0,dv=1
			}
			
			// received BT_RFCOMM_MSC_CMD
			if (size == 8 && packet[1] == BT_RFCOMM_UIH && packet[3] == BT_RFCOMM_MSC_CMD){
				packet_processed++;
				printf("Received BT_RFCOMM_MSC_CMD\n");
				printf("Responding to 'I'm ready'\n");
				// fine with this
				uint8_t address = packet[0] | 2; // set response 
				packet[3]  = BT_RFCOMM_MSC_RSP;  //  "      "
				rfcomm_send_packet(source_cid, address, BT_RFCOMM_UIH, 0x30, (uint8_t*)&packet[3], 4);
				msc_resp_send = 1;
			}
			
			// received BT_RFCOMM_MSC_RSP
			if (size == 8 && packet[1] == BT_RFCOMM_UIH && packet[3] == BT_RFCOMM_MSC_RSP){
				packet_processed++;
				msc_resp_received = 1;
			}
			
			if (packet[1] == BT_RFCOMM_UIH && packet[0] == ((RFCOMM_CHANNEL_ID<<3)|1)){
				packet_processed++;
				credits_used++;
				if(DEBUG){
					printf("RX: address %02x, control %02x: ", packet[0], packet[1]);
					hexdump( (uint8_t*) &packet[3], size-4);
				}
				int written = 0;
				int length = size-4;
				int start_of_data = 3;
				//write data to fifo
				while (length) {
					if ((written = write(fifo_fd, &packet[start_of_data], length)) == -1) {
						printf("Error writing to FIFO\n");
					} else {
						length -= written;
					}
				}
			}
			
			if (packet[1] == BT_RFCOMM_UIH_PF && packet[0] == ((RFCOMM_CHANNEL_ID<<3)|1)){
				packet_processed++;
				credits_used++;
				if (!credits_free) {
					printf("Got %u credits, can send!\n", packet[2]);
				}
				credits_free = packet[2];
				if(DEBUG){
					printf("RX: address %02x, control %02x: ", packet[0], packet[1]);
					hexdump( (uint8_t *) &packet[4], size-5);				
				}
				int written = 0;
				int length = size-5;
				int start_of_data = 4;
				//write data to fifo
				while (length) {
					if ((written = write(fifo_fd, &packet[start_of_data], length)) == -1) {
						printf("Error writing to FIFO\n");
					} else {
						length -= written;
					}
				}
			}
			
			uint8_t send_credits_packet = 0;
			
			if (credits_used >= NR_CREDITS ) {
				send_credits_packet = 1;
				credits_used -= NR_CREDITS;
			}
			
			if (msc_resp_send && msc_resp_received) {
				send_credits_packet = 1;
				msc_resp_send = msc_resp_received = 0;
				
				printf("RFCOMM up and running!\n");
			}
			
			if (send_credits_packet) {
				// send 0x30 credits
				uint8_t initiator = 1;
				uint8_t address = (1 << 0) | (initiator << 1) |  (initiator << 1) | (RFCOMM_CHANNEL_ID << 3); 
				rfcomm_send_packet(source_cid, address, BT_RFCOMM_UIH_PF, NR_CREDITS, NULL, 0);
			}
			
			if (!packet_processed){
				// just dump data for now
				printf("??: address %02x, control %02x: ", packet[0], packet[1]);
				hexdump( packet, size );
			}
			
			break;
			
		case HCI_EVENT_PACKET:
			
			switch (packet[0]) {
					
				case BTSTACK_EVENT_POWERON_FAILED:
					// handle HCI init failure
					printf("HCI Init failed - make sure you have turned off Bluetooth in the System Settings\n");
					exit(1);
					break;		
					
				case BTSTACK_EVENT_STATE:
					// bt stack activated, get started - use authentication yes/no
					if (packet[2] == HCI_STATE_WORKING) {
						bt_send_cmd(&hci_write_authentication_enable, 1);
					}
					break;
					
				case HCI_EVENT_LINK_KEY_REQUEST:
					// link key request
					bt_flip_addr(event_addr, &packet[2]);
					bt_send_cmd(&hci_link_key_request_negative_reply, &event_addr);
					break;
					
				case HCI_EVENT_PIN_CODE_REQUEST:
					// inform about pin code request
					bt_flip_addr(event_addr, &packet[2]); 
					bt_send_cmd(&hci_pin_code_request_reply, &event_addr, 4, PIN);
					printf("Please enter PIN %s on remote device\n", PIN);
					break;
					
				case L2CAP_EVENT_CHANNEL_OPENED:
					// inform about new l2cap connection
					bt_flip_addr(event_addr, &packet[3]);
					uint16_t psm = READ_BT_16(packet, 11); 
					source_cid = READ_BT_16(packet, 13); 
					con_handle = READ_BT_16(packet, 9);
					if (packet[2] == 0) {
						printf("Channel successfully opened: ");
						print_bd_addr(event_addr);
						printf(", handle 0x%02x, psm 0x%02x, source cid 0x%02x, dest cid 0x%02x\n",
							   con_handle, psm, source_cid,  READ_BT_16(packet, 15));
						
						// send SABM command on dlci 0
						printf("Sending SABM #0\n");
						_bt_rfcomm_send_sabm(source_cid, 1, 0);
					} else {
						printf("L2CAP connection to device ");
						print_bd_addr(event_addr);
						printf(" failed. status code %u\n", packet[2]);
						exit(1);
					}
					break;
					
				case HCI_EVENT_DISCONNECTION_COMPLETE:
					// connection closed -> quit test app
					printf("Basebank connection closed, exit.\n");
					exit(0);
					break;
					
				case HCI_EVENT_COMMAND_COMPLETE:
					// connect to RFCOMM device (PSM 0x03) at addr
					if ( COMMAND_COMPLETE_EVENT(packet, hci_write_authentication_enable) ) {
						bt_send_cmd(&l2cap_create_channel, addr, 0x03);
					}
					break;
					
				default:
					// unhandled event
					if(DEBUG) printf("unhandled event : %02x\n", packet[0]);
					break;
			}
			break;
		default:
			// unhandled packet type
			if(DEBUG) printf("unhandled packet type : %02x\n", packet_type);
			break;
	}
}

