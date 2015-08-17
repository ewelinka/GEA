
class Rain implements Scene
{   
  int gravityX,gravityY;

  public Rain(){};

  void closeScene(){
    contactType = 2;
    world.clear();
  };
  void initialScene(){
    contactType =1;
    //human
    addSemiCircle();
    // humanBox = new FBox(250, 20);
    // humanBox.setPosition(width/2, height - 40);
    // humanBox.setStatic(true);;
    // humanBox.setDrawable(false);
    // humanBox.setRestitution(0);
    // world.add(humanBox);
    //below
    belowBox = new FBox(width+20, 2);
    belowBox.setPosition(width/2, height + 0);
    belowBox.setStatic(true);
    belowBox.setFill(0);
    belowBox.setRestitution(0);
    world.add(belowBox);
    gravityX =gravityY = 0;
    //world.setGravity(0,100);

  };
  void drawScene(){
    background(backCol);

    dancers.getDancers();
    if(dancers.hasDancers()){
      PVector pos = dancers.getFirstDancerMiddleAndTop();
      semiCircle.setRotation(0);
      semiCircle.setPosition(pos.x-100,pos.y);

      //debug
      //fill(255,0,0);
      //ellipse(pos.x, pos.y, 14, 14);
    } else semiCircle.setPosition(width+100, height+100);

    for(int i =0;i<3;i++) addBox();
    
    world.draw();
    world.step();

    drawGlobalAlpha();

  };
  String getSceneName(){return "Rain";};

  void onPressedKey(String k){
    if (k == "toggle") {toggleContact();}

  };

  void toggleContact(){
    if(contactType == 0) contactType =1;
    else contactType =0;
  }

  void onImg(PImage img){};


  void addSemiCircle(){
    int theta = 180;  // angle that will be increased each loop
    int h = 120 ;     // x coordinate of circle center
    int k = 100 ;     // y coordinate of circle center
    int r=120;
    int step = 4;  // amount to add to theta each time (degrees)

    semiCircle = new FPoly();
    //semiCircle.setStrokeWeight(1);
    semiCircle.setFill(120, 30, 90);
    //semiCircle.setDensity(10);
    semiCircle.setStatic(true);;
    semiCircle.setDrawable(false);
    semiCircle.setRestitution(0);

    while(theta<=360){
      float x = h + r*cos(radians(theta));
      float y = k + r*sin(radians(theta));
      semiCircle.vertex(x, y);
      theta+=step;
    }
    semiCircle.vertex(h + r*cos(radians(180)), k + r*sin(radians(180)));
    world.add(semiCircle);
  }


  void addBall(){
    FCircle b = new FCircle(random(5, 50));
    b.setPosition(random(0+10, width-10), 50);
    b.setVelocity(0, 80);
    b.setRestitution(0);
    b.setNoStroke();
    //b.setFill(200, 30, 90);
    b.setFill(thingCol);
    world.add(b);
  }

  void addBox(){
      FBox b = new FBox(2,random(5,20));
      b.setPosition(random(0+10, width-10), 50);
      b.setVelocity(0, 80);
      b.setRestitution(0);
      b.setNoStroke();
      //b.setFill(200, 30, 90);
      b.setFill(thingCol);
      world.add(b);
  }

  void addLine(){
    for(int i =0;i<103;i++){
      FBox b = new FBox(10,2);
      b.setPosition(i*10, 50);
      b.setVelocity(0, 80);
      b.setRestitution(0);
      b.setNoStroke();
      //b.setFill(200, 30, 90);
      b.setFill(thingCol);
      world.add(b);
    }
  }

}
