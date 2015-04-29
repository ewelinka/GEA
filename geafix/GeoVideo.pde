class GeoVideo implements Scene
{   
  int w,h;
  int xc =8;
  public GeoVideo(){};

  void closeScene(){
    myCapture.stop();
  };
  void initialScene(){
    cleanPg();
    ellipseMode(RADIUS);
    pg.noStroke();
    myCapture.start();
    w= myCapture.width;
    h=myCapture.height;
  };
  void drawScene(){
    pg.background(backCol);
  
    if (myCapture.available() == true) {
      myCapture.read();
    }
    myCapture.loadPixels();

    //drawAscii();
    drawGeo();
  };
  String getSceneName(){return "GeoVideo";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

  void drawGeo(){
    pg.beginDraw();

    pg.scale(1.6);

    for(int y=0;y<h;y+=xc){ 
      for(int x=0;x<w;x+=xc){ 
        float av =brightness(myCapture.pixels[y*w+x]);
        pg.pushMatrix();
        pg.translate(x,y);
        pg.fill (thingCol);
        //pg.noStroke();
        pg.stroke(0);
        int t= (int)map(255-av,0,255,0,7);
        if(t==7) { 
          pg.rect(1,1,6,6); 
        } 
        else if(t==6) {
          pg.rect(1,1,6,6); 
          //pg.text("#", 0, 0); 
        } 
        else if(t==5) {
          //pg.text("&", 0, 0); 
          pg.ellipse(4,4,6,6);
        } 
        else if(t==4) {
          //pg.noFill();
          
          pg.triangle(1,1,7,1,4,7);
          //text("O", 0, 0); 
        } 
        else if(t==3) {
          //pg.text("Y", 0, 0); 
          pg.ellipse(4,4,4,4);
        } 
        else if(t==2) {
          //pg.text("/", 0, 0); 
          pg.stroke(0);
          pg.line(0,8,8,0);
        } 
        else if(t==1) {
          //pg.text(";", 0, 0); 
          pg.stroke(0);
          pg.line(2,6,6,2);

        } 
        else if(t==0) {
          //pg.text(" ", 0, 0); 
        }
        pg.popMatrix();
      }
    }  
    pg.endDraw();
    image(pg, 0, 0);
  }

}