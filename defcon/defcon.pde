
#include <Peggy2.h>
#include <avr/pgmspace.h>

Peggy2 displayArea;
#define B 10
#define H 12
#define BUFL 7*B*H
int bredde=B;
int hoyde=H;
int buf[BUFL];
int bufp=0;

 const prog_uint8_t BitMap[5][5] = {   // store in program memory to save RAM
        {B1100011,B1100011,B1100011,B1100011,B1100011},
        {B1100011,B1100011,B1100011,B1100011,B1100011},
        {B1100011,B1100011,B1100011,B1100011,B1100011},
        {B1100011,B1100011,B1100011,B1100011,B1100011},
        {B1100011,B1100011,B1100011,B1100011,B1100011}
    };

//int bredde=20;
//int hoyde=20;


struct Bokstav
{
  //  Linjevis nedenfra

  int bp;


public:
 
  Bokstav(char* t) {



    this->bp=bufp;

    bufp=bufp+bredde*hoyde;

    char* pek=t;
    char ch;
    
    int i=this->bp;
    while (ch=*pek) {
      switch (ch) {
      case 'x':
        buf[i++]=1;
        break;
      case '.':
        buf[i++]=0;
        break;
      default:

        break;
      } 
      pek++;
    } 

  }

  void putFrame(Peggy2& f,int gy,int gx){
    int kx=this->bp;
    //Serial.println(kx);
    for(int y=gy+hoyde-1;y>gy-1;y--) {

      for(int x=gx;x<gx+bredde;x++) {
        if (buf[kx]) {
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
//Bokstav bb("xxx. x..x xxx. x..x xxx.");
//Bokstav aa("x..x x..x xxxx x..x xxxx");

 //Bokstav d0(".xx. x..x x..x x..x .xx.");
 //Bokstav d1("..x. ..x. ..x. ..x. .xx.");
 //Bokstav d2("xxxx .x.. ..x. x..x .xx.");
//Bokstav d3("xxx. ...x .xx. ...x xxx.");
//Bokstav d4("..x. xxxx x.x. .xx. ..x.");
//Bokstav d5("xxx. ...x xxx. x... xxxx");
//Bokstav d6(".xx. x..x xxx. x... .xx.");
//Bokstav d7(".x.. .x.. ..x. ...x xxxx");
//Bokstav d8(".xx. x..x .xx. x..x .xx.");
//Bokstav d9(".xx. ...x .xxx x..x .xx.");

//Bokstav d0("xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx");
//Bokstav d1("xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx");
//Bokstav d2("xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx");
//Bokstav d3("xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx");
//Bokstav d4("xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx");
//Bokstav d5("xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx");
//Bokstav d6("xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx"); 





int nextsek=1;

//Bokstav tall[]={
//  d0,d1,d2,d3,d4,d5,d6};





unsigned char InputReg,InputRegOld;

int TOTAL=600;

int total;
int defcon=6;

void initAll(){
  defcon--;
  if (! defcon){
    defcon=6;
  }
}




void setup()                    // run once, when the sketch starts
{
  // Serial.begin(9600); 

  //Serial.println("Start");
  displayArea.HardwareInit();   // Call this once to init the hardware. 

  PORTD = 0U;			//All B Input
  DDRD = 255U;		// All D Output

  PORTB = 1;		// Pull up on ("OFF/SELECT" button)
  PORTC = 255U;	// Pull-ups on C

  DDRB = 254U;  // B0 is an input ("OFF/SELECT" button)
  DDRC = 0;	



  InputRegOld = (PINC & 31) | ((PINB & 1)<<5);


   // initAll();



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
  //Bokstav t=tall[verdi];
  //t.putFrame(displayArea,x,y);
}

void DisplayBitMap(Peggy2& f)
    {
        for (byte x=0; x<5; ++x) {
            byte data = pgm_read_byte (&BitMap[3][x]);   // fetch data from program memory
            for (byte y=0; y<7; ++y) {
                if (data & (1<<y)) {
                    f.SetPoint(x,y);
                } else {
                    f.ClearPoint(x,y);
                }
            }
        }
    }



void loop()                     // run over and over again
{ 

  //Serial.println("Loop");

  unsigned long time=millis();
  long cur=time;
  long en=1000L;
  long sek=cur/en;
  // int defcon=6;
  int forrige;





  InputReg = (PINC & 31) | ((PINB & 1)<<5);

  if (InputReg != InputRegOld) {
    initAll();

    InputRegOld=InputReg;

  }


  if (sek > nextsek) {
    // Serial.println("Nest");
    nextsek=sek;

   

      int dmin=total/60;
      int dsek=total-(dmin*60);

      int d10min=dmin/10;
      int d1min=dmin-(d10min*10);
      int d10sek=dsek/10;
      int d1sek=6;


//      putTall(d10min,8,10);
 //     putTall(d1min,8,6);
  //    putTall(d10sek,8,13);
 // blink();
      putTall(d1sek,0,0);


      displayArea.RefreshAll(100);

      total--;

   
  } 
  else {
    displayArea.RefreshAll(100);
  }

}
















