#import "emulatorMain.h"


void (^execute0xcb20Instruction)(romState *,
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

    // SLA B -- Shift B left into Carry
    prev = [state getB];
    C = (bool)([state getB] & 0b10000000);
    [state setB:([state getB] << 1) & 0xff];
    [state setFlags:[state getB] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SLA B -- B was 0x%02x; B is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getB] & 0xff, [state getCFlag]);
};
void (^execute0xcb21Instruction)(romState *,
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

    // SLA C -- Shift C left into Carry
    prev = [state getC];
    C = (bool)([state getC] & 0b10000000);
    [state setC:([state getC] << 1) & 0xff];
    [state setFlags:[state getC] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SLA C -- C was 0x%02x; C is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getC] & 0xff, [state getCFlag]);
};
void (^execute0xcb22Instruction)(romState *,
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

    // SLA D -- Shift D left into Carry
    prev = [state getD];
    C = (bool)([state getD] & 0b10000000);
    [state setD:([state getD] << 1) & 0xff];
    [state setFlags:[state getD] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SLA D -- D was 0x%02x; D is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getD] & 0xff, [state getCFlag]);
};
void (^execute0xcb23Instruction)(romState *,
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

    // SLA E -- Shift E left into Carry
    prev = [state getE];
    C = (bool)([state getE] & 0b10000000);
    [state setE:([state getE] << 1) & 0xff];
    [state setFlags:[state getE] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SLA E -- E was 0x%02x; E is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getE] & 0xff, [state getCFlag]);
};
void (^execute0xcb24Instruction)(romState *,
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

    // SLA H -- Shift H left into Carry
    prev = [state getH];
    C = (bool)([state getH] & 0b10000000);
    [state setH:([state getH] << 1) & 0xff];
    [state setFlags:[state getH] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SLA H -- H was 0x%02x; H is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getH] & 0xff, [state getCFlag]);
};
void (^execute0xcb25Instruction)(romState *,
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

    // SLA L -- Shift L left into Carry
    prev = [state getL];
    C = (bool)([state getL] & 0b10000000);
    [state setL:([state getL] << 1) & 0xff];
    [state setFlags:[state getL] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SLA L -- L was 0x%02x; L is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getL] & 0xff, [state getCFlag]);
};
void (^execute0xcb26Instruction)(romState *,
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

    // SLA (HL) -- Shift (HL) left into Carry
    prev = ram[(unsigned short)[state getHL_big]];
    C = (bool)(ram[(unsigned short)[state getHL_big]] & 0b10000000);
    ram[(unsigned short)[state getHL_big]] = (ram[(unsigned short)[state getHL_big]] << 1) & 0xff;
    [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SLA (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff, [state getCFlag]);
};
void (^execute0xcb27Instruction)(romState *,
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

    // SLA A -- Shift A left into Carry
    prev = [state getA];
    C = (bool)([state getA] & 0b10000000);
    [state setA:([state getA] << 1) & 0xff];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SLA A -- A was 0x%02x; A is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getA] & 0xff, [state getCFlag]);
};
void (^execute0xcb28Instruction)(romState *,
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

    // SRA B -- Shift B right into Carry; MSb remains the same
    prev = [state getB];
    C = (bool)([state getB] & 0b00000001);
    [state setB:(([state getB] >> 1) & 0xff) | (prev & 0b10000000)];
    [state setFlags:[state getB] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SRA B -- B was 0x%02x; B is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getB] & 0xff, [state getCFlag]);
};
void (^execute0xcb29Instruction)(romState *,
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

    // SRA C -- Shift C right into Carry; MSb remains the same
    prev = [state getC];
    C = (bool)([state getC] & 0b00000001);
    [state setC:(([state getC] >> 1) & 0xff) | (prev & 0b10000000)];
    [state setFlags:[state getC] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SRA C -- C was 0x%02x; C is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getC] & 0xff, [state getCFlag]);
};
void (^execute0xcb2AInstruction)(romState *,
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

    // SRA D -- Shift D right into Carry; MSb remains the same
    prev = [state getD];
    C = (bool)([state getD] & 0b00000001);
    [state setD:(([state getD] >> 1) & 0xff) | (prev & 0b10000000)];
    [state setFlags:[state getD] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SRA D -- D was 0x%02x; D is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getD] & 0xff, [state getCFlag]);
};
void (^execute0xcb2BInstruction)(romState *,
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

    // SRA E -- Shift E right into Carry; MSb remains the same
    prev = [state getE];
    C = (bool)([state getE] & 0b00000001);
    [state setE:(([state getE] >> 1) & 0xff) | (prev & 0b10000000)];
    [state setFlags:[state getE] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SRA E -- E was 0x%02x; E is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getE] & 0xff, [state getCFlag]);
};
void (^execute0xcb2CInstruction)(romState *,
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

    // SRA H -- Shift H right into Carry; MSb remains the same
    prev = [state getH];
    C = (bool)([state getH] & 0b00000001);
    [state setH:(([state getH] >> 1) & 0xff) | (prev & 0b10000000)];
    [state setFlags:[state getH] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SRA H -- H was 0x%02x; H is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getH] & 0xff, [state getCFlag]);
};
void (^execute0xcb2DInstruction)(romState *,
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

    // SRA L -- Shift L right into Carry; MSb remains the same
    prev = [state getL];
    C = (bool)([state getL] & 0b00000001);
    [state setL:(([state getL] >> 1) & 0xff) | (prev & 0b10000000)];
    [state setFlags:[state getL] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SRA L -- L was 0x%02x; L is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getL] & 0xff, [state getCFlag]);
};
void (^execute0xcb2EInstruction)(romState *,
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

    // SRA (HL) -- Shift (HL) right into Carry; MSb remains the same
    prev = ram[(unsigned short)[state getHL_big]];
    C = (bool)(ram[(unsigned short)[state getHL_big]] & 0b00000001);
    ram[(unsigned short)[state getHL_big]] = ((ram[(unsigned short)[state getHL_big]] << 1)
                                              & 0xff) | (prev & 0b10000000);
    [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SRA (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff, [state getCFlag]);
};
void (^execute0xcb2FInstruction)(romState *,
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

    // SRA A -- Shift A right into Carry; MSb remains the same
    prev = [state getA];
    C = (bool)([state getA] & 0b00000001);
    [state setA:(([state getA] >> 1) & 0xff) | (prev & 0b10000000)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB%02x -- SRA A -- A was 0x%02x; A is now 0x%02x; C-flag = %i\n", currentInstruction,
             prev & 0xff, [state getA] & 0xff, [state getCFlag]);
};