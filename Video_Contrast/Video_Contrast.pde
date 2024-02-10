import processing.video.*;

Capture video;

PImage img;
PImage imgEnhanced;

Slider brightSlider;
Slider contrastSlider;
Slider grayscaleSlider;

Button popButton;
Button deutButton;

int brightY = 100;
int contrastY = 200;
int grayscaleY = 300;

int brightOpts = 10;
int contrastOpts = 10;
int grayscaleOpts = 10;

int sliderBuffer = 20;

float contrast = 1;
float brightness = 0;
float grayscale = 0;

int[] storedPixels;

void setup() {
  size(1280, 480);

  brightSlider = new Slider(735, brightY, 450, brightOpts, 5);
  contrastSlider = new Slider(735, contrastY, 450, contrastOpts, 5);
  grayscaleSlider = new Slider(735, grayscaleY, 450, grayscaleOpts);
  
  popButton = new Button(822, 400, 128, 50, "Pop tropica view");
  deutButton = new Button(1086, 400, 128, 50, "Deuteronomy view");

  video = new Capture(this, Capture.list()[0]);
  video.start();

  //loadPixels();
  //storedPixels = pixels;
}

void draw() {

  //loadPixels();

  contrast = map(contrastSlider.returnIndexVal(), 0, contrastOpts - 1, 0.5, 1.5);
  brightness = map(brightSlider.returnIndexVal(), 0, brightOpts - 1, -50, 50);
  grayscale = map(grayscaleSlider.returnIndexVal(), 0, grayscaleOpts - 1, 0, 1);

  imageMode(CENTER);

  if (video.available()) {
    video.read();
    image(video, width/4, height/2, width/2, height);
  }

  adjustImage();
  grayscaleThatJunk(grayscale);

  fill(0);
  rect(width/2, 0, width/2, height);
  brightSlider.render();
  contrastSlider.render();
  grayscaleSlider.render();
  
  popButton.render();
  deutButton.render();
}

void mousePressed(){
  if (popButton.isInButton()){
    popButton.isPressed = true;
  }
  if (deutButton.isInButton()){
    deutButton.isPressed = true;
  }
}

void mouseDragged() {
  if (mouseY > brightY - sliderBuffer && mouseY < brightY + sliderBuffer) {
    brightSlider.moveArrowNoDrop();
  }
  if (mouseY > contrastY - sliderBuffer && mouseY < contrastY + sliderBuffer) {
    contrastSlider.moveArrowNoDrop();
  }
  if (mouseY > grayscaleY - sliderBuffer && mouseY < grayscaleY + sliderBuffer) {
    grayscaleSlider.moveArrowNoDrop();
  }
}

void mouseReleased() {
  brightSlider.findClosestIndex();
  contrastSlider.findClosestIndex();
  grayscaleSlider.findClosestIndex();
  
  popButton.isPressed = false;
  deutButton.isPressed = false;
}

void adjustImage() {
  loadPixels();
  //background(255);
  for (int i = 0; i < pixels.length; i++) {
    color inColor = pixels[i];
    int r = (int) red(inColor);
    int g = (int) green(inColor);
    int b = (int) blue(inColor);

    r = (int) (r * contrast + brightness);
    g = (int) (g * contrast + brightness);
    b = (int) (b * contrast + brightness);

    r = r < 0 ? 0: r > 255 ? 255: r;
    g = g < 0 ? 0: g > 255 ? 255: g;
    b = b < 0 ? 0: b > 255 ? 255: b;

    pixels[i] = color(r, g, b);
  }
  updatePixels();
}

void grayscaleThatJunk(float value) {
  /**
    Potential flow:
    - Base grayscale-ifying on "value" (0.0 - 1.0)
    - Use that value to adjust rgb values of every pixel
    - weight averages based on "value" ? 
  */
  
  loadPixels();
  
  for (int i = 0; i < pixels.length; i++){
    color inColor = pixels[i];
    
    int r = (int) red(inColor);
    int g = (int) green(inColor);
    int b = (int) blue(inColor);
    
    int t = (int) (r + g + b) / 3;
    
    int newR = r > t ? (int) (r - (abs(r - t) * value)): r < t ? (int) (r + (abs(r - t) * value)): r;
    int newG = g > t ? (int) (g - (abs(g - t) * value)): r < t ? (int) (g + (abs(r - t) * value)): g;
    int newB = b > t ? (int) (b - (abs(b - t) * value)): r < t ? (int) (b + (abs(r - t) * value)): b;
    
    newR = newR < 0 ? 0: newR > 255 ? 255: newR;
    newG = newG < 0 ? 0: newG > 255 ? 255: newG;
    newB = newB < 0 ? 0: newB > 255 ? 255: newB;
    
    pixels[i] = color(newR,newG,newB);
  }
  
  updatePixels();
}
