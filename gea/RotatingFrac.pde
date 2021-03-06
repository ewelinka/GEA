
class RotatingFrac implements Scene
{   
  int num = 6; // size of matrix
  int pointSize = 2;
  int velocity =1000;

  float power = 4; // power in coloring algorithm
  float angle = TWO_PI; // angle in spread of branches
  boolean spots = true; // draw dots on nodes, yes or no

  public RotatingFrac(){};

  void closeScene(){};
  void initialScene(){
    //calcNumf();
    //resetDancer();
    strokeWeight(1);
    
  };
  void drawScene(){

    background(backCol); // wipe the background
    fill(thingCol);
    //if (frameCount % 5 == 0) {
      dancers.getDancers();
      if(dancers.hasDancers()){
        dPos = dancers.getFirstDancerMiddleAndTop();
        //angle = TWO_PI * dPos.x/width; // mouseX controls angle range of nodes
        angle = TWO_PI * (width/2 - abs(width/2 -dPos.x))/width; 

      
        //power = 1/50.0 * dPos.y; // mouseY controls perspective of viewing nodes
       // power = 1/50.0 * (height/2 - abs(height/2 -mouseY)); 
       // power = 1/50.0 * mouseY; 
        power = abs(height/2 -dPos.y)*1/50;
        
      }
   // }

    //debug
    //fill(255,0,0);
    //ellipse(dPos.x, dPos.y, 14, 14);

    int shiftFrac =100;
    drawOneFrac(width/2, height/2);
    drawOneFrac(0+shiftFrac, height-shiftFrac);
    drawOneFrac(0+shiftFrac, 0+shiftFrac);
    drawOneFrac(width-shiftFrac, height-shiftFrac);
    drawOneFrac(width-shiftFrac, 0+shiftFrac);
    //just for debugging
    //fill(255,0,0);
    //ellipse(dPos.x, dPos.y, 14, 14);

    drawGlobalAlpha();
  };
  String getSceneName(){return "RotatingFrac";};
  void onPressedKey(String k){
    // if(k == "RIGHT" && num < 6){
    //   num++;
    // }
    // if(k == "LEFT" && num > 2 ){
    //   num--;
    // }
    if(k == "RIGHT" ){
      velocity=max(velocity -50,10);
      println("velocity ", velocity);
    }
    if(k == "LEFT"){
      velocity+=50;
      println("velocity ", velocity);
    }
    if( k == "toggle" ) { // toggle drawing nodes option when spacebar is pressed
      spots = !spots;
    }

    if(k=="UP"){
      pointSize+=1;
      println("pointSize "+pointSize);
    }
    if(k=="DOWN"){
      pointSize = max(pointSize-1,1);
      println("pointSize "+pointSize);
    }

  };

  void onImg(PImage img){};

  void drawOneFrac(float px, float py){
    pushMatrix();
      translate(px,py);
      //fill(abs(backCol-60),100);
      //ellipse(0, 0, height-30, height-30);
      rotate(map(frameCount%velocity,0,velocity,0 ,2*PI));
      plotFrac(0,0,num,PI,TWO_PI);
    popMatrix();

  }

  void plotFrac( float x, float y, int n, float stem, float range ) {
    stroke(thingCol,100);
    //strokeWeight(2);
    float r; // distance between nodes
    float t; // angle between nodes
    // use an appropriate algorithm to calculate distance between given nodes
    r = (0.5*power+2) * 35 * pow(n,power) * pow(num,-power);
    
    // if spots is on and we are on the first value of n, map initial node
    if( spots && n == num ) {
      fill(thingCol);
      ellipse(x,y,n+pointSize,n+pointSize);
    }

    // map nodes
    if( n>1 ) {
      for( int i=0; i<n; i++ ) { // step through each node to be created
        // calculate angle of node from current "stem" angle, spread along "range" radians
        t = stem + range * (i+0.5)/n - range/2;
        // draw line between nodes
        line( x, y, x+r*cos(t), y+r*sin(t) );
        if( spots ) { // if spots, draw node
          fill(thingCol);
          ellipse(x+r*cos(t), y+r*sin(t), n+pointSize, n+pointSize);
        }
        // spread nodes across PI radians
        //plotFrac(x+r*cos(t),y+r*sin(t),n-1,t,PI);
        
        // spread nodes across "angle" radians
        plotFrac(x+r*cos(t),y+r*sin(t),n-1,t,angle);
      }
    }
  }
}