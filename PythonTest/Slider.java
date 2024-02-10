class Slider {

  int x;
  int y;
  int totalLength;
  int numOptions;

  int distBetweenOpts;

  int[] optionPosns;
  int curOptionIndex;

  int startX;
  int endX;

  int arrowPos;

  Slider (int aX, int aY, int tl, int no) {
    x = aX;
    y = aY;
    totalLength = tl;
    numOptions = no;
    startX = x;
    endX = x + totalLength;
    distBetweenOpts = (int) totalLength / (numOptions - 1);
    optionPosns = new int[numOptions];

    arrowPos = startX;
  }

  Slider (int aX, int aY, int tl, int no, int startVal) {
    x = aX;
    y = aY;
    totalLength = tl;
    numOptions = no;
    startX = x;
    endX = x + totalLength;
    distBetweenOpts = (int) totalLength / (numOptions - 1);
    optionPosns = new int[numOptions];

    arrowPos = startX + startVal * distBetweenOpts;
  }

  void render() {
    renderLine();
    renderArrow(arrowPos);
  }

  void renderLine() {
    fill(200);
    noStroke();
    rect(x, y, totalLength, 2);

    for (int i = 0; i < numOptions; i++) {
      rect(startX + (i * distBetweenOpts), y-4, 2, 10);
      optionPosns[i] = startX + (i * distBetweenOpts);
    }
  }

  void renderArrow(int pos) {
    int rectSize = 16;
    int triangleSize = 16;
    color arrowColor = color(200);
    color insideColor = color(75);
    if (mousePressed && mouseY > y - sliderBuffer && mouseY < y + sliderBuffer) {
      arrowColor = color(75);
      insideColor = color(200);
    } else {
      arrowColor = color(200);
      insideColor = color(75);
    }
    //stroke(0);
    //strokeWeight(3);
    fill(arrowColor);
    rect(pos - rectSize / 2, y - rectSize + 1, rectSize, rectSize, 2);
    triangle(pos - rectSize / 2, y, pos + rectSize / 2, y, pos, y + triangleSize + 1);
    fill(insideColor);
    rect(pos - 3, y - 10, 6, 16, 3);
  }

  void moveArrowNoDrop() {
    arrowPos = mouseX;
    arrowPos = arrowPos < startX ? startX: arrowPos > endX ? endX: arrowPos;
  }

  void findClosestIndex() {

    int prev = optionPosns[0];

    int setVal = -1000;

    for (int i = 1; i < optionPosns.length; i++) {
      int cur = optionPosns[i];
      if (abs(arrowPos - cur) > abs(arrowPos - prev)) {
        setVal = prev;
        break;
      }
      prev = cur;
    }
    if (setVal != -1000) {
      arrowPos = setVal;
    } else {
      arrowPos = optionPosns[optionPosns.length - 1];
    }
  }

  int returnIndexVal () {
    println(((arrowPos - startX) / distBetweenOpts));
    return (int) ((arrowPos - startX) / distBetweenOpts);
  }
}















