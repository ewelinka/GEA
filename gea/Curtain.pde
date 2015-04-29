class Curtain implements Scene
{   
  boolean move = true;
  ArrayList particles;

  float mouseInfluenceSize = 10; 
  float mouseTearSize = 8;
  float mouseInfluenceScalar = 1;

  float gravity = 392; 

  final int curtainHeight = 60;
  final int curtainWidth = 84;
  final int yStart = 0; // where will the curtain start on the y axis?
  final float restingDistances = 12; // size of squares
  final float stiffnesses = 1;
  final float curtainTearSensitivity = 50; // distance the particles have to go before ripping

  long previousTime;
  long currentTime;
  final int fixedDeltaTime = 15;
  float fixedDeltaTimeSeconds = (float)fixedDeltaTime / 1000.0;

  int leftOverDeltaTime = 0;
  int constraintAccuracy = 3;

  public Curtain(){};

  void closeScene(){};
  void initialScene(){
    mouseInfluenceSize *= mouseInfluenceSize; 
    mouseTearSize *= mouseTearSize;
    createCurtain();
  };
  void drawScene(){
    fill(backCol,100);
    rect(0,0,width,height);
    trackingSkeleton();

    currentTime = millis();
    long deltaTimeMS = currentTime - previousTime;
    previousTime = currentTime; // reset previousTime
    int timeStepAmt = (int)((float)(deltaTimeMS + leftOverDeltaTime) / (float)fixedDeltaTime);
    // Here we cap the timeStepAmt to prevent the iteration count from getting too high and exploding
    timeStepAmt = min(timeStepAmt, 5);
    leftOverDeltaTime += (int)deltaTimeMS - (timeStepAmt * fixedDeltaTime); // add to the leftOverDeltaTime.
    mouseInfluenceScalar = 1.0 / timeStepAmt;

    for (int iteration = 1; iteration <= timeStepAmt; iteration++) {
      for (int x = 0; x < constraintAccuracy; x++) {
        for (int i = 0; i < particles.size(); i++) {
          Particle particle = (Particle) particles.get(i);
          particle.solveConstraints();
        }
      }
      for (int i = 0; i < particles.size(); i++) {
        Particle particle = (Particle) particles.get(i);
        particle.updateInteractions();
        particle.updatePhysics(fixedDeltaTimeSeconds);
      }
    }

    for (int i = 0; i < particles.size(); i++) {
      Particle particle = (Particle) particles.get(i);
      particle.draw();
    }
   
    if (frameCount % 60 == 0)
      println("Frame rate is " + frameRate);

  };
  String getSceneName(){return "Curtain";};
  void onPressedKey(String k){
    if(k == "reject") createCurtain(); // we reset the curtain
    if(k == "gravity") toggleGravity();
    if(k == "toggle") toggleMove();

  };
  void onImg(PImage img){};

  void createCurtain () {
    particles = new ArrayList();
    int midWidth = (int) (width/2 - (curtainWidth * restingDistances)/2);
    // Since this our fabric is basically a grid of points, we have two loops
    for (int y = 0; y <= curtainHeight; y++) { // due to the way particles are attached, we need the y loop on the outside
      for (int x = 0; x <= curtainWidth; x++) { 
        Particle particle = new Particle(new PVector(midWidth + x * restingDistances, y * restingDistances + yStart));
        
        if (x != 0) 
          particle.attachTo((Particle)(particles.get(particles.size()-1)), restingDistances, stiffnesses);
        if (y != 0)
          particle.attachTo((Particle)(particles.get((y - 1) * (curtainWidth+1) + x)), restingDistances, stiffnesses);       
        // we pin the very top particles to where they are
        if (y == 0)
          particle.pinTo(particle.position); 
        // add to particle array  
        particles.add(particle);
      }
    }
  }
  void toggleGravity () {
    if (gravity != 0)
      gravity = 0;
    else
      gravity = 392;
  }

  void toggleMove () {
    move = !move;
  }

  float distPointToSegmentSquared (float lineX1, float lineY1, float lineX2, float lineY2, float pointX, float pointY) {
    float vx = lineX1 - pointX;
    float vy = lineY1 - pointY;
    float ux = lineX2 - lineX1;
    float uy = lineY2 - lineY1;
    
    float len = ux*ux + uy*uy;
    float det = (-vx * ux) + (-vy * uy);
    if ((det < 0) || (det > len)) {
      ux = lineX2 - pointX;
      uy = lineY2 - pointY;
      return min(vx*vx+vy*vy, ux*ux+uy*uy);
    }
    
    det = ux*vy - uy*vx;
    return (det*det) / len;
  }

  // the Particle class.
  class Particle {
    PVector lastPosition; // for calculating position change (velocity)
    PVector position;
    
    PVector acceleration; 
    
    float mass = 1;
    float damping = 20;

    // An ArrayList for links, so we can have as many links as we want to this particle :)
    ArrayList links = new ArrayList();
    
    boolean pinned = false;
    PVector pinLocation = new PVector(0,0);
    
    // Particle constructor
    Particle (PVector pos) {
      position = pos.get();
      lastPosition = pos.get();
      acceleration = new PVector(0,0);
    }
    
    // The update function is used to update the physics of the particle.
    // motion is applied, and links are drawn here
    void updatePhysics (float timeStep) { // timeStep should be in elapsed seconds (deltaTime)
      // gravity:
      // f(gravity) = m * g
      PVector fg = new PVector(0, mass * gravity);
      this.applyForce(fg);
      
      
      /* Verlet Integration, WAS using http://archive.gamedev.net/reference/programming/features/verlet/ 
         however, we're using the tradition Velocity Verlet integration, because our timestep is now constant. */
      // velocity = position - lastPosition
      PVector velocity = PVector.sub(position, lastPosition);
      // apply damping: acceleration -= velocity * (damping/mass)
      acceleration.sub(PVector.mult(velocity,damping/mass)); 
      // newPosition = position + velocity + 0.5 * acceleration * deltaTime * deltaTime
      PVector nextPos = PVector.add(PVector.add(position, velocity), PVector.mult(PVector.mult(acceleration, 0.5), timeStep * timeStep));
      
      // reset variables
      lastPosition.set(position);
      position.set(nextPos);
      acceleration.set(0,0,0);
    } 
    void updateInteractions () {
      // this is where our interaction comes in.
     // if(mr.y != 0){
      if(captured){
        // for all interesting body points
        for (int i = 0; i < dancerPos.size(); i++) {
          PVector last = (PVector) lastPos.get(i);
          PVector now = (PVector) dancerPos.get(i);
          float distanceSquared = distPointToSegmentSquared(last.x,last.y,now.x,now.y,position.x,position.y);
          //println("distanceSquared "+distanceSquared);
          //to move the curtain
          if (move) {
            if (distanceSquared < mouseInfluenceSize) { // remember mouseInfluenceSize was squared in setup()
              // To change the velocity of our particle, we subtract that change from the lastPosition.
              // When the physics gets integrated (see updatePhysics()), the change is calculated
              // Here, the velocity is set equal to the cursor's velocity
              lastPosition = PVector.sub(position, new PVector((now.x-last.x)*mouseInfluenceScalar, (now.y-last.y)*mouseInfluenceScalar));
            }
          }
          else { // we tear the cloth by removing links
            if (distanceSquared < mouseTearSize) 
              links.clear();
          }
        }
      }
    }

    void draw () {
      // draw the links and points
      stroke(255);
      if (links.size() > 0) {
        for (int i = 0; i < links.size(); i++) {
          Link currentLink = (Link) links.get(i);
          currentLink.draw();
        }
      }
      else
        point(position.x, position.y);
    }
    /* Constraints */
    void solveConstraints () {
      /* Link Constraints */
      // Links make sure particles connected to this one is at a set distance away
      for (int i = 0; i < links.size(); i++) {
        Link currentLink = (Link) links.get(i);
        currentLink.constraintSolve();
      }
      
      /* Boundary Constraints */
      // These if statements keep the particles within the screen
      if (position.y < 1)
        position.y = 2 * (1) - position.y;
      if (position.y > height-1)
        position.y = 2 * (height - 1) - position.y;
      if (position.x > width-1)
        position.x = 2 * (width - 1) - position.x;
      if (position.x < 1)
        position.x = 2 * (1) - position.x;
      
      /* Other Constraints */
      // make sure the particle stays in its place if it's pinned
      if (pinned)
        position.set(pinLocation);
    }
    
    // attachTo can be used to create links between this particle and other particles
    void attachTo (Particle P, float restingDist, float stiff) {
      Link lnk = new Link(this, P, restingDist, stiff);
      links.add(lnk);
    }
    void removeLink (Link lnk) {
      links.remove(lnk);
    }  
   
    void applyForce (PVector f) {
      // acceleration = (1/mass) * force
      // or
      // acceleration = force / mass
      acceleration.add(PVector.div(f, mass));
    }
    
    void pinTo (PVector location) {
      pinned = true;
      pinLocation.set(location);
    }
  }

  // The Link class is used for handling constraints between particles.
  class Link {
    float restingDistance;
    float stiffness;
    
    Particle p1;
    Particle p2;
    
    // the scalars are how much "tug" the particles have on each other
    // this takes into account masses and stiffness, and are set in the Link constructor
    float scalarP1;
    float scalarP2;
    
    // if you want this link to be invisible, set this to false
    boolean drawThis = true;
    
    Link (Particle which1, Particle which2, float restingDist, float stiff) {
      p1 = which1; // when you set one object to another, it's pretty much a reference. 
      p2 = which2; // Anything that'll happen to p1 or p2 in here will happen to the paticles in our array
      
      restingDistance = restingDist;
      stiffness = stiff;
      
      // although there are no differences in masses for the curtain, 
      // this opens up possibilities in the future for if we were to have a fabric with particles of different weights
      float im1 = 1 / p1.mass; // inverse mass quantities
      float im2 = 1 / p2.mass;
      scalarP1 = (im1 / (im1 + im2)) * stiffness;
      scalarP2 = (im2 / (im1 + im2)) * stiffness;
    }
    
    void constraintSolve () {
      // calculate the distance between the two particles
      PVector delta = PVector.sub(p1.position, p2.position);  
      float d = sqrt(delta.x * delta.x + delta.y * delta.y);
      float difference = (restingDistance - d) / d;
      
      // if the distance is more than curtainTearSensitivity, the cloth tears
      // it would probably be better if force was calculated, but this works
      if (d > curtainTearSensitivity) 
        p1.removeLink(this);
      
      // P1.position += delta * scalarP1 * difference
      // P2.position -= delta * scalarP2 * difference
      p1.position.add(PVector.mult(delta, scalarP1 * difference));
      p2.position.sub(PVector.mult(delta, scalarP2 * difference));
    }

    void draw () {
      if (drawThis)
        line(p1.position.x, p1.position.y, p2.position.x, p2.position.y);
    }
  }

}