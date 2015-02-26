#import "emulatorMain.h"

void (^execute0xcb1Instruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            // RL C -- Rotate C left through C-flag
            prev = [state getC] << 1;
            C = (bool)([state getC] & 0b10000000);
            // Set LSb of A to its previous C-value
            [state getCFlag] ? [state setC:(prev | 1)] : [state setC:(prev & 0b11111110)];
            [state setFlags:false
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RL C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, prev, [state getC]);
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
};