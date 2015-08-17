class DepthSquare implements Scene
{   
  float dancerDepth;
  float maxDepth = 2500;
  float minDepth = 500;
  public DepthSquare(){};

  void closeScene(){};
  void initialScene(){
    dancerDepth = 600;
    //resetDancers();
    dPos= new PVector(0,0);
  };
  void drawScene(){
 
    //if (frameCount % 5 == 0) {
      dancers.getDancers();
      if(dancers.hasDancers()){
        dancerDepth = dancers.getFirstDancerDepth();
        if (frameCount % 60 == 0) println("dancerDepth "+dancerDepth);
      }
   // }

    rectMode(3);
    noStroke();
    boolean m=true;
    //float o=max(0.01,mouseX/d);
    //float o=map(mouseX,0,width,1,0.004);
    //ojo aca!!!!si pasamos algo fuera del rango explotaaaaa
    float o = map(max(min(dancerDepth,maxDepth),minDepth),minDepth,maxDepth,1,0.004);
    for (float i=1.0; i>0;  i-=o){
      fill(m?0:255);
      rect(width/2,width/2,width*i,width*i);
      fill(m?255:0);
      rect(width/4,width/4,width*i/2,width*i/2);
      m=!m;
    }
    rectMode(1);
    drawGlobalAlpha();
  };
  String getSceneName(){return "DepthSquare";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

}