SRC 		=	main.c		\
			BTScan.c	\
			BTLayer.c	\
			CTools.c
OBJ 		=	$(SRC:.c=.o)

CC		=	/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/arm-apple-darwin10-gcc-4.2.1
LDFLAGS		=	-framework CoreFoundation -framework Foundation -F/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/Frameworks -L/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/usr/lib -framework Foundation -framework CoreFoundation -framework UIKit -L/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/Frameworks/IOKit.framework/Versions/A /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/PrivateFrameworks/BluetoothManager.framework/BluetoothManager -lIOKit -lobjc -lBTstack -L../src
CPPFLAGS	= 	-I/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/usr/include -I/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/usr/lib/gcc/arm-apple-darwin10/4.2.1/include -F/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/Frameworks -Werror -I../include
prefix		=	/usr/local

RM		=	rm -f

NAME		=	myBT

SCP		=	scp

IPHONE		=	root@192.168.3.104:

DISTCMD		=	ssh root@192.168.3.104 ./$(NAME)

$(NAME):	$(OBJ)
		$(CC) $(OBJ) $(CPPFLAGS) -o $(NAME) $(LDFLAGS)

all:		$(NAME)


clean:
		$(RM) $(OBJ)

fclean:		clean
		$(RM) $(NAME)

re:		fclean all

upload:
		@echo "Uploading file"
		$(SCP) ./$(NAME) $(IPHONE)

run:		upload
		$(DISTCMD)


#test: test.c
#	$(CC) $(CPPFLAGS) -o $@ $< $(LDFLAGS)
#	# export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate ; ldid -S $@

#l2cap-server: l2cap-server.c
#	$(CC) $(CPPFLAGS) -o $@ $< $(LDFLAGS)
#	# export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate ; ldid -S $@

#l2cap-throughput: l2cap-throughput.c
#	$(CC) $(CPPFLAGS) -o $@ $< $(LDFLAGS)
#	# export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate ; ldid -S $@

#mitm: mitm.c
#	$(CC) $(CPPFLAGS) -o $@ $< $(LDFLAGS)
#	# export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate ; ldid -S $@

#inquiry: inquiry.c
#	$(CC) $(CPPFLAGS) -o $@ $< $(LDFLAGS)
#	# export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate ; ldid -S $@

#rfcomm: rfcomm.c
#	$(CC) $(CPPFLAGS) -o $@ $< $(LDFLAGS)
#	# export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate ; ldid -S $@

#clean:
#	rm -f test mitm rfcomm inquiry l2cap-server l2cap-throughput obex
#	


