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
  pg.scale(1);
  pg.strokeWeight(1);
  pg.noStroke();
  pg.endDraw();
  ellipseMode(CENTER);
}
