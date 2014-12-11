import oscP5.*;
import netP5.*;

/* *
 * GAVI Prototype by Spiderlily(Jing Chun Tan) - 12/2014
 * Notes and drawing are synchronised by the Draw framerate.
 * 5 SoundChiper instances are used to enable independent parts.
 * Constrained randomness maintains a balance of order and variety.
 * The music will continue as long as the drawing does.
 * Based on SoundCipher library example by Andrew R. Brown
 */
//play JavaSound synth 
import arb.soundcipher.*;

//a two-dimensional template based gesture recognition
import de.voidplus.dollar.*;
OneDollar one; //onedollar-unistroke-recognizer
String name; //type of gesture

// pitchset using SoundCipher class: play a set of notes usings JavaSound's built-in synthesiser
// 5 instances of sounds using JavaSound's built-in synthesizer
SoundCipher sc = new SoundCipher(this); 
SoundCipher sc2 = new SoundCipher(this);
SoundCipher sc3 = new SoundCipher(this);
SoundCipher sc4 = new SoundCipher(this);
SoundCipher sc5 = new SoundCipher(this);
//set of notes based on mx and my: maintain randomised harmony
float mx = constrain(mouseX, 20, 120);
float my = constrain(mouseX, 20, 120);
float[] userPitchSet = {
  mx+12, mx+14, mx+14, mx+18, mx+18, mx+24, mx, mx+24, mx, mx+44, mx+44, mx+44, mx+20, mx+20, mx+20
};
float[] pitchSet = {
  100, 100, 100, 95, 62, 64, 67, 67, 69, 62, 72, 64, 74, 76, 79
};
float setSize = pitchSet.length; //length of pitch
float keyRoot = 0;//randomise from base note 0
float density = 0.6; //variety of notes combined with random functions

//triangle coordinates
float x1, y1, x2, y2, x3, y3;
//random triangle coordinates
float rx1, ry1, rx2, ry2, rx3, ry3;

//colour vars
float r;
float g;
float b;
float a;
float diam;
float x;
float y;
float xa;
float ya;
float circleWidth;
float circleHeight;
float rMax = 0;
float gMax = 255;
float bMax = 255;
int bkg;

void setup() {
  //osc port
 // oscP5 = new OscP5(this, 12000);//port
  
  //important size, framerate and instrument setup
  size(displayWidth-100, displayHeight-100);  
  frameRate(random(8, 9));
  background(0);
  smooth();

  //sounds: 80=synth, 49=strings, 0=piano, 10=waterpiano, 30=owlcity, 40=sax, 49=strings, 100=fantasy, 105=crisp, 102=floaty, 101=ambient,
  sc3.instrument(102); //play strings chords
  sc2.instrument(10); //play piano notes
  sc.instrument(102); //play synth notes
  sc4.instrument(80);//play sharp synth
  sc5.instrument(10);//play water piano
  
  //gesture detection  
  name = " ";
  // 1. Create instance of class OneDollar:
  one = new OneDollar(this);
  println(one);                  // Print all the settings
  one.setVerbose(true);          // Activate console verbose
  // 2. Add gestures (templates):
  one.learn("triangle", new int[] {
    137, 139, 135, 141, 133, 144, 132, 146, 130, 149, 128, 151, 126, 155, 123, 160, 120, 166, 116, 171, 112, 177, 107, 183, 102, 188, 100, 191, 95, 195, 90, 199, 86, 203, 82, 206, 80, 209, 75, 213, 73, 213, 70, 216, 67, 219, 64, 221, 61, 223, 60, 225, 62, 226, 65, 225, 67, 226, 74, 226, 77, 227, 85, 229, 91, 230, 99, 231, 108, 232, 116, 233, 125, 233, 134, 234, 145, 233, 153, 232, 160, 233, 170, 234, 177, 235, 179, 236, 186, 237, 193, 238, 198, 239, 200, 237, 202, 239, 204, 238, 206, 234, 205, 230, 202, 222, 197, 216, 192, 207, 186, 198, 179, 189, 174, 183, 170, 178, 164, 171, 161, 168, 154, 160, 148, 155, 143, 150, 138, 148, 136, 148
  } 
  );
  one.learn("circle", new int[] {
    127, 141, 124, 140, 120, 139, 118, 139, 116, 139, 111, 140, 109, 141, 104, 144, 100, 147, 96, 152, 93, 157, 90, 163, 87, 169, 85, 175, 83, 181, 82, 190, 82, 195, 83, 200, 84, 205, 88, 213, 91, 216, 96, 219, 103, 222, 108, 224, 111, 224, 120, 224, 133, 223, 142, 222, 152, 218, 160, 214, 167, 210, 173, 204, 178, 198, 179, 196, 182, 188, 182, 177, 178, 167, 170, 150, 163, 138, 152, 130, 143, 129, 140, 131, 129, 136, 126, 139
  } 
  );
  // one.forget("circle");
  // 3. Bind templates to methods (callbacks):
  one.bind("triangle circle", "detected");
  // one.off("circle");
}

// 4. Implement callbacks:
void detected(String gesture, float percent, int startX, int startY, int centroidX, int centroidY, int endX, int endY) {
  println("Gesture: "+gesture+", "+startX+"/"+startY+", "+centroidX+"/"+centroidY+", "+endX+"/"+endY);    
  name = gesture;
}

void draw() {  
  //text GUI
  textSize(26); 
  fill(255); 
  noStroke();
  text("Detected gesture: "+name, 30, 40);
  text("Draw anticlockwise a circle or triangle. Press Enter to Start Again", 30, height-30);
  // Optional draw:
  one.draw();
  //set up triangles and circles
  setTris();
  setCircles();

  //draw note circles and triangles
  noStroke();
  //make sure this matches setup size
  size(displayWidth-100, displayHeight-100);

  //play notes
  if (random(1) < density) {
    sc.playNote(pitchSet[(int)random(setSize)]+keyRoot, random(90)+20, random(20)/10 + 0.2);

    //automatic eclipses vars
    r = random(rMax);
    g = random(gMax);
    b = random(bMax);
    a = random(20, 70);
    diam = random(50, 150);
    x = random(100, width-100);
    y = random(100, height-100);
    noStroke();
    fill(r, g, b, a);
    ellipse(x, y, diam, diam);

    //draw random triangles
    //triangle(x1, y1, x2, y2, x3, y3);
  }
  //randomise instrument 2 based on frameCount 
  if (frameCount%32 == 0) {
    keyRoot = (random(4)-2)*2;
    density = random(7) / 10 + 0.3;
    sc2.playNote(36+keyRoot, random(40) + 70, 8.0);
  }
  //randomise piano(sc3) chords based on frameCount 
  if (frameCount%16 == 0) {
    float[] pitches = {
      pitchSet[(int)random(setSize)]+keyRoot-12, pitchSet[(int)random(setSize)]+keyRoot-12
    };
    sc3.playChord(pitches, random(50)+30, 4.0);
  }

  //if gesture is circle, trigger synth chords based on userPitchSet
  if (name == "triangle") {
    // fill(random(100));
    drawTris();
    //  ellipse(mouseX+10,mouseY+10,random(30,40),random(30,40));
    float[] pitches = {
      userPitchSet[(int)random(setSize)]+keyRoot-24, pitchSet[(int)random(setSize)]+keyRoot-24
    };
    sc4.playChord(pitches, int(random(mouseX/2)), 4);
  }

  //if gesture is triangle
  if (name == "circle") {
    // fill(random(100));
    drawCircles();
    //  ellipse(mouseX+10,mouseY+10,random(30,40),random(30,40));
    float[] pitches = {
      userPitchSet[(int)random(setSize)]+keyRoot-24, pitchSet[(int)random(setSize)]+keyRoot-24
    };
    sc5.playChord(pitches, int(random(mouseX/2)), 4);
  }
}

//clear background if press enter
void keyPressed() {
  if (keyCode == ENTER)
  {
    background(0);
    if (bkg == 0) {
      bkg = 255;
    } else {
      bkg = 0;
    }
    name = " ";
  }
}
void setTris() {
  x1=random(mouseX-random(20), mouseX+random(20));
  y1=random(mouseY-random(20), mouseY+random(20));
  x2=random(x1-random(mouseX/13, mouseX/10), x1+random(mouseX/12, mouseX/8));
  y2=random(y1-random(mouseY/16, mouseY/9), y1+random(mouseY/15, mouseY/9));
  x3=random(x1-random(mouseX/14, mouseX/7), x1+random(mouseX/13, mouseX/7));
  y3=random(y1-random(mouseY/13, mouseY/10), y1+random(mouseY/13, mouseY/9));
}

void drawTris() {
  strokeWeight(0.1);
  fill(random(256), random(50), random(50), random(100));
  triangle(x1, y1, x2, y2, x3, y3);
}

void setCircles() {
  xa=random(mouseX-random(20), mouseX+random(20));
  ya=random(mouseY-random(20), mouseY+random(20));
  circleWidth=random(40, 60);
  circleHeight=random(40, 60);
}

void drawCircles() {
  strokeWeight(0.1);
  //red/purple
  fill(256, 256, 256, random(200));
  ellipse(xa, ya, circleWidth, circleHeight);
}


// 5. Track data:
void mouseDragged() {
  one.track(mouseX, mouseY);
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
//  OscMessage myMessage = new OscMessage("/test");
//  myMessage.add(123); /* add an int to the osc message */
  /* send the message */
//  oscP5.send(myMessage, myRemoteLocation); 
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
