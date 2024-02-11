class Label {
  int start;
  int end;
  int count;
  String text;
  
  int len;
  
  int firstX;
  int y;
  
  int inc;
  int dist;
  
  Label(int s, int e, int c, String t, int l, int x, int aY){
    start = s;
    end = e;
    count = c;
    text = t;
    len = l;
    firstX = x;
    y = aY;
    
    inc = (end - start) / count;
    dist = len / (count + 1);
  }
  
  void render(){
    for (int i = 0; i < count; i++){
      String thisNum = str(start + (i * inc));
      textSize(14);
      fill(200);
      textAlign(CENTER);
      text(thisNum, firstX + (dist * i), y);
    }
  }
}
