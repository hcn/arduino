

const byte ledCharSet[10] = {

 B00111111,B00000110,B01011011,B01001111,B01100110,B01101101,B01111101,B00000111,B01111111,B01101111
};


int val = 0;
int state = 7;
int x = 0;
int i = 0;

#define SLIDER1  0
#define SLIDER2  1
#define SLIDER3  2
#define KNOCK    5


#define BUTTON1  13
#define BUTTON2  12
#define BUTTON3  11

#define LED1  5
#define LED2  6

#define BUZZER   3

#define SLIDER_TEST 1
#define BUZZER_TEST 2
#define KNOCK_TEST  3
#define TEMP_TEST  4
#define LIGHT_TEST 5
#define BUTTON_TEST 6
#define SEVENSEG_TEST 7

#define TEMP  4
#define LIGHT  3

#define LATCH 7
#define CLOCK 8
#define DATA 4

void setup()
{
  Serial.begin(9600);
  pinMode(BUZZER, OUTPUT);
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LATCH, OUTPUT);
  pinMode(CLOCK, OUTPUT);
  pinMode(DATA,OUTPUT);
  
  //pinMode(BUTTON1, INPUT);
  Serial.println("Danger Shield Component Test");  
  Serial.println("Press Button 1 to begin.");  
}

void loop()
{
  
 
  /* if(!(digitalRead(BUTTON2)))
  {
    delay(1); // Debounce
    state++;
    if(state > 7){ state = 1; }
    while(!(digitalRead(BUTTON2)));
  }*/

  if(state == SLIDER_TEST)
  {
    Serial.print("Sliders: ");
    val = analogRead(SLIDER1);
    Serial.print(" ");
    Serial.print(val);
    val = analogRead(SLIDER2);
    Serial.print("  ");
    Serial.print(val);
    val = analogRead(SLIDER3);
    Serial.print("  ");
    Serial.println(val);
    delay(300);
  }

  if(state == BUZZER_TEST)
  {
    for(int x = 0; x < 100; x++)
    {
      digitalWrite(BUZZER, HIGH);
      delay(1);
      digitalWrite(BUZZER, LOW);
      delay(1);
    }
  }

  if(state == KNOCK_TEST)
  {
    val = analogRead(KNOCK);
    if(val > 10)
    {
      Serial.println("Knock Received");
      digitalWrite(LED1,HIGH);
    }
  }
  
  if(state == TEMP_TEST)
  {
    val = analogRead(TEMP);
    Serial.print("Temp: ");
    Serial.println(val);
  }

  if(state == LIGHT_TEST)
  {
    val = analogRead(LIGHT);
    Serial.print("Light: ");
    Serial.println(val);
  }

  if(state == BUTTON_TEST)
  {  
    Serial.println("Button 2 & 3 Test");
    if(digitalRead(BUTTON3) || digitalRead(BUTTON3))
    {
      digitalWrite(LED2,HIGH);
    }
    else
    {
      digitalWrite(LED2,LOW);
    }
  }
  
  if(state == SEVENSEG_TEST)
  {
    i = 0;
    while(1)
    {
    
    digitalWrite(LATCH,LOW);
    shiftOut(DATA,CLOCK,MSBFIRST,~(ledCharSet[i]));
    digitalWrite(LATCH,HIGH);
    i++;
    if(i==10){i = 0;}
    delay(500);
    }
  }
}

