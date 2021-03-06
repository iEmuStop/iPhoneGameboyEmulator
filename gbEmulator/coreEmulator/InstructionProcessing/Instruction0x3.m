#import "emulatorMain.h"

void (^execute0x30Instruction)(romState *,
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
    int8_t d8 = 0;

    // JR NC,r8 -- If !C, add 8-bit immediate data to PC
    d8 = ram[[state getPC]];
    [state incrementPC];
    if (![state getCFlag])
    {
        [state addToPC:d8];
    }
    PRINTDBG("0x%02x -- JR NC, r8 -- if !C, PC += %i; PC is now 0x%02x\n", currentInstruction,
             (int8_t)d8, [state getPC]);
    *incrementPC = false;
};

void (^execute0x31Instruction)(romState *,
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
    unsigned short d16 = 0;

    // LD SP,d16 -- load immediate 16-bit data into SP
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x0ff);
    [state doubleIncPC];
    [state setSP:d16];
    PRINTDBG("0x%02x -- LD SP, d16 -- d16 = 0x%02x; SP = 0x%02x\n", currentInstruction, d16 & 0xffff,
             [state getSP] & 0xffff);
};

void (^execute0x32Instruction)(romState *,
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

    // LD (HL-),A -- put A into (HL), and decrement HL
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getA];
    [state setHL_big:([state getHL_big] - 1)];
    PRINTDBG("0x%02x -- LD (HL-),A -- HL-1 = 0x%02x; (HL) was 0x%02x; (HL) = 0x%02x; A = 0x%02x\n", currentInstruction,
             [state getHL_big] & 0xffff, prev & 0xff,
             ram[(unsigned short)[state getHL_big]+1] & 0xff, [state getA] & 0xff);
};

void (^execute0x33Instruction)(romState *,
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
    // INC SP -- Increment SP
    [state setSP:([state getSP] + 1)];
    PRINTDBG("0x%02x -- INC SP; SP is now 0x%02x\n", currentInstruction, [state getSP] & 0xffff);
};

void (^execute0x34Instruction)(romState *,
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

    // INC (HL) -- Increment (HL)
    prev = ram[[state getHL_big]];
    ram[[state getHL_big]] += 1;
    [state setFlags:(ram[(unsigned short)[state getHL_big]] == 0)
                  N:false
                  H:(prev > ram[(unsigned short)[state getHL_big]])
                  C:([state getCFlag])];
    PRINTDBG("0x%02x -- INC (HL); (HL) is now 0x%02x\n", currentInstruction, ram[[state getHL_big]] & 0xff);
};

void (^execute0x35Instruction)(romState *,
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

    // DEC (HL) -- Decrement (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] -= 1;
    [state setFlags:(ram[(unsigned short)[state getHL_big]] == 0)
                  N:true
     // Set if no borrow from b4
                  H:!((char)(prev & 0xf) < (char)(((ram[(unsigned short)[state getHL_big]] & 0xf) & 0xf)))
                  C:([state getCFlag])];
    PRINTDBG("0x%02x -- DEC (HL); (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, prev,
             ram[(unsigned short)[state getHL_big]] & 0xff);
};

void (^execute0x36Instruction)(romState *,
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
    int8_t d8 = 0;

    // LD (HL),d8 -- Load 8-bit immediate data into (HL)
    d8 = ram[[state getPC]];
    [state incrementPC];
    ram[(unsigned short)[state getHL_big]] = d8;
    PRINTDBG("0x%02x -- LD (HL), d8 -- d8 = 0x%02x\n", currentInstruction, d8 & 0xff);
};

void (^execute0x37Instruction)(romState *,
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
    // SCF -- Set carry flag
    [state setFlags:[state getZFlag]
                  N:false
                  H:false
                  C:true];
    PRINTDBG("0x%02x -- SCF\n", currentInstruction);
};

void (^execute0x38Instruction)(romState *,
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
    int8_t d8 = 0;

    // JR C,r8 -- If C, add 8-bit immediate data to PC
    d8 = ram[[state getPC]];
    [state incrementPC];
    if ([state getCFlag])
    {
        [state addToPC:d8];
    }
    PRINTDBG("0x%02x -- JR C, r8 -- if C, PC += %i; PC is now 0x%02x\n", currentInstruction,
             (int)d8, [state getPC] & 0xffff);
    *incrementPC = false;
};

void (^execute0x39Instruction)(romState *,
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
    short prev_short = 0;
    bool Z = true;
    bool H = true;
    bool C = true;

    // ADD HL,SP -- Add SP to HL
    // H = carry from bit 11; C = carry from bit 15; reset N; leave Z alone
    prev = [state getHL_little] & 0xf;
    prev_short = [state getHL_big];
    [state setHL_big:([state getSP]+[state getHL_big])];
    Z = [state getZFlag];
    C = (unsigned short)prev_short > (unsigned short)[state getHL_big];
    H = prev_short > [state getHL_big];
    [state setFlags:Z
                  N:false
                  H:H
                  C:C];
    PRINTDBG("0x%02x -- ADD HL,SP -- add SP (0x%02x) and HL (0x%02x) = 0x%02x\n", currentInstruction,
             [state getSP] & 0xffff, prev_short & 0xffff, [state getHL_big] & 0xffff);
};

void (^execute0x3AInstruction)(romState *,
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
    // LD A,(HL-) -- Put value at address at HL, (HL), into A, and decrement HL
    [state setA:ram[(unsigned short)[state getHL_big]]];
    [state setHL_big:([state getHL_big]-1)];
    PRINTDBG("0x%02x -- LD A,(HL-) -- HL is now 0x%02x; A = 0x%02x\n", currentInstruction,
             [state getHL_big] & 0xffff, [state getA] & 0xff);
};

void (^execute0x3BInstruction)(romState *,
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
    short prev_short = 0;

    // DEC SP -- Decrement SP
    prev_short = [state getSP];
    [state setHL_big:([state getSP] - 1)];
    PRINTDBG("0x%02x -- DEC SP -- SP was 0x%02x; SP is now 0x%02x\n", currentInstruction,
             prev_short & 0xffff, [state getSP] & 0xffff);
};

void (^execute0x3CInstruction)(romState *,
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

    // INC A -- Increment A
    prev = [state getA];
    [state setA:([state getA] + 1)];
    [state setFlags:([state getA] == 0)
                  N:false
                  H:(prev > [state getA])
                  C:([state getCFlag])];
    PRINTDBG("0x%02x -- INC A; A is now 0x%02x\n", currentInstruction, [state getA] & 0xff);
};

void (^execute0x3DInstruction)(romState *,
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
    bool Z = true;
    bool H = true;

    // DEC A -- Decrement A
    prev = [state getA];
    [state setA:([state getA] - 1)];
    Z = [state getA] == 0;
    H = !((char)(prev & 0xf) < (char)((([state getA] & 0xf) & 0xf)));
    [state setFlags:Z
                  N:true
                  H:H
                  C:[state getCFlag]];
    PRINTDBG("0x%02x -- DEC A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
             prev & 0xff, [state getA] & 0xff);
};

void (^execute0x3EInstruction)(romState *,
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
    int8_t d8 = 0;

    // LD A,d8 -- Load 8-bit immediate data into A
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state setA:d8];
    PRINTDBG("0x%02x -- LD A, d8 -- d8 = 0x%02x\n", currentInstruction, d8 & 0xff);
};

void (^execute0x3FInstruction)(romState *,
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
    // CCF -- Complement carry flag
    [state setFlags:[state getZFlag]
                  N:false
                  H:false
                  C:![state getCFlag]];
    PRINTDBG("0x%02x -- CCF\n", currentInstruction);
};

