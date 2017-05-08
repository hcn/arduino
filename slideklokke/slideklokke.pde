
#include <Peggy2.h>
//#define printing 1

#ifdef printing
#define pprint(v) Serial.println(v)
#else
#define pprint(v)
#endif
#ifdef printing
#define pinit Serial.begin(9600)
#else
#define pinit
#endif




Peggy2 displayArea;
char buf[500];
int bufp=0;

int bredde=6;
int hoyde=7;

enum press {
  ingen,kort,lang};

int doneit=0;



struct Button
{
  int linjen;
  int oldVal;
  long timer,timerStart;

public:
  Button(int linje) {
    this->linjen=linje;
    this->oldVal=HIGH;
    this->timer=0;
    this->timerStart=0;

    pinMode(linje, INPUT);
    digitalWrite(linje,HIGH);
  }

  int pressed() {
    int newVal=digitalRead(this->linjen);  
    int pres=(newVal && (newVal != this->oldVal));

    this->oldVal=newVal;

    return pres;        
  }


  press timedPress() {
    int newVal=digitalRead(this->linjen);  
    int pres=(newVal && (newVal != this->oldVal));

    //   if (pres) Serial.print("---------------------------------------------------");
    //   Serial.print(this->oldVal);
    //   Serial.print(newVal);
    //   Serial.println(pres);

    checkTimer(this->oldVal,newVal);

    this->oldVal=newVal;

    int mill=this->timer - this->timerStart;
    //  if (pres) Serial.println(mill);

    if (pres) {
      this->timer=0;
      this->timerStart=0;
    }

    if (pres && (mill > 1000)){
      return lang;
    } 
    else if (pres) {
      return kort;
    } 
    else {
      return ingen;
    }

    // return (pres && (mill > 1000));        
  }

  void checkTimer(int gml,int ny) {
    if (this->timer >0) {
      this->timer=millis();
      return;
    } 
    else if (gml==0 && ny==0) {
      this->timer=this->timerStart=millis();
    }


  }
};


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

  Bokstav(int i) {

    this->bp=bufp;

    bufp=bufp+bredde*hoyde;



  }

  void putFrame(Peggy2& f,int gy,int gx){
    int kx=this->bp;
    //Serial.println(kx);
    for(int y=gy+hoyde;y>gy;y--) {

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

  char* getVerdi() {

    return &(buf[this->bp]);



  }

  void setVal(char* dat,int start,int dstart,int ant) {



    for (int i=0;i<ant;i++) {
      buf[start+i]=dat[dstart+i];


    }
  }

};

Bokstav slide(1);
//Bokstav bb("xxx. x..x xxx. x..x xxx.");
//Bokstav aa("x..x x..x xxxx x..x xxxx");

// Bokstav d0(".xx. x..x x..x x..x .xx.");
//Bokstav d1("..x. ..x. ..x. ..x. .xx.");
//Bokstav d2("xxxx .x.. ..x. x..x .xx.");
//Bokstav d3("xxx. ...x .xx. ...x xxx.");
//Bokstav d4("..x. xxxx x.x. .xx. ..x.");
//Bokstav d5("xxx. ...x xxx. x... xxxx");
//Bokstav d6(".xx. x..x xxx. x... .xx.");
//Bokstav d7(".x.. .x.. ..x. ...x xxxx");
//Bokstav d8(".xx. x..x .xx. x..x .xx.");
//Bokstav d9(".xx. ...x .xxx x..x .xx.");

Bokstav d0(".xxxx. xx..xx xx..xx xx..xx xx..xx xx..xx .xxxx.");
Bokstav d1("...xx. ...xx. ...xx. ...xx. ...xx. ..xxx. ...xx.");
Bokstav d2("xxxxxx xx.... .xx... ..xxx. ....xx xx..xx .xxxx.");
Bokstav d3(".xxxx. xx..xx ....xx ..xxx. ....xx xx..xx .xxxx.");
Bokstav d4("...xx. ...xx. xxxxxx x..xx. .x.xx. ..xxx. ...xx.");
Bokstav d5(".xxxx. ....xx ....xx .xxxx. .xx... .xx... .xxxxx");
Bokstav d6(".xxxx. xx..xx xx..xx xxxxx. xx.... .xx... ..xxx.");
Bokstav d7("..xx.. ..xx.. ..xx.. ...xx. ...xx. ....xx xxxxxx");
Bokstav d8(".xxxx. xx..xx xx..xx .xxxx. xx..xx xx..xx .xxxx.");
Bokstav d9(".xxx.. ...xx. ....xx .xxxxx xx..xx xx..xx .xxxx.");



int nextsek=1;

Bokstav tall[]={
  d0,d1,d2,d3,d4,d5,d6,d7,d8,d9};

int TOTAL=600;

int total;

Button os(8);

void initAll(int len){
  total=len;
}


void setup()                    // run once, when the sketch starts
{
  pinit;

  pprint("Start");
  displayArea.HardwareInit();

  initAll(TOTAL);



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

void slideTall(int verdi,int verdiOld,int x,int y,int fak) {

  if(doneit) return;
  // doneit=1;

  Bokstav t=tall[verdi];
  Bokstav told=tall[verdiOld];
  char* ny=t.getVerdi();
  char *old=told.getVerdi();

  if (fak>0) {
    slide.setVal(ny,0,42-fak*6,fak*6);
  }
  if (fak < 7) {
    slide.setVal(old,fak*6,0,42-fak*6);
  }
  char* sl=slide.getVerdi();

  for (int i=0;i<42;i++){
    int iv=sl[i];
    pprint(iv);

  }

  slide.putFrame(displayArea,x,y);







}



//t.putFrame(displayArea,x,y);




void loop()
{ 

  // pprint("Loop");

  unsigned long time=millis();
  long cur=time;
  long en=1000L;
  long sek=cur/en;



  switch (os.timedPress()){
  case lang:
    initAll(TOTAL/2);
    break;
  case kort:
    initAll(TOTAL);
    break;

  }


  if (sek > nextsek) {
    // Serial.println("Nest");
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
      int d1sekOld=d1sek-1;
      if (d1sekOld<0) d1sekOld=9;


      putTall(d10min,8,0);
      putTall(d1min,8,6);
      putTall(d10sek,8,13);
      for (int fak=0;fak<=7;fak++) {
      slideTall(d1sek,d1sekOld,8,19,fak);


      displayArea.RefreshAll(100);
      }

      total--;

    }
  } 
  else {
    displayArea.RefreshAll(1);
  }

}






















