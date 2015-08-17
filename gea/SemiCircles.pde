class SemiCircles implements Scene
{  
  float theta[];
  PImage plny,plnyBlack;
  int [] moznosti = {0,90,180,270};
  float  r; 

  public SemiCircles(){};

  void closeScene(){};
  void initialScene(){
    //resetDancers();
    dPos= new PVector(0,0);
    imageMode(CENTER);
    backCol = 0;
    thingCol = 255;

    plny = loadImage("plny.png");

    theta = new float[3000];
    for (int i = 0 ; i < theta.length ; i ++){
      theta[i] = moznosti[(int)random(4)];
    }
  };
  void drawScene(){
    background(0);
   // if (frameCount % 5 == 0) {
      dancers.getDancers();
      if(dancers.hasDancers()){
        dPos = dancers.getFirstDancerMiddleAndTop();  
      }
  //  }
   // fill(255,0,0);
   // ellipse(dPos.x, dPos.y, 20, 20);


    r = plny.width;
    int idx = 0;
    for(int y = 0;y <= height/plny.height;y++){
      for(int x = 0;x <= width/plny.width;x++){
        pushMatrix();
          translate(x*r+plny.width/2,y*r+plny.height/2);
          rotate(radians(theta[idx]));
          theta[idx] += 0.004*degrees(30.0*atan2(dPos.y-y*r,dPos.x-x*r));
         
          //arc(x, y, 32, 32, -PI, 0);
          image (plny,0,0);
        popMatrix();

        idx += 1;
      }
    }

    drawGlobalAlpha();
  };
  String getSceneName(){return "SemiCircles";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

}