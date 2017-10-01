#include <Arduino.h>
#include <EEPROM.h>

#include <Bounce2.h>
#include <LPD6803.h>

#include "App.h"

// SETTINGS -----------------------------------------------------------

#define MODE_SWITCH_BUTTON_PIN A0
#define DATA_PIN               3
#define CLOCK_PIN              2
#define INDICATOR_PIN          13
#define LED_COUNT              36 //12 //36

// GLOBAL DATA --------------------------------------------------------

struct mem_map_sruct {
  char magic[4];
  int mode;
};

mem_map_sruct mem_map;

LPD6803 strip = LPD6803(LED_COUNT, DATA_PIN, CLOCK_PIN);
Bounce modeSwitchButton = Bounce();

bool indicator = true;
int indicator_timer = 0;
bool modeSwitchReleased = true;

Diff<int> mode(0);

StripCycle *currentCycle;


RainbowCycle rainbowCycleSM(&strip);
ColorWipeCycle colorWipeCycleSM(&strip);
SolidColorCycle solidColorCycleBlueSM(&strip, 31, 0, 0);
SolidColorCycle solidColorCycleRedSM(&strip, 0, 31, 0);
SolidColorCycle solidColorCycleGreenSM(&strip, 0, 0, 31);
SolidGradientCycle solidGradientCycleSM(&strip, 0, 0, 31,  31, 0, 0);
WaveCycle waveCycleSM(&strip, 0, 0, 31,  31, 0, 0,  20);

#define NUM_MODES 7

//---------------------------------------------------------------------
//                             RUN LOOP                               -
//---------------------------------------------------------------------

void setup() {
  EEPROM.get(0, mem_map);
  if (mem_map.magic[0] == 'L' &&
      mem_map.magic[1] == 'E' &&
      mem_map.magic[2] == 'D' &&
      mem_map.magic[3] == 'S') {
    mode.set(mem_map.mode % NUM_MODES);
  } else {
    mode.set(0);

    mem_map.mode = 0;
    mem_map.magic[0] = 'L';
    mem_map.magic[1] = 'E';
    mem_map.magic[2] = 'D';
    mem_map.magic[3] = 'S';

    EEPROM.put(0, mem_map);
  }

  pinMode(INDICATOR_PIN, OUTPUT);

  strip.setCPUmax(50);
  strip.begin();
  strip.show();

  rainbowCycleSM.init();

  modeSwitchButton.attach(MODE_SWITCH_BUTTON_PIN);
  modeSwitchButton.interval(10);
  modeSwitchReleased = true;

  Serial.begin(9600);
}


void loop() {
  modeSwitchButton.update();
  if (modeSwitchButton.read() == HIGH ) {
    if (modeSwitchReleased) {
      int new_mode = (mode.get() + 1) % NUM_MODES;
      mode.set(new_mode);
      mem_map.mode = new_mode;
      EEPROM.put(0, mem_map);
    }
    modeSwitchReleased = false;
  } else {
    modeSwitchReleased = true;
  }

  switch(mode.get()) {
    case 0:
      currentCycle = &rainbowCycleSM;
      break;
    case 1:
      currentCycle = &colorWipeCycleSM;
      break;
    case 2:
      currentCycle = &solidColorCycleBlueSM;
      break;
    case 3:
      currentCycle = &solidColorCycleRedSM;
      break;
    case 4:
      currentCycle = &solidColorCycleGreenSM;
      break;
    case 5:
      currentCycle = &solidGradientCycleSM;
      break;
    case 6:
      currentCycle = &waveCycleSM;
      break;
    default:
      break;
  }

  if(mode.hasChanged()) {
    currentCycle->init();
    mode.confirm();
  }

  // if (millis() - time_reg1 > 50) {
  //   time_reg1 = millis();
  //   currentCycle->step();
  //   Serial.println(millis() - time_reg1);
  // }
  currentCycle->step();

  indicator_timer += 1;
  if(indicator_timer % 7 == 0) {
    indicator = !indicator;
    indicator_timer = 0;
  }

//  if (mode.get() == 0) {
    if(indicator) {
      digitalWrite(INDICATOR_PIN, HIGH);
    } else {
      digitalWrite(INDICATOR_PIN, LOW);
    }
//  }

  delay(50);
}


// vim: ft=cpp
