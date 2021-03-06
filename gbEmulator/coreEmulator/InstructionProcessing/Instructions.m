/*
 * Think of these instruction blocks as applying some
 * change to the current state, like an add method
 * would simply add its given input, regardless of which
 * class the inputs were from. Instructions don't need
 * to be seen as methods that only belong to the emulator
 * class. Plus, this makes that class not have a 6000-line
 * implementation file.
 *
 *
 * IDEA:
 * Subclass the emulatorMain class so that each instruction
 * inherits from it. -- Add tests... :(
 */

#import "emulatorMain.h"

// Do not change these addresses!!!
const unsigned short ISRAddress_VerticalBlank = 0x40;
const unsigned short ISRAddress_LCDStatusTriggers = 0x48;
const unsigned short ISRAddress_Timer = 0x50;
const unsigned short ISRAddress_SerialLink = 0x58;
const unsigned short ISRAddress_JoypadPress = 0x60;
const unsigned short interruptFlagAddress = 0xff0f;
const unsigned short interruptEnableRegister = 0xffff;
const unsigned short joypadDataRegister = 0xff00;

// Do not change these instruction definitions!
const unsigned char RET = 0xc9;
const unsigned char RETI = 0xd9;

typedef void (^InstructionBlock)(romState *, int8_t, char *, bool *, int8_t *);

NSMutableDictionary * blocks = [NSMutableDictionary dictionaryWithObjectsAndKeys:execute0x00Instruction, @(0x00)];

void (^execute0x0Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x1Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x2Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x3Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x4Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x5Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x6Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x7Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x8Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x9Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xAInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xBInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xCInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xDInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xEInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xFInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbInstruction)(romState *, char *, bool *, int8_t *, int8_t);
void (^execute0xcb0Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb1Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb2Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb3Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb4Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb5Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb6Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb7Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb8Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb9Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbAInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbBInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbCInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbDInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbEInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbFInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^servicedInterrupt)(char *, int8_t);
void (^pushPCForISR)(romState *, char *, unsigned short);
int16_t (^get16BitWordFromRAM)(short, char *);

#pragma mark - enableInterrupts
void (^enableInterrupts)(bool, char *) = ^(bool maybe, char * ram)
{
    if (maybe == true)
    {
        PRINTDBG("Interrupts have been ENabled...\n");
        ram[0x0ffff] = 0b00011111;
    }
    else
    {
        PRINTDBG("Interrupts have been DISabled...\n");
        ram[0x0ffff] = 0;
    }
};

#pragma mark - setKeysInMemory
void (^setKeysInMemory)(char *, int) = ^(char * ram, int buttons)
{
    if (ram[joypadDataRegister] & 0b00100000) // a, b, start, select
    {
        ram[joypadDataRegister] |= (buttons & 0b11110000) >> 4;
    }
    else if (ram[joypadDataRegister] & 0b00010000) // arrows
    {
        ram[joypadDataRegister] |= buttons & 0b00001111;
    }
};

int16_t (^get16BitWordFromRAM)(short, char *) = ^(short offset, char * ram)
{
    return (int16_t)(((ram[offset + 1] & 0x00ff) << 8) |
        (((ram[offset])) & 0x0ff));
};

void (^executeGivenInstruction)(romState *, int8_t, char *, bool *, int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    switch ((currentInstruction & 0xF0) >> 4) {
        case 0:
            execute0x0Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 1:
            execute0x1Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 2:
            execute0x2Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 3:
            execute0x3Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 4:
            execute0x4Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 5:
            execute0x5Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 6:
            execute0x6Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 7:
            execute0x7Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 8:
            execute0x8Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 9:
            execute0x9Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xA:
            execute0xAInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xB:
            execute0xBInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xC:
            execute0xCInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xD:
            execute0xDInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xE:
            execute0xEInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xF:
            execute0xFInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
    }
};

#pragma mark - executeInstruction
void (^executeInstruction)(romState *, char *, bool *, int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    unsigned char currentInstruction = ram[[state getPC]-1];
    PRINTDBG("Instruction address: 0x%02x\n", ([state getPC]-1) & 0xff);
    executeGivenInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
};

#pragma mark - execute0xcbInstruction
void (^execute0xcbInstruction)(romState *,
                               char *,
                               bool *,
                               int8_t *,
                               int8_t) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled,
  int8_t CBInstruction)
{
    [state incrementPC];
    switch ((CBInstruction & 0xF0) >> 4) {
        case 0:
            execute0xcb0Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 1:
            execute0xcb1Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 2:
            execute0xcb2Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 3:
            execute0xcb3Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 4:
            execute0xcb4Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 5:
            execute0xcb6Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 6:
            execute0xcb6Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 7:
            execute0xcb7Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 8:
            execute0xcb8Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 9:
            execute0xcb9Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xA:
            execute0xcbAInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xB:
            execute0xcbBInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xC:
            execute0xcbCInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xD:
            execute0xcbDInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xE:
            execute0xcbEInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xF:
            execute0xcbFInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
    }
};

// TODO: should the IF be set to 0 upon startup? (Hypothesis: Yes)
// Note: We will denote being in an ISR by having '>' before
// every instruction while in the ISR.
void (^interruptServiceRoutineCaller)(romState *, char *, bool *, int8_t *) = ^
(romState * state,
 char * ram,
 bool * incrementPC,
 int8_t * interruptsEnabled)
{
    int8_t enabledInterrupts = ram[interruptFlagAddress] & ram[interruptEnableRegister];
    unsigned char instruction = 0;
    // Since the interrupts have specific priorities, these statements
    // are arranged to correspond to the order of the interrupt priorities.

    // Service interrupt for vertical blank -- approx. occurs 60 times a second
    if (enabledInterrupts & (1 << VERTICAL_BLANK))
    {
        pushPCForISR(state, ram, ISRAddress_VerticalBlank);
        // Continue to execute instructions until we exit the ISR.
        // We know when this occurs because we'll hit a return instruction,
        // either RET (0xC9) or RETI (0xD9)
        while (instruction != RET && instruction != RETI)
        {
            [state incrementPC];
            PRINTDBG("\n> PC = 0x%02x\n", [state getPC]);
            instruction = ram[[state getPC]];
            executeInstruction(state, ram, incrementPC, interruptsEnabled);
        }
        servicedInterrupt(ram, VERTICAL_BLANK);
        instruction = 0;
    }
    // Service interrupt for LCD status triggers
    if (enabledInterrupts & (1 << LCD_STATUS_TRIGGERS))
    {
        pushPCForISR(state, ram, ISRAddress_LCDStatusTriggers);
        while (instruction != RET && instruction != RETI)
        {
            [state incrementPC];
            PRINTDBG("\n> PC = 0x%02x\n", [state getPC]);
            instruction = ram[[state getPC]];
            executeInstruction(state, ram, incrementPC, interruptsEnabled);
        }
        servicedInterrupt(ram, LCD_STATUS_TRIGGERS);
        instruction = 0;
    }
    // Service interrupt for timer overflow -- if 0xff05 goes from 0xff to 0x00
    if (enabledInterrupts & (1 << TIMER_OVERFLOW))
    {
        pushPCForISR(state, ram, ISRAddress_Timer);
        while (instruction != RET && instruction != RETI)
        {
            [state incrementPC];
            PRINTDBG("\n> PC = 0x%02x\n", [state getPC]);
            instruction = ram[[state getPC]];
            executeInstruction(state, ram, incrementPC, interruptsEnabled);
        }
        servicedInterrupt(ram, TIMER_OVERFLOW);
        instruction = 0;
    }
    // Service interrupt for serial link -- serial transfer finished on game link port
    if (enabledInterrupts & (1 << SERIAL_LINK))
    {
        pushPCForISR(state, ram, ISRAddress_SerialLink);
        while (instruction != RET && instruction != RETI)
        {
            [state incrementPC];
            PRINTDBG("\n> PC = 0x%02x\n", [state getPC]);
            instruction = ram[[state getPC]];
            executeInstruction(state, ram, incrementPC, interruptsEnabled);
        }
        servicedInterrupt(ram, SERIAL_LINK);
        instruction = 0;
    }
    // Service interrupt for joypad press -- occurs every time a key is pressed or released
    if (enabledInterrupts & (1 << JOYPAD_PRESS))
    {
        pushPCForISR(state, ram, ISRAddress_JoypadPress);
        while (instruction != RET && instruction != RETI)
        {
            [state incrementPC];
            PRINTDBG("\n> PC = 0x%02x\n", [state getPC]);
            instruction = ram[[state getPC]];
            executeInstruction(state, ram, incrementPC, interruptsEnabled);
        }
        servicedInterrupt(ram, JOYPAD_PRESS);
    }
};

void (^pushPCForISR)(romState *, char *, unsigned short) = ^
(romState * state,
 char * ram,
 unsigned short ISRAddress)
{
    unsigned short prev_PC = [state getPC];
    unsigned short prev_short = [state getSP];
    [state setSP:(prev_short - 2)];
    ram[[state getSP]] = (int8_t)(([state getPC]+1) & 0xff);
    ram[[state getSP]+1] = (int8_t)((([state getPC]+1) & 0xff00) >> 8);
    [state setPC:ISRAddress];
    PRINTDBG("Save PC for ISR -- PC was at 0x%02x, and is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x; (SP) = 0x%02x\n",
             prev_PC, [state getPC], prev_short, [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) | (((ram[[state getSP]+1]) << 8) & 0xff00));
};

void (^servicedInterrupt)(char *, int8_t) = ^
(char * ram,
 int8_t pos)
{
    // Acknowledge the interrupt has been handled by writing a 0 to
    // the corresponding interrupt flag bit (at 0xff0f), without
    // changing the other bits.
    assert(pos >= 0 && pos <= 4);
    ram[interruptFlagAddress] &= (1 << pos) ^ 0xff;
    PRINTDBG("Serviced interrupt at flag bit %i\n", pos & 0xff);
};

