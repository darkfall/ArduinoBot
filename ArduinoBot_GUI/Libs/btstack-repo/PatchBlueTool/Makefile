CC = /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/arm-apple-darwin10-gcc-4.2.1
LDFLAGS  =  -framework CoreFoundation -framework Foundation -F/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/Frameworks -L/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/usr/lib -framework Foundation -framework CoreFoundation -framework UIKit -L/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/Frameworks/IOKit.framework/Versions/A /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/PrivateFrameworks/BluetoothManager.framework/BluetoothManager -lIOKit -lobjc
CPPFLAGS =  -I/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/usr/include -I/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/usr/lib/gcc/arm-apple-darwin10/4.2.1/include -F/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/Frameworks -Werror
prefix = /usr/local

all: PatchBlueTool

PatchBlueTool: PatchBlueTool.c
	$(CC) $(CPPFLAGS) -o $@ $< $(LDFLAGS)
	# export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate ; ldid -S $@

clean:
	rm -f PatchBlueTool
	
install:    
	echo "nothing to be done"

