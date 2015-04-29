class RotatingSphere implements Scene
{   
  int randomPoints = 8000;
  float rotX, rotY;
  randomSpherePoints rsp;
  float nr =500;
  boolean fixed;
  boolean large;


  public RotatingSphere(){};

  void closeScene(){};
  void initialScene(){
    smooth();
    strokeWeight(4.0);
    dPos = new PVector(width/2,height/2);
    pdPos =dPos;
    rsp = new randomSpherePoints (randomPoints, nr); 
    rotX= rotY = 0.0;
    fixed = false;
    large = false;

  };
  void drawScene(){
    background(backCol);
    noFill();
    //just for testing
    stroke(255,0,0);
    ellipse(dPos.x, dPos.y, nr*2, nr*2);
    /////

    //if (frameCount % 5 == 0) {
    dancers.getDancers();
    if(dancers.hasDancers()){
      pdPos =dPos;
      dPos = dancers.getFirstDancerMiddleXY();
      // esto se deberia hacer solo si saltamos de no-user a "veo un usuario", para el resto de los casos esta en los calculos de DancerManager
      if(abs(dPos.x -pdPos.x)>4){
        dPos.x =pdPos.x + constrain(dPos.x -pdPos.x,-4,4);
        dPos.y = pdPos.y + constrain(dPos.y -pdPos.y,-4,4);
      }else{
        dPos.x =pdPos.x;
        dPos.y = pdPos.y;

      }
      
      PVector r = dancers.getFirstDancerRight();
      PVector l = dancers.getFirstDancerLeft();
      float nRad = (r.x - l.x)/2;
      rsp.setNewRadius(nRad);
      nr =nRad;
      println("has dancers: pdPos.x "+pdPos.x+" dPos.x "+dPos.x);
    }
    else{

      rsp.setNewRadius(500);
      nr =500;
      // dPos.x = width/2;
      // dPos.y = height/2;
      dPos.x =pdPos.x + constrain(width/2 -pdPos.x,-4,4);
      dPos.y = pdPos.y + constrain(height/2 -pdPos.y,-4,4);
      println("pdPos.x "+pdPos.x+" dPos.x "+dPos.x);
      pdPos=dPos ;
      
      
    }
    //}
    if(fixed) translate(width/2, height/2);
    else translate(dPos.x, dPos.y);
    
    //rotateY (map(mouseX,0,width,0,PI));
    rotateY (rotY);
    stroke(thingCol, 166);
    //if we want if big we don't care aboutenRad
    if(large){
      rsp.setNewRadius(500);
      nr =500;
    }
    rsp.draw();
   // rotY += 0.009;

    if(dPos.x>=width/2) rotY += 0.009;
    else rotY -= 0.009;
  };

  String getSceneName(){return "RotatingSphere";};
  void onPressedKey(String k){
    if(k == "toggle") fixed=!fixed;
    if(k == "gravity") large=!large;
  };
  void onImg(PImage img){};

  class randomSpherePoints
  {
    int maxPoints = 0;
    PVector[] points;
    float oldRadius = 100;
    float newRadius;
    
    //--------------------------------------------------------
    // create random sphere points
    //--------------------------------------------------------
    randomSpherePoints (int pointCount, float sphereRadius)
    { 
      maxPoints = pointCount; 
      points = new PVector[pointCount];
      newRadius = sphereRadius;
      for (int ni=0; ni < maxPoints; ni++)
      points[ni] = randomSpherePoint (oldRadius);

    }

    void setNewRadius(float nRadius){
      newRadius = nRadius;
    }
   
    //--------------------------------------------------------
    // draw random sphere points  
    //--------------------------------------------------------
    void draw()
    {  
      if(newRadius>oldRadius) {
        oldRadius*=1.001;
        for (int ni=0; ni < maxPoints; ni++)
        points[ni] = new PVector (points[ni].x*1.0009, points[ni].y*1.0009, points[ni].z*1.0009);

      }
      else{
        oldRadius*=0.999;
        for (int ni=0; ni < maxPoints; ni++)
        points[ni] = new PVector (points[ni].x*0.9991, points[ni].y*0.9991, points[ni].z*0.9991);
      }

      for (int ni=0; ni < maxPoints; ni++)
      point (points[ni].x, points[ni].y, points[ni].z);


    }

    //--------------------------------------------------------
    // return random sphere point using method of Cook/Neumann
    //--------------------------------------------------------
    PVector randomSpherePoint (float sphereRadius)
    {
      float a=0, b=0, c=0, d=0, k=99;
      while (k >= 1.0) 
      { 
        a = random (-1.0, 1.0);
        b = random (-1.0, 1.0);
        c = random (-1.0, 1.0);
        d = random (-1.0, 1.0);
        k = a*a +b*b +c*c +d*d;
      }
      k = k / sphereRadius;
      //println("radius "+sphereRadius+" x "+(2*(b*d + a*c) / k)+" y "+(2*(c*d - a*b) / k )+" z "+((a*a + d*d - b*b - c*c) / k)+" k "+k);
      return new PVector 
        ( 2*(b*d + a*c) / k 
        , 2*(c*d - a*b) / k  
        , (a*a + d*d - b*b - c*c) / k);
    }
  }
}