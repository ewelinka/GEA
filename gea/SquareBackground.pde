
class SquareBackground implements Scene
{   
  int tileCountX =32;
  int tileCountY =27;
  int rectSize = 30;


  public SquareBackground(){};

  void closeScene(){};
  void initialScene(){
    smooth();
    noStroke();
  };
  void drawScene(){
    randomSeed(0);
    background(backCol);
    fill(thingCol,210);
    //println("width/tileCountX "+width/tileCountX);
    for (int gridY=0; gridY<=tileCountY; gridY++) {
      for (int gridX=0; gridX<=tileCountX; gridX++) {
        
        int posX = width/tileCountX * gridX;
        int posY = height/tileCountY * gridY;

        float shiftX1 = (width/2 - abs(width/2 - mouseX))/15 * random(-1, 1);
        float shiftY1 = (height/2 - abs(height/2 - mouseY))/15 * random(-1, 1);
        float shiftX2 = (width/2 - abs(width/2 - mouseX))/15 * random(-1, 1);
        float shiftY2 = (height/2 - abs(height/2 - mouseY))/15 * random(-1, 1);
        float shiftX3 = (width/2 - abs(width/2 - mouseX))/15 * random(-1, 1);
        float shiftY3 = (height/2 - abs(height/2 - mouseY))/15 * random(-1, 1);
        float shiftX4 = (width/2 - abs(width/2 - mouseX))/15 * random(-1, 1);
        float shiftY4 = (height/2 - abs(height/2 - mouseY))/15 * random(-1, 1);
       
        beginShape();
        vertex(posX+shiftX1, posY+shiftY1);
        vertex(posX+tileCountX+shiftX2, posY+shiftY2);
        vertex(posX+tileCountX+shiftX3, posY+tileCountY+shiftY3);
        vertex(posX+shiftX4, posY+tileCountY+shiftY4);
        endShape(CLOSE);
      }
    } 
  };
  String getSceneName(){return "SquareBackground";};
  void onPressedKey(String k){};
  void onImg(PImage img){};
}



