/* Simple example code for Peggy 2.0, using the Peggy2 library, version 0.2.
 
 Initialize a single frame buffer array, draw a few dots, one at a time it with dots, and display it.
 
 Copyright (c) 2008 Windell H Oskay.  All right reserved.
 
 This example is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This software is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this software; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */


#include <Peggy2.h>

#include "WProgram.h"
void setup();
void loop();
struct Bokstav
{
  //  Linjevis nedenfra
  int p[20];
public:
  Bokstav(int i) {

  }
  Bokstav(char* t) {
    char* p=t;
    char ch;
    // p=t;
    int i=0;
    while (ch=*p) {
      switch (ch) {
      case 'x':
        this->p[i++]=1;
        break;
      case '.':
        this->p[i++]=0;
        break;
      default:

        break;
      } 
      p++;
    } 

  }

  void putFrame(Peggy2& f,int gy,int gx){
    int kx=0;
    for(int y=gy+4;y>=gy;y--) {

      for(int x=gx;x<gx+4;x++) {
        if (this->p[kx]) {

          f.SetPoint(x,y);
        }
        kx++;
      }
    }
  }
  void blankFrame(Peggy2& f,int gy,int gx){

    for(int y=gy+4;y>=gy;y--) {

      for(int x=gx;x<gx+4;x++) {
        f.ClearPoint(x,y);


      }
    }
  }
};
Bokstav bb("xxx. x..x xxx. x..x xxx.");
Bokstav aa("x..x x..x xxxx x..x xxxx");

Bokstav d0(".xx. x..x x..x x..x .xx.");
Bokstav d1("..x. ..x. ..x. .xx. ..x.");
Bokstav d2("xxxx .x.. ..x. x..x .xx.");
Bokstav d3("xxx. ...x xxx. ...x xxx.");
Bokstav d4("..x. xxxx x.x. .xx. ..x.");
Bokstav d5("xxx. ...x xxx. x... xxxx");
Bokstav d6(".xx. x..x xxx. x... .xx.");
Bokstav d7("..x. ..x. ..x. ...x xx..");
Bokstav d8(".xx. x..x .xx. x..x .xx.");
Bokstav d9(".xx. ...x .xxx x..x .xx.");
// Bokstav b(1);

Peggy2 displayArea;     // Make a first frame buffer object, called displayArea
int i=0;
int nextsek=1;
int xpos=0;
int ypos=0;
int bix=0;
Bokstav& bokstav=aa;
Bokstav tall[]={d0,d1,d2,d3,d4,d5,d6,d7,d8,d9};

unsigned char InputReg,InputRegOld;

void setup()                    // run once, when the sketch starts
{
  
  
PORTD = 0U;			//All B Input
DDRD = 255U;		// All D Output

PORTB = 1;		// Pull up on ("OFF/SELECT" button)
PORTC = 255U;	// Pull-ups on C

DDRB = 254U;  // B0 is an input ("OFF/SELECT" button)
DDRC = 0;	

  displayArea.HardwareInit();   // Call this once to init the hardware. 
  
  InputRegOld = (PINC & 31) | ((PINB & 1)<<5);
 

}  // End void setup()  



void loop()                     // run over and over again
{ 

  unsigned long time=millis();
  long cur=time;
  long en=1000L;
  long sek=cur/en;
  
  InputReg = (PINC & 31) | ((PINB & 1)<<5);
  
  if (InputReg != InputRegOld) {
    InputRegOld=InputReg;
    bix=0;
  }
  


  if (sek > nextsek) {
    nextsek=sek;
    
    Bokstav bok=tall[bix];
    
    bok.putFrame(displayArea,xpos,ypos);

    displayArea.RefreshAll(100);
    
//    Bokstav bok=tall[1];

    bok.blankFrame(displayArea,xpos,ypos);

   // xpos=xpos+1;
   // ypos=ypos+1;
    bix++;
    
    if (bix>9) bix=0;
    
    if (xpos>20 || ypos >20) {
      xpos=0;
      ypos=0;
      //bokstav=bb;
    }
  }

}











int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

