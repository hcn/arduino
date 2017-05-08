#include <Peggy2.h>

#include "WProgram.h"
void setup();
void loop();
Peggy2 frame;

struct Bokstav
{
  //  Linjevis nedenfra
  int p[20];

public:
  Bokstav(char* t) {
    char *p;
    char ch;
    p=t;
    int i=0;
    while (ch=*p++) {
      switch (ch) {
      case 'x':
        p[i++]=1;
        break;
      case ' ':
        break;
      default:
        p[i++]=0;
        break;
      }
    } 



  }
  Bokstav(int ap[20])
  {
    for (int i=0;i<20;i++) p[i]=ap[i];
  }

  void putFrame(Peggy2& f){
    f.WritePoint(1,1,1);
  }

};

int ap[20]={
  1,0,0,1,
  1,0,0,1,
  1,1,1,1,
  1,0,0,1,
  1,1,1,1};
Bokstav a(ap);
Bokstav b("xxxx x..x xxx. x..x xxxx");




void setup()
{
  frame.HardwareInit();   // Call this once to init the hardware. 
  a.putFrame(frame);

}

// ------------------------------------------------------------
// loop
// ------------------------------------------------------------
void loop()
{

  frame.RefreshAll(10);
}





int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

