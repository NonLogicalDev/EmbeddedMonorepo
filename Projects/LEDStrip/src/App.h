#ifndef APP
#define APP

#include <Arduino.h>

#include <TimerOne.h>
#include <Bounce2.h>
#include <LPD6803.h>

// FWD DECLARE --------------------------------------------------------

//void colorWipe(uint16_t c, int wait);
//void solidColor(uint16_t c, int wait);
unsigned int Color(byte r, byte g, byte b);
unsigned int Wheel(byte WheelPos);


template <class T> class Diff {
  T curr;
  T prev;
public:
  Diff(T init) {
    prev = curr = init;
  }

  T get() {
    return curr;
  }

  void set(T newVal) {
    prev = curr;
    curr = newVal;
  }

  void confirm() {
    prev = curr;
  }

  bool hasChanged() {
    return prev != curr;
  }
};


class StripCycle {
protected:
  LPD6803 *strip;
public:
  virtual void init() = 0;
  virtual bool step() = 0;
};


class ColorWipeCycle: public StripCycle {
  static const int colorsSize = 3;
  uint16_t colors[colorsSize];
  int cSel;

  int i;
public:
  ColorWipeCycle(LPD6803 *strip) {
    this->strip = strip;
    init();
    colors[0] = Color(63, 0, 0);
    colors[1] = Color(0, 63, 0);
    colors[2] = Color(0, 0, 63);
  }

  void init() {
    cSel = 0;
    i = 0;
  }

  bool step() {
    if (i >= strip->numPixels()) {
      cSel++;
      i = 0;
    }

    uint16_t c = colors[cSel % colorsSize];

    //for (i=0; i < strip.numPixels(); i++) {
    strip->setPixelColor(i, c);
    strip->show();
    //delay(wait);
    //}

    i++;
    return false;
  }
};


class SolidColorCycle: public StripCycle {
  uint16_t c;
public:
  SolidColorCycle(LPD6803 *strip, int r, int g, int b) {
    this->strip = strip;
    this->c = Color(r, g, b);
    init();
  }

  void init() { }

  bool step() {
    for (int i=0; i < strip->numPixels(); i++) {
      strip->setPixelColor(i, c);
      strip->show();
    }
    return false;
  }
};

class SolidGradientCycle: public StripCycle {
  int j;
  byte r1; byte g1; byte b1; byte r2; byte g2; byte b2;
  LPD6803 *strip;
public:

  SolidGradientCycle(LPD6803 *strip, byte r1, byte g1, byte b1, byte r2, byte g2, byte b2) {
    this->strip = strip;

    this->r1 = r1;
    this->g1 = g1;
    this->b1 = b1;

    this->r2 = r2;
    this->g2 = g2;
    this->b2 = b2;

    init();
  }

  void init() { }
  bool step() {
    for (int i=0; i < strip->numPixels(); i++) {
      float blend = (float)(i+1) / (float)strip->numPixels();
      strip->setPixelColor(i, this->lerp(r1,g1,b1, r2,g2,b2, blend));
    }
    strip->show();   // write all the pixels out
    return false;
  }

  uint16_t lerp(int r1, int g1, int b1, int r2, int g2, int b2, float blend) {
    return Color(
        (byte)(r1 * blend + r2 * (1- blend)),
        (byte)(g1 * blend + g2 * (1- blend)),
        (byte)(b1 * blend + b2 * (1- blend))
    );
  }
};

class WaveCycle: public StripCycle {
  const int step_size = 10;
  int j;
  int ctr;
  int len;
  byte r1; byte g1; byte b1; byte r2; byte g2; byte b2;
  LPD6803 *strip;
public:

  WaveCycle(LPD6803 *strip, byte r1, byte g1, byte b1, byte r2, byte g2, byte b2, int len) {
    this->strip = strip;

    this->r1 = r1;
    this->g1 = g1;
    this->b1 = b1;

    this->r2 = r2;
    this->g2 = g2;
    this->b2 = b2;

    this->len = len;

    init();
  }

  void init() {
    j = 0;
    ctr = 0;
  }

  bool step() {
    if (j >= len * 2) {
      j = 0;
    }

    for (int i=0; i < strip->numPixels(); i++) {

      double step =  ctr / (double)step_size;
      float blend_full = ((float)((i + j) % len) + step)  / (float)(len);

      double blend = blend_full;
      if (blend >= 0.5) {
        blend = 1 - blend_full;
      }

      blend = blend * 2;

      if (blend >= 1) {
        blend = 1;
      }

      strip->setPixelColor(i, this->lerp(r1,g1,b1, r2,g2,b2, blend));
    }

    strip->show();   // write all the pixels out

    ctr = (ctr + 1) % step_size;
    if (ctr == 0) {
      j += 1;
    }

    return false;
  }

  uint16_t lerp(int r1, int g1, int b1, int r2, int g2, int b2, float blend) {
    return Color(
        rnd(r1 * blend + r2 * (1- blend)),
        rnd(g1 * blend + g2 * (1- blend)),
        rnd(b1 * blend + b2 * (1- blend))
    );
  }

  byte rnd(float num) {
    byte whole = (byte)num;
    num = num - whole;
    if (num >= 0.5) {
      whole += 1;
    }
    return whole;
  }
};

class RainbowCycle: public StripCycle {
  int j;
  LPD6803 *strip;
public:

  RainbowCycle(LPD6803 *strip) {
    this->strip = strip;
    init();
  }

  void init() {
    j = 0;
  }

  bool step() {
    if (j >= 96) {
      j = 0;
    }

    for (int i=0; i < strip->numPixels(); i++) {
      // tricky math! we use each pixel as a fraction of the full 96-color wheel
      // (thats the i / strip.numPixels() part)
      // Then add in j which makes the colors go around per pixel
      // the % 96 is to make the wheel cycle around
      strip->setPixelColor(i, Wheel( ((i * 96 / strip->numPixels()) + j) % 96) );
    }
    strip->show();   // write all the pixels out

    j += 1;
    return false;
  }
};

#endif
