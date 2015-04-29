
class Dancer 
{   
  PVector 
    pos_left, 
    pos_right,
    pos_top,
    pos_middle;
  float top;
  float depth;
  int id;
  
  //not projection positions but positions in kinect image
  public Dancer(float left_x, float left_y, int depth, int id)
  {
    pos_left = new PVector(left_x,left_y);
    pos_right = new PVector(left_x, left_y);
    pos_middle = new PVector(0,0);
    pos_top = new PVector(0,height);
    this.depth = depth;
    id = id;
    // ok!kprintln("d "+depth);
  }

  int getId(){ return id;}
  float[] getAllVals(){
    float[] allVals = { pos_left.x, pos_left.y, pos_right.x, pos_right.y, pos_middle.x, pos_middle.y, pos_top.x, pos_top.y, this.depth}; 
    return allVals;
  }
  PVector getLeft(){ return pos_left; } 
  PVector getRight(){ return pos_right; } 
  float getTop(){ return pos_top.y;}    

  float getMiddle(){ return pos_middle.x;}
  PVector getMiddleXY(){return pos_middle;}
 // PVector getMiddleTop(){ return PVector(middle,top);}
  float getDepth(){ return this.depth;}

  void checkRightTopDepth(float x, float y, float d){
    if(x > pos_right.x) {
      pos_right.x = x;
      pos_right.y = y;
    }
    if(y < pos_top.y) {
      pos_top.y = y;
      pos_top.x = x;
    }
    
    if(d < this.depth) {
      //println("new d "+d +" old one: "+this.depth);
      this.depth = d;
    }
  }


  void setRescaledValues(){
    pos_left.x = map_x(pos_left.x, this.depth);
    pos_left.y = map_y(pos_left.y);
    pos_right.x = map_x(pos_right.x, this.depth);
    pos_right.y = map_y(pos_right.y);
    pos_top.x = map_x(pos_top.x, this.depth);
    pos_top.y = map_y(pos_top.y); 
    float middle = min(pos_left.x,pos_right.x) + abs(pos_left.x - pos_right.x)/2;
    float middle_y = ( height -top)/2 +top;
    pos_middle = new PVector(middle,middle_y);
  }

  void setConstrainedValues(float[] nVals){
    pos_left.x= nVals[0] ;
    pos_left.y= nVals[1] ;
    pos_right.x= nVals[2] ;
    pos_right.y= nVals[3] ;
    pos_middle.x= nVals[4] ;
    pos_middle.y= nVals[5] ;
    pos_top.x= nVals[6]; 
    pos_top.y= nVals[7]; 
    this.depth= nVals[8] ;

  }

} 
