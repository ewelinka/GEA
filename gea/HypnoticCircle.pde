class HypnoticCircle implements Scene
{   
  float theta;
  public HypnoticCircle(){};

  void closeScene(){};
  void initialScene(){
    theta=0;
   // resetDancers();
    dPos= new PVector(0,0);
    //imageMode(CORNER);
    //cleanPg();
  };
  void drawScene(){
    pg.beginDraw();
    if (frameCount % 5 == 0) {
      dancers.getDancers();
      if(dancers.hasDancers()){
        dPos = dancers.getFirstDancerMiddleXY();
        //debugging
        //pg.fill(255,0,0);
        //pg.ellipse(dPos.x, dPos.y, 14, 14);
      }
    }
    
    rectMode(CENTER);
    pg.fill(backCol, 60);
    pg.noStroke();
    pg.rect(0, 0, width*3, height*3);
    pg.filter(DILATE);
    //filter(BLUR);
    theta+=0.1;
    pg.noFill();
    pg.stroke(thingCol);
    pg.translate(width/2, height/2);
    // si no queres que te siga comenta la linea de abajo
    //if(dPos.x !=0) pg.translate(dPos.x-width/2,0);
    for (int i=0;i<height-20;i+=20) {
      //pg.ellipse(map(dPos.x,0,width,0,20)*((sin(theta-i))), map(mouseY,0,height,0,10)*((cos(theta-i))), i, i);
      pg.ellipse(map(width/2 - abs(width/2 -dPos.x),0,width/2,0,20)*((sin(theta-i))), map(mouseY,0,height,0,10)*((cos(theta-i))), i, i);
    }
    pg.endDraw();
    image(pg, 0, 0);
  };
  String getSceneName(){return "HypnoticCircle";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

}