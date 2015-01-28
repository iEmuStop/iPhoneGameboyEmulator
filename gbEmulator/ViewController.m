//
//  ViewController.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-18.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//
// Store ROMs in /var/mobile/Media/ROMs/GAMEBOY/ -- if doesn't exist, create the directory (may also need to create ROMs)

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static rom * currentRom;

- (ViewController *) init
{
    self = [super init];
    if (self != nil)
    {
        romTitleLabel.text = @"Undefined ROM";
    }
    return self;
}
- (ViewController *) initWithCurrentRom:(rom *)theRom
{
    self = [super init];
    if (self != nil)
    {
        currentRom = theRom;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    romTitleLabel.text = currentRom.romName;
    emulator = [[emulatorMain alloc] initWithRom:currentRom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Note that the buttons are all active-high: set the correct bit in memory from 1 to 0 to indicate the button press
// Memory location 0xff00 is P1, and stores input/output info.
/*
 Bit 7 - Not used
 Bit 6 - Not used
 Bit 5 - P15 out port - A/B/START/SELECT
 Bit 4 - P14 out port - ARROWS
 Bit 3 - P13 in port - DOWN  | START
 Bit 2 - P12 in port - UP    | SELECT
 Bit 1 - P11 in port - LEFT  | B
 Bit 0 - P10 in port - RIGHT | A
 
 For emulator.keys, we'll say that the lower 4 bits are for the arrows,
 D, U, L, R
 And the top 4 bits are for the other buttons,
 Start, Select, B, A
 
 */

- (IBAction)upButtonDown:(id)sender
{
    NSLog(@"User pressed up arrow!\n");
    // or (0000 0100)2 with [0xff00]
    emulator.keys[2] = 1;
}
- (IBAction)downButtonDown:(id)sender
{
    NSLog(@"User pressed down arrow!\n");
    // or (0000 1000)2 with [0xff00]
    emulator.keys[3] = 1;
}
- (IBAction)leftButtonDown:(id)sender
{
    NSLog(@"User pressed left arrow!\n");
    // or (0000 0010)2 with [0xff00]
    emulator.keys[1] = 1;
}
- (IBAction)rightButtonDown:(id)sender
{
    NSLog(@"User pressed right arrow!\n");
    // or (0000 0001)2 with [0xff00]
    emulator.keys[0] = 1;
}
- (IBAction)AButtonDown:(id)sender
{
    NSLog(@"User pressed 'A' button!\n");
    // or (0000 0001)2 with [0xff00]
    emulator.keys[4] = 1;
}
- (IBAction)BButtonDown:(id)sender
{
    NSLog(@"User pressed 'B' button!\n");
    // or (0000 0010)2 with [0xff00]
    emulator.keys[5] = 1;
}
- (IBAction)startButtonDown:(id)sender
{
    NSLog(@"User pressed 'Start' button!\n");
    // or (0000 1000)2 with [0xff00]
    emulator.keys[7] = 1;
}
- (IBAction)selectButtonDown:(id)sender
{
    NSLog(@"User pressed 'Select' button!\n");
    // or (0000 0100)2 with [0xff00]
    emulator.keys[6] = 1;
}
- (IBAction)upButtonUp:(id)sender
{
    NSLog(@"User released 'Up' button!\n");
    // or (0000 0100)2 with [0xff00]
    emulator.keys[2] = 0;
}
- (IBAction)downButtonUp:(id)sender
{
    NSLog(@"User released down arrow!\n");
    // or (0000 1000)2 with [0xff00]
    emulator.keys[3] = 0;
}
- (IBAction)leftButtonUp:(id)sender
{
    NSLog(@"User released left arrow!\n");
    // or (0000 0010)2 with [0xff00]
    emulator.keys[1] = 0;
}
- (IBAction)rightButtonUp:(id)sender
{
    NSLog(@"User released right arrow!\n");
    // or (0000 0001)2 with [0xff00]
    emulator.keys[0] = 0;
}
- (IBAction)AButtonUp:(id)sender
{
    NSLog(@"User released 'A' button!\n");
    // or (0000 0001)2 with [0xff00]
    emulator.keys[4] = 0;
}
- (IBAction)BButtonUp:(id)sender
{
    NSLog(@"User released 'B' button!\n");
    // or (0000 0010)2 with [0xff00]
    emulator.keys[5] = 0;
}
- (IBAction)startButtonUp:(id)sender
{
    NSLog(@"User released 'Start' button!\n");
    // or (0000 1000)2 with [0xff00]
    emulator.keys[7] = 0;
}
- (IBAction)selectButtonUp:(id)sender
{
    NSLog(@"User released 'Select' button!\n");
    // or (0000 0100)2 with [0xff00]
    emulator.keys[6] = 0;
}
- (IBAction)stopButton:(id)sender
{
    // Save state, then return
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
- (IBAction)run:(id)sender
{
    [emulator runRom];
}

@end
