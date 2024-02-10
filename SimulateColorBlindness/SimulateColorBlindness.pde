import colorblind.*;
import colorblind.generators.*;
import colorblind.generators.util.*;

ColorBlindness cb;

boolean simP = false;
boolean simD = false;

void setup(){
  size(400,400);
  background(255);
  
  cb = new ColorBlindness(this);
  //cb.simulateProtanopia();
  //cb.simulateDeuteranopia();
  
  for (int x = 0; x < width; x += 10){
    for (int y = 0; y < height; y += 10){
      fill(color(random(0,255),random(0,255),random(0,255)));
      rect(x,y,10,10);
    }
  }
}

void draw(){
  if (simD){
    cb.simulateDeuteranopia();
    println("DONE");
    simD = false;
  }
  if (simP){
    cb.simulateProtanopia();
  }
}

void keyPressed(){
  if (key == 'd'){
    simD = !simD;
  }
  if (key == 'p'){
    simP = !simP;
  }
}
