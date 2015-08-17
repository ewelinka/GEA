
class SquareBackgroundK implements Scene
{   
  int tileCountX =32;
  int tileCountY =27;
  int rectSize = 30;
  int refY = 0;
  float rotY = 0.0;
  int alphaLocal = 200;
  int divVal =30;


  public SquareBackgroundK(){};

  void closeScene(){};
  void initialScene(){
    smooth();
    noStroke();
    dPos = new PVector(width,0);
  };
  void drawScene(){
    randomSeed(0);
    //background(backCol);
    fill(backCol,alphaLocal);
    rect(0,0,width,height);

    dancers.getDancers();
    if(dancers.hasDancers()){
      dPos = dancers.getFirstDancerMiddleAndTop();
    } 
    //debug
    //fill(255,0,0);
    //ellipse(dPos.x, dPos.y, 14, 14);

    //rotateX(rotY);
    //rotY = map (frameCount%400,0,400,-0.4,0.4);

    fill(thingCol,210);
    //println("width/tileCountX "+width/tileCountX);
    for (int gridY=0; gridY<=tileCountY; gridY++) {
      for (int gridX=0; gridX<=tileCountX; gridX++) {
        
        int posX = width/tileCountX * gridX;
        int posY = height/tileCountY * gridY;

        // float shiftX1 = (width/2 - abs(width/2 - dPos.x))/15 * random(-1, 1);
        // float shiftY1 = (height/2 - abs(height/2 - refY))/15 * random(-1, 1);
        // float shiftX2 = (width/2 - abs(width/2 - dPos.x))/15 * random(-1, 1);
        // float shiftY2 = (height/2 - abs(height/2 - refY))/15 * random(-1, 1);
        // float shiftX3 = (width/2 - abs(width/2 - dPos.x))/15 * random(-1, 1);
        // float shiftY3 = (height/2 - abs(height/2 - refY))/15 * random(-1, 1);
        // float shiftX4 = (width/2 - abs(width/2 - dPos.x))/15 * random(-1, 1);
        // float shiftY4 = (height/2 - abs(height/2 - refY))/15 * random(-1, 1);

        float shiftX1 = (width/2 - abs(width/2 - dPos.x))/divVal * random(-1, 1);
        float shiftY1 = (width/2 - abs(width/2 - dPos.x))/divVal * random(-1, 1);
        float shiftX2 = (width/2 - abs(width/2 - dPos.x))/divVal * random(-1, 1);
        float shiftY2 = (width/2 - abs(width/2 - dPos.x))/divVal * random(-1, 1);
        float shiftX3 = (width/2 - abs(width/2 - dPos.x))/divVal * random(-1, 1);
        float shiftY3 = (width/2 - abs(width/2 - dPos.x))/divVal * random(-1, 1);
        float shiftX4 = (width/2 - abs(width/2 - dPos.x))/divVal * random(-1, 1);
        float shiftY4 = (width/2 - abs(width/2 - dPos.x))/divVal * random(-1, 1);
       
        beginShape();
        vertex(posX+shiftX1, posY+shiftY1);
        vertex(posX+tileCountX+shiftX2, posY+shiftY2);
        vertex(posX+tileCountX+shiftX3, posY+tileCountY+shiftY3);
        vertex(posX+shiftX4, posY+tileCountY+shiftY4);
        endShape(CLOSE);
      }
    } 

    drawGlobalAlpha();
  };
  String getSceneName(){return "SquareBackgroundK";};
  void onPressedKey(String k){
    if(k=="UP"){
      alphaLocal = min(alphaLocal+10,255);
      println("alphaLocal ",alphaLocal);
    }
    if(k=="DOWN"){
      alphaLocal = max(alphaLocal-10,1);
      println("alphaLocal ",alphaLocal);
    }

    if(k=="RIGHT"){
      divVal=max(divVal-2,3);
      println("divVal "+divVal);
    }
    if(k=="LEFT"){
      divVal=min(divVal+2,30);
      println("divVal "+divVal);
    }

  };
  void onImg(PImage img){};
}



