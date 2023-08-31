/**
 * @brief the simplest possible Cartridge in C
 * @author Thomas Cherryhomes
 * @email thom dot cherryhomes at gmail dot com
 * @license gpl v. 3, see LICENSE for details
 */

#include <atari.h>    // Needed for Atari features/registers/etc
#include <string.h>   // needed for memcpy()

// This message is in ASCII. CC65 does not have a native way to deal with screen codes, without making
// a character mapping, which is possible.

char msg[] = "  YOUR ATARI WORKS  ";

// This display list exists in ROM, can't be changed, but the compiler can also not
// dynamically point back to the beginning of this display list, because of hidden information
// from the linker, so it must be copied to RAM.

const void dlist=
  {
    DL_BLK8,
    DL_BLK8,
    DL_BLK8,
    DL_BLK8,
    DL_BLK8,
    DL_BLK8,
    DL_BLK8,
    DL_BLK8,
    DL_BLK8,
    DL_BLK8,
    DL_BLK8,
    DL_BLK8,
    DL_BLK8,
    DL_LMS(DL_CHR20x16x2),
    msg,
    DL_JVB,
    0x0600, 
  };

void main(void)
{
  int i;

  // Copy the display list to $0600 in RAM
  memcpy((void *)0x0600,&dlist,sizeof(dlist));

  // Convert the ASCII above into screen codes.
  for (i=0;i<20;i++)
    msg[i] -= 0x20;

  // Set colors, since the OS is running, we set the shadow registers
  OS.color0 =
    OS.color1 =
    OS.color2 =
    OS.color3 = 0; // set all other colors to 0
  OS.color4 = 0xCA; // Set background to green.
  
  // Set the display list. The void is needed because we specified const void above to put
  // the original display list in ROM
  OS.sdlst = (void *)&dlist;

  // Sit and spin.
  while(1);
}
