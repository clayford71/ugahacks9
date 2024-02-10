class Button {
  
  int x;
  int y;
  int w;
  int h;
  String text;
  
  boolean isPressed;
  
  Button(int aX, int aY, int aW, int aH, String aT){
    x = aX;
    y = aY;
    w = aW;
    h = aH;
    text = aT;
  }
  
  void render(){
    color textColor = color(0);
    if (isPressed) {
      fill(75);
      textColor = color(255);
    } else {
      fill(200);
      textColor = color(0);
    }
    textMode(CENTER);
    stroke(200);
    strokeWeight(2);
    rect(x - w/2, y - h/2, w, h, 5);
    fill(textColor);
    textSize(14);
    text(text, x - w/2, y + 2);
  }
  
  boolean isBetween(int min, int n, int max){
    return n >= min && n <= max;
  }
  
  boolean isInButton(){
    return isBetween(x - w/2, mouseX, x + w/2) && isBetween(y - h/2, mouseY, y + h/2);
  }
  
}
