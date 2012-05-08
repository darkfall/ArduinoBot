TARGET = NixBot
#PORT=/dev/ttyUSB0
PORT = /dev/tty.usbserial-*
UPLOAD_RATE = 57600
AVRDUDE_PROGRAMMER = stk500v1
MCU = atmega1280
F_CPU = 16000000

ARDUINO = /Applications/Arduino.app/Contents/Resources/Java/hardware/arduino/cores/arduino/
ARDUINO_AVRCONF=/Applications/Arduino.app/Contents/Resources/Java/hardware/tools/avr/etc/avrdude.conf
ARDUINO_BIN=/Applications/Arduino.app/Contents/Resources/Java/hardware/tools/avr/bin/

############################################################################



SRC = $(ARDUINO)/pins_arduino.c 	\
	$(ARDUINO)/wiring.c 		\
	$(ARDUINO)/wiring_analog.c 	\
	$(ARDUINO)/wiring_digital.c 	\
	$(ARDUINO)/wiring_pulse.c 	\
	$(ARDUINO)/wiring_shift.c 	\
	$(ARDUINO)/WInterrupts.c	\
	Wire/utility/twi.c

CXXSRC = $(ARDUINO)/HardwareSerial.cpp	\
	$(ARDUINO)/WMath.cpp 		\
	$(ARDUINO)/Print.cpp		\
	$(ARDUINO)/main.cpp		\
	$(TARGET).cpp			\
	cppfix.cpp			\
	Servo/Servo.cpp			\
	Wire/Wire.cpp			\
	directionSet.cpp		\
	botURM37.cpp			\
	botMotor.cpp			\
	HMC6352.cpp			\
	botCmdLine.cpp			\
	Tools/CmdFunc.cpp

# Debugging format.
# Native formats for AVR-GCC's -g are stabs [default], or dwarf-2.
# AVR (extended) COFF requires stabs, plus an avr-objcopy run.
DEBUG = stabs


# Compiler flag to set the C Standard level.
# c89   - "ANSI" C
# gnu89 - c89 plus GCC extensions
# c99   - ISO C99 standard (not yet fully implemented)
# gnu99 - c99 plus GCC extensions
#CSTANDARD = -std=gnu99
#CDEBUG = -g$(DEBUG)
#CWARN = -Wall -Wstrict-prototypes
CTUNING = -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
#CEXTRA = -Wa,-adhlns=$(<:.c=.lst)

CFLAGS = -g -Os -W -Wall -Wno-write-strings -ffunction-sections -fdata-sections -g$(DEBUG) -mmcu=$(MCU) -DF_CPU=$(F_CPU) -I. -I$(ARDUINO) -I./Wire/utility/ -I./Wire/ 
CXXFLAGS = -g -Os -W -Wall -Wno-write-strings -fno-exceptions -ffunction-sections -fdata-sections -mmcu=$(MCU) -DF_CPU=$(F_CPU) -I. -I$(ARDUINO) -I./Wire/utility/ -I./Wire/ 
ASFLAGS = -Wa,-adhlns=$(<:.S=.lst),-gstabs 
LDFLAGS = -lm

# Programming support using avrdude. Settings and variables.
AVRDUDE_PORT = $(PORT)
AVRDUDE_WRITE_FLASH = -U flash:w:$(TARGET).hex
AVRDUDE_FLAGS = -V -F -C $(ARDUINO_AVRCONF) -p $(MCU) -P $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER) -b $(UPLOAD_RATE)

# Program settings
CC = $(ARDUINO_BIN)avr-gcc
CXX = $(ARDUINO_BIN)avr-g++
OBJCOPY = $(ARDUINO_BIN)avr-objcopy
OBJDUMP = $(ARDUINO_BIN)avr-objdump
AR  = $(ARDUINO_BIN)avr-ar
SIZE = $(ARDUINO_BIN)avr-size
NM = $(ARDUINO_BIN)avr-nm
AVRDUDE = $(ARDUINO_BIN)avrdude

# Define all object files.
OBJ = $(SRC:.c=.o) $(CXXSRC:.cpp=.o) $(ASRC:.S=.o) 

# Define all listing files.
LST = $(CXXSRC:.cpp=.lst) $(SRC:.c=.lst) $(ASRC:.S=.lst)

# Combine all necessary flags and optional flags.
# Add target processor to flags.
ASFLAGS = -mmcu=$(MCU) -I. -x assembler-with-cpp $(ASFLAGS) 


# Default target.
all: build sizeafter

#all:	$(OBJ)
#	$(CC)  -Os -Wl,--gc-sections -mmcu=$(MCU) $(OBJ) -o $(TARGET).elf
#	$(CC)  -Os -Wl,--gc-sections -mmcu=$(MCU) $(OBJ) -o $(TARGET).hex
#	$(CC)  -Os -Wl,--gc-sections -mmcu=$(MCU) $(OBJ) -o $(TARGET).eep

build: elf eep hex

elf: $(TARGET).elf
hex: $(TARGET).hex
eep: $(TARGET).eep
lss: $(TARGET).lss
sym: $(TARGET).sym

# Program the device.  
upload: $(TARGET).hex
	../commons/reset_board.sh
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)


# Display size of file.
HEXSIZE = $(SIZE) --target=ihex $(TARGET).hex
ELFSIZE = $(SIZE)  $(TARGET).elf
sizebefore:
	@if [ -f $(TARGET).elf ]; then echo; echo $(MSG_SIZE_BEFORE); $(HEXSIZE); echo; fi

sizeafter:
	@if [ -f $(TARGET).elf ]; then echo; echo $(MSG_SIZE_AFTER); $(HEXSIZE); echo; fi


# Convert ELF to COFF for use in debugging / simulating in AVR Studio or VMLAB.
#COFFCONVERT=$(OBJCOPY) --debugging \
#	--change-section-address .data-0x800000 \
#	--change-section-address .bss-0x800000 \
#	--change-section-address .noinit-0x800000 \
#	--change-section-address .eeprom-0x810000 


#coff: $(TARGET).elf
#	$(COFFCONVERT) -O coff-avr $(TARGET).elf $(TARGET).cof
#
#
#extcoff: $(TARGET).elf
#	$(COFFCONVERT) -O coff-ext-avr $(TARGET).elf $(TARGET).cof


.SUFFIXES: .elf .hex .eep .lss .sym

.elf.hex:
	$(OBJCOPY) -O ihex -R .eeprom $< $@

.elf.eep:
	$(OBJCOPY) -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $< $@

# Create extended listing file from ELF output file.
.elf.lss:
	$(OBJDUMP) -h -S $< > $@

# Create a symbol table from ELF output file.
.elf.sym:
	$(NM) -n $< > $@

# Link: create ELF output file from library.
$(TARGET).elf: $(OBJ) #$(TARGET).cpp core.a 
	$(CC) -Os -Wl,--gc-sections -mmcu=$(MCU) $(CXXDEFS) -o $@ $(OBJ) -L. $(LDFLAGS) -I$(ARDUINO)
#	$(CC) -Os -Wl,--gc-sections -mmcu=$(MCU) $(CXXDEFS) -o $@ $(TARGET).cpp -L. $(LDFLAGS) -I$(ARDUINO) -L$(ARDUINO)


#core.a: $(OBJ)
#	@for i in $(OBJ); do echo $(AR) rcs core.a $$i; $(AR) rcs core.a $$i; done


# Compile: create object files from C++ source files.
.cpp.o:
	$(CXX) -c $(CXXFLAGS) $< -o $@ 

# Compile: create object files from C source files.
.c.o:
	$(CC) -c $(CFLAGS) $< -o $@ 


# Compile: create assembler files from C source files.
.c.s:
	$(CC) -S $(CFLAGS) $< -o $@


# Assemble: create object files from assembler source files.
.S.o:
	$(CC) -c $(ASFLAGS) $< -o $@


# Automatic dependencies
%.d: %.c
	$(CC) -M $(CFLAGS) $< | sed "s;$(notdir $*).o:;$*.o $*.d:;" > $@

%.d: %.cpp
	$(CXX) -M $(CXXFLAGS) $< | sed "s;$(notdir $*).o:;$*.o $*.d:;" > $@


# Target: clean project.
clean:
	rm -f $(TARGET).hex $(TARGET).eep $(TARGET).cof $(TARGET).elf \
	$(TARGET).map $(TARGET).sym $(TARGET).lss core.a \
	$(OBJ) $(LST) $(SRC:.c=.s) $(SRC:.c=.d) $(CXXSRC:.cpp=.s) $(CXXSRC:.cpp=.d)

.PHONY:	all build elf hex eep lss sym program coff extcoff clean sizebefore sizeafter

