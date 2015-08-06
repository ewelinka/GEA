void switchBlackAndWhite(){
  if(backCol == 0){
    backCol = 255;
    thingCol = 0;
  }else{
    backCol = 0;
    thingCol = 255;
  }
}
void cleanPg(){
  pg.beginDraw();
  pg.background(backCol);
  pg.endDraw();
}

void defaultModes(){
  rectMode(CORNER);
  imageMode(CORNER);
  ellipseMode(CENTER);
}

float map_x(float x, float z){

  //float toSubstract = 512 - map(z,0,2900,0,512);
  float toSubstract = 0;
  float current_xLeft = 0+toSubstract;
  float current_xRight = 1024 - toSubstract;

  // stroke(0);
  // line(current_xLeft,0,current_xLeft,768 );
  // line(current_xRight,0,current_xRight,768 );
  //if( x < screen_xLeft || x > screen_xRight ) return 0;

  return map(x,0,640,current_xLeft,current_xRight);

   // else return map(x,screen_xLeft,screen_xRight,0,1024);
}

float map_y(float y){
  return map(y,0,480,0,768);
}

float map_just_x(float x){
  return map(x,0,640,0,1024);
}

PVector rescaleXY(PVector in){
  in.x = map_just_x(in.x);
  in.y =map_y(in.y);

  return in;
}

void getDancersFromAlternatives(int [] alter, int [] alterZ){
  int dancerIdx = 1;
  boolean hasSomething = true;
  int sizeOfSomething = 0;
  int startIdx = 0;
  int verticalSum = 0;

  for(int x=0;x <context.depthWidth();x+=1){
    if((alter[x]>0) && !(alter[x]==8000)){
      if(!hasSomething) startIdx = x;
      sizeOfSomething+=1;
      hasSomething = true;
      verticalSum+=alter[x];
    }else{
      
      if((sizeOfSomething > 60) && (verticalSum > 1000)){
        dancers.updateDancer(dancerIdx,startIdx + (x-1-startIdx)/2,240,alterZ[x-1]);
        //println("XXX update from alternatives XXX with id "+dancerIdx + " start "+startIdx+" end "+x );
        // fill(255);
        // rect(0,0,width, height);
        if(hasSomething) dancerIdx+=1;
      } 
      verticalSum =0;
      hasSomething = false;
      sizeOfSomething = 0;
    }
  }
}

void drawGlobalAlpha(){
  fill(0, globalAlpha);
  noStroke();
  rect(0,0,width,height);
}

void resetDancers(){
  dancerPos= lastPos= new ArrayList<PVector>();
  dPos=pdPos= new PVector();
}

////// for Fisica and FWorld
void contactStarted(FContact c) {
  switch(contactType){
    case 0:
      removeAll(c);
      break;
    case 1:
      removeBelow(c);
    default:
      //nothing();
      break;
  }
}

void removeAll(FContact c){
  FBody ball = null;
  if (c.getBody1() == semiCircle) {
    ball = c.getBody2();
  } else if (c.getBody2() == semiCircle) {
    ball = c.getBody1();
  }
  if (c.getBody1() == belowBox) {
    ball = c.getBody2();
  } else if (c.getBody2() == belowBox) {
    ball = c.getBody1();
  }
  
  if (ball == null) {
    return;
  }
  //ball.setFill(30, 190, 200);
  world.remove(ball);
}

void removeBelow(FContact c){
  FBody ball = null;

  if (c.getBody1() == belowBox) {
    ball = c.getBody2();
  } else if (c.getBody2() == belowBox) {
    ball = c.getBody1();
  }
  
  if (ball == null) {
    return;
  }
  //ball.setFill(30, 190, 200);
  world.remove(ball);
}

void nothing(){};