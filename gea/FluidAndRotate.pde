class FluidAndRotate implements Scene
{   
  boolean reject,lines,gravity;
  int particleCount = 9000;
  Particle[] particles = new Particle[particleCount+1];
  int influenceRadius=70;
  int sWeight=2;
  boolean move = true;
  // ahora empieza rotando
  boolean notRotating = false;

  public FluidAndRotate(){};

  void closeScene(){};
  void initialScene(){
    //resetDancers();
    backCol = 0;
    thingCol = 255;

    reject = true;
    lines = false;
    gravity = false;
    dPos= new PVector(0,0);

    for (int x = particleCount; x >= 0; x--) { 
      particles[x] = new Particle();
    }
    //rectMode(CORNER);
  };
  void drawScene(){
    background(backCol);

 
    dancers.getDancers();
    if(dancers.hasDancers()){
      if(notRotating) dPos = dancers.getFirstDancerMiddleXY();
      else dPos = dancers.getFirstDancerMiddleAndTop();
    }
    
    //debug
    //fill(255,0,0);
    //ellipse(dPos.x, dPos.y, 14, 14);
    
    fill(backCol);
    stroke (thingCol);
    strokeWeight(1);
    /* The border; it is 10 pixels from all sides */
    quad (10,10,10,height-10,width-10,height-10,width-10,10);  
    /* All of our particles are looped through, and updated */
    strokeWeight(sWeight);
    for (int i = particleCount; i >= 0; i--) { 
      Particle particle = (Particle) particles[i];
      if(notRotating) particle.update(i);
      else particle.updateRotate();
    }

    //drawGlobalAlpha();
  };
  String getSceneName(){return "FluidAndRotate";};
  void onPressedKey(String k){
    if(k=="gravity") gravity=!gravity;
    if(k=="lines") lines =!lines;
    if(k=="reject") reject=!reject;
    //aca va de rotate and move
    if(k=="shake") move=!move;
    if(k == "toggle") {
      if(notRotating){
        particleCount = 9000;
        particles = new Particle[particleCount+1];
        for (int x = particleCount; x >= 0; x--) { 
          particles[x] = new Particle();
        }
      } else{
        particleCount = 1500;
        particles = new Particle[particleCount+1];
        for (int x = particleCount; x >= 0; x--) { 
          particles[x] = new Particle();
        }
      }
      notRotating=!notRotating;
    }
    if(k=="RIGHT"){
      influenceRadius+=10;
      println("influenceRadius "+influenceRadius);
    }
    if(k=="LEFT"){
      influenceRadius-=10;
      println("influenceRadius "+influenceRadius);
    }
    if(k=="UP"){
      sWeight+=1;
    }
    if(k=="DOWN"){
      sWeight = max(sWeight-1,1);
    }
  };
  void onImg(PImage img){};


  class Particle {
    /* 
    Global class variables 
    These are kept track of, and aren't lost when the class particle is finished operating.
    */
    /* the x and y are our coordinates for each particles */
    float x;
    float y;
    /* vx and vy are the velocities along each axis the particles are traveling */
    float vx;
    float vy; 
    /* Particle initialization. We define the beginning properties of each particle here. */
    Particle() {
      x = random(10,width-10);
      y = random(10,height-10);
    }
    /* These are called everytime we check with the other particle's distances  */
    float getx() {
      return x; 
    }
    float gety() {
      return y;
    }
    void update(int num) {
      /* Friction is simulated here */
      vx *= 0.84;
       vy *= 0.84;
      /* Here, every particle is looped through and checked to see if they're close enough to have effect on the current particle. */
       for (int i = particleCount; i >= 0; i--)  {
         /* Check to see if the particle we're checking isn't the current particle. */
        if (i != num) { 
          /* drawthis boolean is initialized. it determines whether the particle is close enough to the other particles for relationship lines to be drawn, assuming it's enabled */
          boolean drawthis = false;
          /* 
          Integers are used to keep track of the shade for each particle
          The red shade shows opposition
          The blue shade shows attraction
          */
          float redshade = 0;
          float blueshade = 0;
          /* We set our particle */
          Particle particle = (Particle) particles[i];
          /* The x and y coordinates of the particle is found, so we can compare distances with our current particle. */
          float tx = particle.getx();
          float ty = particle.gety();
          /* The radius or distance between both particles are determined */
          float radius = dist(x,y,tx,ty);
          /* Is the radius small enough for the particle to have an effect on our current one? */
          if (radius < 35) { 
            /* We've the determine that the particle is close enough for relationship lines, so we set drawthis to true. */
            drawthis = true; 
            /* If so, we proceed to calculate the angle. */
            float angle = atan2(y-ty,x-tx);
            /* Is the radius close enough to be deflected? */
            if (radius < 30) {
              /* Is relationship lines toggled? */
              if (lines) {
               /* 
               Redshade is increased by the distance * 5. The distance is multiplied by 10 because our radius will be within 40 pixels,
               30 * 13.33... is 400
               We invert it so it gets redder as the particle approaches the current particle, rather than vice versa.
               */
              // redshade = 13 * (30 - radius);
              }
              /*
              Here, we calculate a coordinate at a angle opposite of the direction where the other particle is.
              0.07 is the strength of the particle's opposition, while (40 - radius) is how much it is effected, according to how close it is.
              */
              vx += (30 - radius) * 0.07 * cos(angle);
              vy += (30 - radius) * 0.07 * sin(angle);
             }
             /* 
             Here we see if the particle is within 25 and 35 pixels of the current particle 
             (we already know that the particle is under 35 pixels distance, since this if statement is nested
             in if (radius < 35), so rechecking is unnecessary
             */
             if (radius > 25) { 
               /* check to see if relationship lines are toggled */
               if (lines) {
                 /* The blue shade, between 0 and 400, is used to show how much each particle is attracted */
                 //blueshade = 40 * (35 - radius);
               }
               /* This does the opposite of the other check. It pulls the particle towards the other.  */
               vx -= (25 - radius) * 0.005 * cos(angle);
               vy -= (25 - radius) * 0.005 * sin(angle);
             }
          }
          /* Check to see if relationship lines are enabled */
          if (lines) {
            /* Check to see if the two particles are close enough. */
            if (drawthis) {
               /* Set the stroke color */
              // stroke (redshade, 0, blueshade);
               stroke(thingCol,20);
               /* draw the line */
               line(x,y,tx,ty);
            }
          }
        }
      }
      /* Check to see if the user is clicking */
      if (dancers.hasDancers()) {
        /* The cursor's x and y coordinates. */
        float tx = dPos.x;
        float ty = dPos.y;
        /* the distance between the cursor and particle */
        float radius = dist(x,y,tx,ty);
        if (radius < influenceRadius) {
          /* Calculate the angle between the particle and the cursor. */
          float angle = atan2(ty-y,tx-x);
          /* Are we left-clicking or not? */
          if (reject) {
            /* If left, then the particles are deflected */
            vx -= radius * 0.07 * cos(angle);
            vy -= radius * 0.07 * sin(angle);
            /* The stroke color is red */
            stroke(map(radius,0,100,0,255),0,0);
          }
          else {
            /* If right, the particles are attracted. */
            vx += radius * 0.07 * cos(angle);
            vy += radius * 0.07 * sin(angle); 
            /* The stroke color is blue */
            stroke(0,0,map(radius,0,100,0,255));
          }
          /* If line relationships are enabled, the lines are drawn. */
          if (lines) {

           // line (x,y,tx,ty); 
          }
        }
      }   
      /* Previox x and y coordinates are set, for drawing the trail */
      int px = (int)x;
      int py = (int)y;
      /* Our particle's coordinates are updated. */
      x += vx;
      y += vy;
      /* Gravity is applied. */
      if (gravity == true) vy += 0.7;
      /* Border collisions */
      if (x > width-11) {
        /* Reverse the velocity if towards wall */
        if (abs(vx) == vx) vx *= -1.0;
        /* The particle is placed back at the wall */
        x = width-11;
      }
      if (x < 11) {
        if (abs(vx) != vx) vx *= -1.0;
        x = 11;
      }
      if (y < 11) {
        if (abs(vy) != vy) vy *= -1.0;
        y = 11;
      }
      if (y > height-11) {
        if (abs(vy) == vy) vy *= -1.0;
        vx *= 0.6;
        y = height-11;
      }
      /* if relationship lines are disabled */
      if (!lines) {
        /* The stroke color is set to white */
        stroke (thingCol);
        /* The particle is drawn */
        line(px,py,int(x),int(y));
      }
    }
    void updateRotate() {
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