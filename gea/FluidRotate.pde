
class FluidRotate implements Scene
{   
  int particleCount = 9000;
  /* Here we create a global Particle array using our particleCount  */
  Particle[] particles = new Particle[particleCount+1];
  boolean move = false;
  int sWeight =1;

  public FluidRotate(){};

  void closeScene(){};
  void initialScene(){
    //resetDancers();
    for (int x = particleCount; x >= 0; x--) { 
      /* We call the particle function inside its class to set up a new particle. Each is positioned randomly. */
      particles[x] = new Particle();
    }
    //rectMode(CORNER);
  };
  void drawScene(){
    stroke(thingCol);
    fill(backCol,10);
    strokeWeight(1);
    rect(0,0,width,height);
    /* We draw our border. It is 10 pixels from all sides. */
    quad(10,10,width-10,10,width-10,height-10,10,height-10);
    /* The particles are looped through, then updated. */
    if (frameCount % 5 == 0) {
      dancers.getDancers();
      if(dancers.hasDancers()){
        dPos = dancers.getFirstDancerMiddleAndTop();
        //dPos.y=( height - pos.y)/2 + dPos.y;
        fill(255,0,0);
        ellipse(dPos.x, dPos.y, 10, 10);
      }   
    }
    strokeWeight(sWeight);
    for (int i = particleCount; i >= 0; i--) { 
      Particle particle = (Particle) particles[i];
      particle.update();
    }
  };
  String getSceneName(){return "FluidRotate";};
  void onPressedKey(String k){
    if(k == "toggle") move=!move;
    if(k=="UP"){
      sWeight+=1;
    }
    if(k=="DOWN"){
      sWeight = max(sWeight-1,1);
    }
  };
  void onImg(PImage img){};

  class Particle {
    /* Our global class variables. These variables will be kept track of for each frame and throughout each function. */
    /* x and y represents the coordinates. vx and vy represents the velocities or speed and direction of the particles. */
    float x;
    float y;
    float vx;
    float vy;
    /* We call this to set up a new particle. */
    Particle() {
      /* The x and y coordinates of the particle is random and within the borders. */
      x = random(10,width-10);
      y = random(10,height-10);
    }
    /* Here we update the coordinates and redraw the particle. */
    void update() {
      /* Check to see if the user's mouse is pressed. */
      if(move){
        x=x+random(-1,1);
        y=y+random(-1,1);
      }
     
      if(dancers.hasDancers()){

    
        /* Variables are used to keep track of the x and y coordinates of the cursor. */
        float rx = dPos.x;
        float ry = dPos.y;
        /* The radius variable stores the distance between the cursor and the particle. */
        float radius = dist(x,y,rx,ry);
        /* Proceed if the particle is within 150 pixels of the cursor. */
        if (radius < 150) {
          /* atan2 is used to find the angle between the cursor and the particle. */
          float angle = atan2(y-ry,x-rx);
          vx -= (150 - radius) * 0.01 * cos(angle + (0.7 + 0.0005 * (150 - radius)));
          vy -= (150 - radius) * 0.01 * sin(angle + (0.7 + 0.0005 * (150 - radius)));
        }
      }
      /* x and y are increased by our velocities. This completes our formula c + r * cos(a) or sin(a), with vx/vy being the r * cos(a) or sin(a) */
      x += vx;
      y += vy;
      
      /* The velocities are decreased by 3% to simulate friction. */
      vx *= 0.97;
      vy *= 0.97;
      
      /* 
      Boundary collision is calculated here. If the particle is beyond the boundary, its velocity is reversed and the particle is moved back into the main area.
      */
      if (x > width-10) {
        vx *= -1;
        x = width-11;
      }
      if (x < 10) {
        vx *= -1;
        x = 11;
      }
      if (y > height-10) {
        vy *= -1;
        y = height-11;
      }
      if (y < 10) {
        vy *= -1;
        y = 11;
      }
       //point((int)x,(int)y);
       stroke(thingCol);
       strokeWeight(sWeight);
       line((int)x,(int)y, (int)x+1,(int)y+1);
      
    }
  }  
}