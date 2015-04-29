
class RotatingFrac implements Scene
{   
  int num = 6; // size of matrix

  float power = 4; // power in coloring algorithm
  float angle = TWO_PI; // angle in spread of branches
  boolean spots = true; // draw dots on nodes, yes or no

  public RotatingFrac(){};

  void closeScene(){};
  void initialScene(){
    //calcNumf();
    //resetDancers();
    strokeWeight(1);
  };
  void drawScene(){
    background(backCol); // wipe the background
    fill(thingCol);
    if (frameCount % 5 == 0) {
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
    }
    pushMatrix();
      translate(width/2, height/2);
      fill(abs(backCol-60),100);
      ellipse(0, 0, height-30, height-30);
      rotate(map(frameCount%1000,0,1000,0 ,2*PI));
      plotFrac(0,0,num,PI,TWO_PI);
    popMatrix();
    //just for debugging
    fill(255,0,0);
    ellipse(dPos.x, dPos.y, 14, 14);
  };
  String getSceneName(){return "RotatingFrac";};
  void onPressedKey(String k){
    if(k == "RIGHT" && num < 6){
      num++;
    }
    if(k == "LEFT" && num > 2 ){
      num--;
    }
    if( k == "toggle" ) { // toggle drawing nodes option when spacebar is pressed
      spots = !spots;
    }

  };

  void onImg(PImage img){};

  void plotFrac( float x, float y, int n, float stem, float range ) {
    stroke(thingCol,100);
    float r; // distance between nodes
    float t; // angle between nodes
    // use an appropriate algorithm to calculate distance between given nodes
    r = (0.5*power+2) * 35 * pow(n,power) * pow(num,-power);
    
    // if spots is on and we are on the first value of n, map initial node
    if( spots && n == num ) {
      fill(thingCol);
      ellipse(x,y,n+2,n+2);
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
          ellipse(x+r*cos(t), y+r*sin(t), n+2, n+2);
        }
        // spread nodes across PI radians
        //plotFrac(x+r*cos(t),y+r*sin(t),n-1,t,PI);
        
        // spread nodes across "angle" radians
        plotFrac(x+r*cos(t),y+r*sin(t),n-1,t,angle);
      }
    }
  }
}