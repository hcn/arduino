
#include <Peggy2.h>

struct Bokstav
{
  //  Linjevis nedenfra
  int p[20];
  int bredde,lengde;
public:
  Bokstav(int i) {

  }
  Bokstav(char* t) {
    
    char* pek=t;
    char ch;
    // p=t;
    int i=0;
    while (ch=*pek) {
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
      pek++;
    } 

  }

  void putFrame(Peggy2& f,int gy,int gx){
    int kx=0;
    for(int y=gy+4;y>=gy;y--) {

      for(int x=gx;x<gx+4;x++) {
        if (this->p[kx]) {
          f.SetPoint(x,y);
        } 
        else {
          f.ClearPoint(x,y);
        }
        kx++;
      }
    }
  }

};
Bokstav bb("xxx. x..x xxx. x..x xxx.");
Bokstav aa("x..x x..x xxxx x..x xxxx");

Bokstav d0(".xx. x..x x..x x..x .xx.");
Bokstav d1("..x. ..x. ..x. ..x. .xx.");
Bokstav d2("xxxx .x.. ..x. x..x .xx.");
Bokstav d3("xxx. ...x .xx. ...x xxx.");
Bokstav d4("..x. xxxx x.x. .xx. ..x.");
Bokstav d5("xxx. ...x xxx. x... xxxx");
Bokstav d6(".xx. x..x xxx. x... .xx.");
Bokstav d7(".x.. .x.. ..x. ...x xxxx");
Bokstav d8(".xx. x..x .xx. x..x .xx.");
Bokstav d9(".xx. ...x .xxx x..x .xx.");


Peggy2 displayArea;
int nextsek=1;

Bokstav tall[]={
  d0,d1,d2,d3,d4,d5,d6,d7,d8,d9};

unsigned char InputReg,InputRegOld;

int TOTAL=600;

int total;

void initAll(){
  total=TOTAL;
}




void setup()                    // run once, when the sketch starts
{
  displayArea.HardwareInit();   // Call this once to init the hardware. 

  PORTD = 0U;			//All B Input
  DDRD = 255U;		// All D Output

  PORTB = 1;		// Pull up on ("OFF/SELECT" button)
  PORTC = 255U;	// Pull-ups on C

  DDRB = 254U;  // B0 is an input ("OFF/SELECT" button)
  DDRC = 0;	



  InputRegOld = (PINC & 31) | ((PINB & 1)<<5);


  initAll();

}

void blink() {
  for(int y=0;y<25;y++) {

    for(int x=0;x<25;x++) {
      displayArea.SetPoint(x,y);


    }
  }
  displayArea.RefreshAll(100);

  displayArea.Clear();
  displayArea.RefreshAll(100);

}

void putTall(int verdi,int x,int y) {
  Bokstav t=tall[verdi];
  t.putFrame(displayArea,x,y);
}



void loop()                     // run over and over again
{ 

  unsigned long time=millis();
  long cur=time;
  long en=1000L;
  long sek=cur/en;



  InputReg = (PINC & 31) | ((PINB & 1)<<5);

  if (InputReg != InputRegOld) {
    initAll();

    InputRegOld=InputReg;
 
  }


  if (sek > nextsek) {
    nextsek=sek;

    if (total < 0) {

      blink();
    } 
    else {

      int dmin=total/60;
      int dsek=total-(dmin*60);

      int d10min=dmin/10;
      int d1min=dmin-(d10min*10);
      int d10sek=dsek/10;
      int d1sek=dsek-(d10sek*10);


      putTall(d10min,10,0);
      putTall(d1min,10,5);
      putTall(d10sek,10,10);
      putTall(d1sek,10,15);


      displayArea.RefreshAll(100);
      
      total--;

    }
  } 
  else {
    displayArea.RefreshAll(100);
  }

}















