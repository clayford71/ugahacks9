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

int sliderBuffer = 20;

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
  deutButton = new Button(1130, 400, 120, 50, "Simulate Deuteranopia");
  testButton = new Button(950, 400, 120, 50, "Test Image");

  testImg = loadImage("cbtest.jpeg");
  alteredImg = new PImage(testImg.width, testImg.height);

  cb = new ColorBlindness(this);
  popDef = Deficiency.PROTANOPIA;
  deutDef = Deficiency.DEUTERANOPIA;

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
  grayscale = map(grayscaleSlider.returnIndexVal(), 0, grayscaleOpts - 1, 0, 1);

  imageMode(CENTER);

  if (video.available()) {
    video.read();
    image(video, width/4, height/2, width/2, height);
    //testPostProcess();
    adjustImage();
    grayscaleThatJunk(grayscale);
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
    image(alteredImg,testImg.width/2,testImg.height/2);
  }
  grayscaleThatImage(grayscale);
  adjustTestImage();
  
  textAlign(CENTER);
  textSize(14);
  fill(200);
  text("-128", 735, 125);
  text("128", 1185, 125);
  text("-0.5", 735, 225);
  text("0.5", 1185, 225);
  text("0.0", 735, 325);
  text("1.0", 1185, 325);
  textSize(28);
  text("Brightness", 960, 150);
  text("Contrast", 960, 250);
  text("Grayscale", 960, 350);
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

    r = r < 0 ? 0: r > 255 ? 255: r;
    g = g < 0 ? 0: g > 255 ? 255: g;
    b = b < 0 ? 0: b > 255 ? 255: b;

    pixels[i] = color(r, g, b);
    //updatePixels();
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

  for (int i = 0; i < pixels.length; i++) {
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

    pixels[i] = color(newR, newG, newB);
  }

  updatePixels();
}

void testPostProcess() {
  // Loop through each pixel in the image
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    // Extract the color of the pixel
    color pixelColor = pixels[i];

    // Example: Convert the image to grayscale to make it easier for colorblind individuals to see
    float grayValue = red(pixelColor) * 0.2126 + green(pixelColor) * 0.7152 + blue(pixelColor) * 0.0722;
    pixels[i] = color(grayValue);
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

    r = r < 0 ? 0: r > 255 ? 255: r;
    g = g < 0 ? 0: g > 255 ? 255: g;
    b = b < 0 ? 0: b > 255 ? 255: b;

    alteredImg.pixels[i] = color(r, g, b);
    //updatePixels();
  }
  alteredImg.updatePixels();
}

void grayscaleThatImage(float value) {
  /**
   Potential flow:
   - Base grayscale-ifying on "value" (0.0 - 1.0)
   - Use that value to adjust rgb values of every pixel
   - weight averages based on "value" ?
   */

  testImg.loadPixels();

  for (int i = 0; i < testImg.pixels.length; i++) {
    color inColor = testImg.pixels[i];

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

    alteredImg.pixels[i] = color(newR, newG, newB);
  }

  alteredImg.updatePixels();
}
