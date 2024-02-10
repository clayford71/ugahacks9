
PImage img;

int resolution = 1;

char[] ascii;

void setup(){
  img = loadImage("penguin.jpeg");
  size(234,148);
  background(255);
  fill(30);
  noStroke();
  
  // build up a character array that corresponds to brightness values
  ascii = new char[256];
  String letters = "MN@#$o;:,. ";
  for (int i = 0; i < 256; i++){
    int index = int(map(i, 0, 256, 0, letters.length()));
    ascii[i] = letters.charAt(index);
  }
  
  PFont mono = createFont("Courier", resolution + 2);
  textFont(mono);
  
  asciify();
}

void asciify(){
  img.filter(GRAY);
  img.loadPixels();
  
  for (int y = 0; y < img.height; y += resolution){
    for (int x = 0; x < img.width; x += resolution){
      color pixel = img.pixels[y * img.width + x];
      text(ascii[int(brightness(pixel))], x, y);
    }
  }
}
