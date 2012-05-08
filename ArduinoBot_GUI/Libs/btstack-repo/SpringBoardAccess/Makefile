NAME = SpringBoardAccess

CC = /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/arm-apple-darwin10-gcc-4.2.1
OBJC     = /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/arm-apple-darwin10-g++-4.2.1
LDFLAGS  =  -framework CoreFoundation -framework Foundation -F/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/Frameworks -L/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/usr/lib -framework Foundation -framework CoreFoundation -framework UIKit -L/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/Frameworks/IOKit.framework/Versions/A /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/PrivateFrameworks/BluetoothManager.framework/BluetoothManager -lIOKit -lobjc
CPPFLAGS =  -I/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/usr/include -I/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/usr/lib/gcc/arm-apple-darwin10/4.2.1/include -F/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/Frameworks -Werror
prefix = /usr/local

LIB_LDFLAGS = -lobjc \
              -multiply_defined suppress \
			  -framework CoreFoundation \
			  -framework Foundation \
			  -framework UIKit \
			  -L../3rdparty -lsubstrate

APP_LDFLAGS = -framework CoreFoundation

all: $(NAME).dylib $(NAME)-test

clean:
	rm -f $(NAME).dylib $(NAME)-test
	
$(NAME).dylib: $(NAME)Extension.mm
	$(OBJC) $(CPPFLAGS) -dynamiclib -o $@ $(NAME)Extension.mm -init _$(NAME)Initialize $(LDFLAGS) $(LIB_LDFLAGS)
	# export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate ; ldid -S $@

$(NAME)-test: $(NAME)-test.c $(NAME).c
	$(OBJC) $(CPPFLAGS) -o $@  $(NAME).c $(NAME)-test.c $(LDFLAGS) $(APP_LDFLAGS)
	# export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate ; ldid -S $@

install:
	echo "SpringBoardAccess is not installed. Use .deb package"
