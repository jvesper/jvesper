#include <Servo.h>
//Servo motor
Servo hazardBot;
int sPin = 3;

//Distance Sensor
int trig = 11;
int echo = 10;

//DC motors
int motorpin1 = 6;
int motorpin2 = 5;

//Distance measurements
float time;
float distance;
float inchMin = 5.0;


//Gas Sensor
int MQ2pin = A0;
const int gas = 0;

//Alarm
const int alarm = 4;

//LED lights
int red = A2;
int blue = A3;
int green = A4;

//Temp Sensor
int tooHot = 0;							//Baseline temperature 
int cels = 0;							//celsius
int fahr = 0;							//farenheit 
int tSensor = A1;

void setup(){
//Inputs and outputs
  
	Serial.begin(9600); 				//Serial monitor
	
  
  	//Temp Sensor
  	pinMode(tSensor, INPUT);
  
  	//DC Motor
	pinMode(motorpin1, OUTPUT);
    pinMode(motorpin2, OUTPUT);

	//Distance Sensor  
    pinMode(trig, OUTPUT);
    pinMode(echo, INPUT);
  
	
  	//Servo motor
    hazardBot.attach(sPin);
    pinMode(sPin, OUTPUT);  
  
  	//Alarm
  	pinMode(alarm, OUTPUT);
  
  
  	
}

void loop(){
  	//Gas sensor
  	float gasVal, MQ2pin;
   	gasVal = analogRead(MQ2pin); 				//Read analog input A1
  	
  	//Temp Sensor
  	tooHot = 130;
  	cels = map(((analogRead(tSensor) - 20) * 3.04), 0, 1023, -40, 125);
  	fahr = ((cels * 9) / 5 + 32);
  	
  	if(fahr >= tooHot){
      digitalWrite(red, HIGH);					//light up red led for heat hazard
      digitalWrite(blue, LOW);
      digitalWrite(green, LOW);
      tone(alarm, 1000, 2000);					//different tone for heat haz
      Serial.println("HAZARDOUS TEMPERATURES");
      Serial.println(fahr);
      delay(1000);
    }
  else if (fahr < tooHot & gasVal <= 85){
    digitalWrite(red, LOW);						//turn off both LEDS
    digitalWrite(blue, LOW);
    digitalWrite(green, HIGH);
  }
  
    
  
 	
  	//Servo
  	hazardBot.write(0);
  
  	//Distance Sensor
  	digitalWrite(trig, LOW);
  	delayMicroseconds(2);
    digitalWrite(trig, HIGH);
  	delayMicroseconds(10);
    digitalWrite(trig, LOW);
    time = pulseIn(echo, HIGH); 
    distance = time/148.1;
  	
  
    
  //DC motor, Servo motor, Distance
  if (distance >= inchMin){
  	
  	digitalWrite(motorpin1, LOW);		//motors move wheels forward
    digitalWrite(motorpin2, HIGH);
    hazardBot.write(0); 	
    delay(500);							//Continue straight
  }
  
  else {
    digitalWrite(motorpin1, LOW);		//motors stop
    digitalWrite(motorpin2, LOW);
    hazardBot.write(90); 
    delay(500);							//turn robot 90 degrees
  }
  
  //Gas Sensor
  if (gasVal >85){
    digitalWrite(blue, HIGH);
    digitalWrite(green, LOW);
    digitalWrite(red, LOW);
    tone(alarm, 800, 1000);  			//800 Hz 		  
    Serial.println("!! HAZARDOUS LEVELS OF GAS DETECTED !!");
    Serial.println(gasVal);
    delay(500);
    
    
  }
  
  else if (gasVal <= 85 & fahr < tooHot){
    digitalWrite(green, HIGH);
    digitalWrite(red, LOW);
    digitalWrite(blue, LOW);
    tone(alarm, 0, 0);
    Serial.print("Sensor Value: ");
    Serial.println(gasVal);
     }
  
  
}

float getsensorValue(int pin){
  	return (analogRead(pin));
}

 