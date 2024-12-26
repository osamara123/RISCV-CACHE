#include <Keypad.h>
#include <LiquidCrystal.h>
#include <SPI.h>
#include <Ethernet.h>
#include <string.h>
// #include <WString.h>


// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED
};
IPAddress ip(169, 254, 1, 100);


// Initialize the Ethernet server library
// with the IP address and port you want to use
// (port 80 is default for HTTP):
EthernetServer server(80);
LiquidCrystal lcd(8, 9, 52, 5, 6, 7);


const byte ROWS = 4; // four rows
const byte COLS = 4; // four columns


// define the symbols on the buttons of the keypads
char hexaKeys[ROWS][COLS] = {
    {'E', 'm', '0', 'm'},
    {'m', '9', '8', '7'},
    {'m', '6', '5', '4'},
    {'S', '3', '2', '1'}};


byte rowPins[ROWS] = {22, 24, 26, 28}; // connect to the row pinouts of the keypad
byte colPins[COLS] = {30, 32, 34, 36}; // connect to the column pinouts of the keypad


// initialize an instance of class NewKeypad
Keypad keypad = Keypad(makeKeymap(hexaKeys), rowPins, colPins, ROWS, COLS);
float tem(const float temPin[]);
void ethernet (int t, int index);
bool opto(int cur_door);
/*
bool entrance {
true_1,
false_2
};
*/
enum State {
  YEAR_IN,
  WWI_IN,
  WWII_IN,
  AUC_IN,
  CO_IN,
  WORLD_IN,
  NO_IN,
  DONE
};


//entrance currentstate =  true_1;
State currentState = YEAR_IN;


int ans[6] = {2024, 1914 ,1945, 1919, 3503, 195}; // Answers for the six questions
int currentAns = 0;
int tries = 0;
int right = 0;
int hard_luck = 0;
int go = 0;
int chec[3] = {0,0,0};
const float temPin[] = {A8, A9, A10, A11};  
// const int Enable = 49;
const int motorPin1 = 47;
const int motorPin2 = 45;
// LEDS pins
const int pin1 = 38;
const int pin2 = 40;
const int pin3 = 42;
const int pin4 = 44;
const int pin5 = 46;
const int pin6 = 48;
unsigned long opto1Time = 0;
unsigned long opto2Time = 0;




void setup()
{
    Serial.begin(9600);
    lcd.begin(16, 2);
    setup_ethernet();
    lcd.clear();
    lcd.print("Welcome to");
    lcd.setCursor(0,1);
    lcd.print("the maze!");
}
void setup_ethernet ()
{
      // You can use Ethernet.init(pin) to configure the CS pin
    //Ethernet.init(10);  // Most Arduino shields
    //Ethernet.init(5);   // MKR ETH Shield
    //Ethernet.init(0);   // Teensy 2.0
    //Ethernet.init(20);  // Teensy++ 2.0
    //Ethernet.init(15);  // ESP8266 with Adafruit FeatherWing Ethernet
    //Ethernet.init(33);  // ESP32 with Adafruit FeatherWing Ethernet
 
    // Open serial communications and wait for port to open:
    Serial.begin(9600);
    while (!Serial) {
      ; // wait for serial port to connect. Needed for native USB port only
    }
    Serial.println("Ethernet WebServer Example");
 
    // start the Ethernet connection and the server:
    Ethernet.begin(mac, ip);
 
    // Check for Ethernet hardware present
    if (Ethernet.hardwareStatus() == EthernetNoHardware) {
      Serial.println("Ethernet shield was not found.  Sorry, can't run without hardware. :(");
      while (true) {
        delay(1); // do nothing, no point running without Ethernet hardware
      }
    }
    if (Ethernet.linkStatus() == LinkOFF) {
      Serial.println("Ethernet cable is not connected.");
    }
 
    // start the server
    server.begin();
    Serial.print("server is at ");
    Serial.println(Ethernet.localIP());
}


void loop()
{
    lcd.setCursor(0, 0);
    char key;
    String val = "";
    int t = 0;
    bool enter;
   
    t = tem(temPin);
    fan(t);
   
    //String question[] = " ";
    int index;


   if ((enter == 0) || (go == 1)) {
    enter = opto(index);
    switch(currentState) {
       
        case YEAR_IN:
            index = 0;
            lcd.clear();
            lcd.print("What year are we");
            lcd.setCursor(0, 1);
            lcd.print("in?");
            doors(ans[currentAns], key, val);
            delay(1000);
            break;
        case WWI_IN:
            index = 1;
            pinMode(pin1, OUTPUT);
            digitalWrite(pin1, HIGH);
           
            lcd.clear();
            lcd.print("When was WW1?");
            doors(ans[currentAns], key, val);
            delay(1000);
            break;
        case WWII_IN:
            index = 2;
            pinMode(pin2, OUTPUT);
            digitalWrite(pin2, HIGH);
           
            lcd.clear();
            lcd.print("When was WW2?");
            doors(ans[currentAns], key, val);
            delay(1000);
            break;            
          case AUC_IN:
            index = 3;
            pinMode(pin3, OUTPUT);
            digitalWrite(pin3, HIGH);
           
            lcd.clear();
            lcd.print("When was AUC");
            lcd.setCursor(0, 1);
            lcd.print("founded?");
            doors(ans[currentAns], key, val);
            delay(1000);
            break;  
          case CO_IN:
            pinMode(pin4, OUTPUT);
            digitalWrite(pin4, HIGH);
           
            index = 4;
            lcd.clear();
            lcd.print("What's the ");
            lcd.setCursor(0, 1);
            lcd.print("course number?");
            doors(ans[currentAns], key, val);
            delay(1000);
            break;      
          case WORLD_IN:
            index = 5;
            pinMode(pin5, OUTPUT);
            digitalWrite(pin5, HIGH);
           
            lcd.clear();
            lcd.print("How many countries");
            lcd.setCursor(0, 1);
            lcd.print("are in the world?");
            doors(ans[currentAns], key, val);
            delay(1000);
            break;  
          case DONE:
            pinMode(pin6, OUTPUT);
            digitalWrite(pin6, HIGH);
            break;  
    }
 
  ethernet (t, index);
  go = 1;
        }
 
else {
  lcd.clear();
  lcd.print("Maze is full.");
}
}
