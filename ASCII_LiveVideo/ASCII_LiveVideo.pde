import processing.video.*;

Capture video;

int resolution = 4;

char[] ascii;

int[] storedPixels;

boolean inColor = false;

void setup() {

  size(640, 480);
  background(255);
  fill(30);
  noStroke();

  video = new Capture(this, Capture.list()[0]);

  video.start();

  ascii = new char[256];
  String letters = "MN@#$o;:,. ";
  for (int i = 0; i < 256; i++) {
    int index = int(map(i, 0, 256, 0, letters.length()));
    ascii[i] = letters.charAt(index);
  }

  PFont mono = createFont("Courier", resolution + 2);
  textFont(mono);

  storedPixels = pixels;
}

void draw() {

  imageMode(CENTER);
  
  if (video.available()) {
    
    video.read();
    
    image(video, width/2, height/2, width, height);
    loadPixels();
    storedPixels = pixels;
    
    if (inColor) {
      asciifyColor();
    } else {
      asciify();
    }
  }
}

void keyPressed() {

  if (key == ' ') {
    image(video, width/2, height/2, width, height);
    loadPixels();
    storedPixels = pixels;
    asciify();
  }

  if (key == 'd') {
    if (resolution <= 12) {
      resolution++;
    }
  }

  if (key == 'a') {
    if (resolution >= 3) {
      resolution--;
    }
  }

  if (key == 'r') {
    resolution = 1;
  }
  
  if (key == 'c'){
    inColor = !inColor;
  }
}

void asciify() {
  
  filter(GRAY);

  background(255);


  for (int y = 0; y < height; y += resolution) {
    for (int x = 0; x < width; x += resolution) {
      color pixel = storedPixels[y * width + x];
      text(ascii[int(brightness(pixel))], x, y);
    }
  }
}

void asciifyColor() {

  background(255);


  for (int y = 0; y < height; y += resolution) {
    for (int x = 0; x < width; x += resolution) {
      color pixel = storedPixels[y * width + x];
      fill(pixel);
      text(ascii[int(brightness(pixel))], x, y);
    }
  }
}