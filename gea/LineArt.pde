class LineArt implements Scene
{   
  float theta;
  public LineArt(){};

  void closeScene(){};
  void initialScene(){
    theta=0;
  };
  void drawScene(){
    theta+=.1;
    background(backCol);
    pushMatrix();
      scale(1.6);
      translate(-(width - context.depthWidth()), 0);
      //

      context.update();
      int[] u = context.userMap();
      for(int y =0; y<context.depthHeight();y+=6){
        noFill();
        stroke(thingCol);
        strokeWeight(2);
        beginShape();
        for(int x =0; x<context.depthWidth();x+=1){
          int i= y*context.depthWidth() + x;

          if(u[i]==0){
           // vertex(x, y-5*cos(theta));
            vertex(width-x, y-5*cos(theta));
          }else {
            //vertex(x, y);
            vertex(width-x, y);
          }
        }
        endShape();
      }
    popMatrix();
    translate(0, 0, 0.6);
  fill(0, globalAlpha);
  noStroke();
  rect(0,0,width,height);
    //drawGlobalAlpha();
  };
  String getSceneName(){return "LineArt";};
  void onPressedKey(String k){};
  void onImg(PImage img){};
}