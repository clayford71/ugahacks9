import processing.video.*;
import colorblind.*;
import colorblind.generators.*;
import colorblind.generators.util.*;

ColorBlindness cb;
Deficiency popDef;
Deficiency deutDef;

float popAmount = 0;
float deutAmount = 0;

Capture video;

PImage testImg;
PImage alteredImg;

Slider brightSlider;
Slider contrastSlider;
Slider grayscaleSlider;

Button popButton;
Button deutButton;
Button testButton;

Label brightLabel;

int brightY = 100;
int contrastY = 200;
int grayscaleY = 300;

int brightOpts = 11;
int contrastOpts = 11;
int grayscaleOpts = 11;

int sliderBuffer = 40;

float contrast = 1;
float brightness = 0;
float grayscale = 0;

boolean flipPop = false;
boolean flipDeut = false;

void setup() {
  size(1280, 480);

  brightSlider = new Slider(735, brightY, 450, brightOpts, 5);
  contrastSlider = new Slider(735, contrastY, 450, contrastOpts, 5);
  grayscaleSlider = new Slider(735, grayscaleY, 450, grayscaleOpts);

  popButton = new Button(770, 400, 120, 50, "Simulate Protanopia");
  deutButton = new Button(1130, 400, 120, 50, "Simulate Tritanopia");
  testButton = new Button(950, 400, 120, 50, "Test Image");

  testImg = loadImage("cbtest.jpeg");
  alteredImg = new PImage(testImg.width, testImg.height);

  cb = new ColorBlindness(this);
  popDef = Deficiency.PROTANOPIA;
  deutDef = Deficiency.TRITANOPIA;

  video = new Capture(this, Capture.list()[0]);
  video.start();
}

void draw() {
  
  if (flipPop) {
    cb.simulate(popDef).setAmount(0);
    flipPop = false;
  }
  if (flipDeut) {
    cb.simulate(deutDef).setAmount(0);
    flipDeut = false;
  }

  //loadPixels();

  //cb.simulate(popDef).setAmount(popAmount);
  //cb.simulate(deutDef).setAmount(deutAmount);

  //if (popButton.isPressed) {
  //  popAmount = 1;
  //  cb.simulate(popDef).setAmount(popAmount);
  //} else {
  //  popAmount = 0;
  //  cb.simulate(popDef).setAmount(popAmount);
  //}

  //if (deutButton.isPressed) {
  //  deutAmount = 1;
  //  cb.simulate(deutDef).setAmount(deutAmount);
  //} else {
  //  deutAmount = 0;
  //  cb.simulate(deutDef).setAmount(deutAmount);
  //}

  contrast = map(contrastSlider.returnIndexVal(), 0, contrastOpts - 1, 0.5, 1.5);
  brightness = map(brightSlider.returnIndexVal(), 0, brightOpts - 1, -50, 50);
  grayscale = map(grayscaleSlider.returnIndexVal(), 0, grayscaleOpts - 1, 0, 20);

  imageMode(CENTER);

  if (video.available()) {
    video.read();
    image(video, width/4, height/2, width/2, height);
    adjustImage();
  }

  fill(0);
  rect(width/2, 0, width/2, height);
  brightSlider.render();
  contrastSlider.render();
  grayscaleSlider.render();

  popButton.render();
  deutButton.render();
  testButton.render();

  if (testButton.isPressed) {
    image(alteredImg, testImg.width/2, testImg.height/2);
    //image(alteredImg, 320, 240, 640, 480);
  }
  adjustTestImage();

  textAlign(CENTER);
  textSize(14);
  fill(200);
  text("-128", 735, 125);
  text("128", 1185, 125);
  text("-0.5", 735, 225);
  text("0.5", 1185, 225);
  text("0", 735, 325);
  text("20", 1185, 325);
  textSize(28);
  text("Brightness", 960, 150);
  text("Contrast", 960, 250);
  text("Saturation", 960, 350);
}

void mousePressed() {
  if (popButton.isInButton()) {
    popButton.isPressed = true;
    cb.simulate(popDef).setAmount(1);
  }
  if (deutButton.isInButton()) {
    deutButton.isPressed = true;
    cb.simulate(deutDef).setAmount(1);
  }
  if (testButton.isInButton()) {
    testButton.isPressed = !testButton.isPressed;
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

  flipPop = true;
  flipDeut = true;

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

    String[] s = determineMaxes(r, g, b);

    if (isInArray(s, "R")) {
      r = (int) (r * (1 + (grayscale / 100)));
    } else {
      r = (int) (r * (1 - (grayscale / 100)));
    }
    
    if (isInArray(s, "G")) {
      g = (int) (g * (1 + (grayscale / 100)));
    } else {
      g = (int) (g * (1 - (grayscale / 100)));
    }
    
    if (isInArray(s, "B")) {
      b = (int) (b * (1 + (grayscale / 100)));
    } else {
      b = (int) (b * (1 - (grayscale / 100)));
    }

    r = r < 0 ? 0: r > 255 ? 255: r;
    g = g < 0 ? 0: g > 255 ? 255: g;
    b = b < 0 ? 0: b > 255 ? 255: b;

    pixels[i] = color(r, g, b);
    //updatePixels();
  }
  updatePixels();
}

void adjustTestImage() {
  testImg.loadPixels();
  //background(255);
  for (int i = 0; i < testImg.pixels.length; i++) {
    color inColor = testImg.pixels[i];
    int r = (int) red(inColor);
    int g = (int) green(inColor);
    int b = (int) blue(inColor);

    r = (int) (r * contrast + brightness);
    g = (int) (g * contrast + brightness);
    b = (int) (b * contrast + brightness);
    
    String[] s = determineMaxes(r, g, b);

    if (isInArray(s, "R")) {
      r = (int) (r * (1 + (grayscale / 100)));
    } else {
      r = (int) (r * (1 - (grayscale / 100)));
    }
    
    if (isInArray(s, "G")) {
      g = (int) (g * (1 + (grayscale / 100)));
    } else {
      g = (int) (g * (1 - (grayscale / 100)));
    }
    
    if (isInArray(s, "B")) {
      b = (int) (b * (1 + (grayscale / 100)));
    } else {
      b = (int) (b * (1 - (grayscale / 100)));
    }

    r = r < 0 ? 0: r > 255 ? 255: r;
    g = g < 0 ? 0: g > 255 ? 255: g;
    b = b < 0 ? 0: b > 255 ? 255: b;

    alteredImg.pixels[i] = color(r, g, b);
    //updatePixels();
  }
  alteredImg.updatePixels();
}

String[] determineMaxes(int r, int g, int b) {
  String[] retArr = new String[3];

  retArr[0] = "R";
  retArr[1] = "G";
  retArr[2] = "B";

  if (r < g || r < b) {
    retArr[0] = "EMPTY";
  }
  if (g < r || g < b) {
    retArr[1] = "EMPTY";
  }
  if (b < g || b < r) {
    retArr[2] = "EMPTY";
  }

  return retArr;
}

boolean isInArray(String[] arr, String e) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] == e) {
      return true;
    }
  }
  return false;
}
