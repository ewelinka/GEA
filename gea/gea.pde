import SimpleOpenNI.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import processing.video.*;
import fisica.*;

FWorld world;
FBox humanBox, belowBox;
FPoly semiCircle;

ArrayList<PVector> dancerPos= new ArrayList<PVector>();
ArrayList<PVector> lastPos= new ArrayList<PVector>();
PVector dPos,pdPos;

boolean captured = false;

SceneManager manager;
DancersManager dancers;
ArrayList<Character> numbers =new ArrayList<Character>();

SimpleOpenNI context;

float screen_xLeft,screen_xRight;
float globalAlpha;
int backCol = 0;
int thingCol = 255;
int contactType = 2;

PGraphics pg;

public void init(){

  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}
 

void setup(){
  size(1024, 768,P3D);
  //noCursor();

  globalAlpha = 0;

  numbers.add(0,'0');
  numbers.add(1,'1');
  numbers.add(2,'2');
  numbers.add(3,'3');
  numbers.add(4,'4');
  numbers.add(5,'5');
  numbers.add(6,'6');
  numbers.add(7,'7');
  numbers.add(8,'8');
  numbers.add(9,'9');

  manager = new SceneManager();  

  // int scenesNr = manager.getScenesNr();
  // for (int i =0;i<=scenesNr;i++){
  //   numbers.add(i,char(i));
  // }
  Fisica.init(this);
  world = new FWorld();

  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  //context.setMirror(false);
  context.enableDepth();
  context.enableUser();

  screen_xLeft = 0;
  screen_xRight = 640;

  dancers = new DancersManager(); 

  pg = createGraphics(width, height);
}


void draw(){
  manager.actualScene.drawScene(); 
  drawGlobalAlpha();
}

void keyReleased(){
  if (keyCode == UP) manager.pressedKey("UP");
  if (keyCode == DOWN) manager.pressedKey("DOWN");
  if (keyCode == LEFT) manager.pressedKey("LEFT");
  if (keyCode == RIGHT) manager.pressedKey("RIGHT");


  if (key == 't'|| key =='T') manager.pressedKey("toggle");
  if (key == 'l' || key =='L') manager.pressedKey("lines");
  if (key == 'r' || key =='R') manager.pressedKey("reject");
  if (key == 'g' || key == 'G') manager.pressedKey("gravity");

  // global variables
  if (key == 'v' || key =='V') {
    globalAlpha = min(globalAlpha+5,255);
    println("globalAlpha "+globalAlpha);
  }  
  //black
  if (key == 'b' || key =='B') globalAlpha = 255;
  //nothing
  if (key == 'n' || key =='N') {
    globalAlpha = 0;
  }  
  if (key == 'm'|| key =='M'){
    globalAlpha = max(globalAlpha-5, 0);
    println("globalAlpha "+globalAlpha);
  }


  if (key == 'a' || key =='A') switchBlackAndWhite();

  if(numbers.contains(key)) manager.activate(numbers.indexOf(key));
  if (key == '-') manager.activatePrevScene();
  if (key == '=') manager.activateNextScene();

}

/*boolean sketchFullScreen() {
  return true;
}*/



