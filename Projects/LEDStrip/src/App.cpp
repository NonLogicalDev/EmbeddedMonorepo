#include "App.h"


// fill the dots one after the other with said color
// good for testing purposes
//void colorWipe(uint16_t c, int wait) {
//  int i;
//
//  for (i=0; i < strip.numPixels(); i++) {
//    strip.setPixelColor(i, c);
//
//    strip.show();
//    delay(wait);
//  }
//}
//
//void solidColor(uint16_t c, int wait) {
//  int i;
//
//  for (i=0; i < strip.numPixels(); i++) {
//    strip.setPixelColor(i, c);
//    strip.show();
//  }
//  delay(wait);
//}

// Create a 15 bit color value from R,G,B
unsigned int Color(byte r, byte g, byte b) {
  //Take the lowest 5 bits of each value and append them end to end
  return( ((unsigned int)g & 0x1F )<<10 | ((unsigned int)b & 0x1F)<<5 | (unsigned int)r & 0x1F);
}

//Input a value 0 to 127 to get a color value.
//The colours are a transition r - g -b - back to r
unsigned int Wheel(byte WheelPos)
{
  byte r,g,b;
  switch(WheelPos >> 5)
  {
    case 0:
      r=31- WheelPos % 32;   //Red down
      g=WheelPos % 32;      // Green up
      b=0;                  //blue off
      break;
    case 1:
      g=31- WheelPos % 32;  //green down
      b=WheelPos % 32;      //blue up
      r=0;                  //red off
      break;
    case 2:
      b=31- WheelPos % 32;  //blue down
      r=WheelPos % 32;      //red up
      g=0;                  //green off
      break;
  }
  return(Color(r,g,b));
}
