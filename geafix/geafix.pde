import processing.video.*; 

Capture myCapture; 

SceneManager manager;
int backCol;
int thingCol;
int globalAlpha;
ArrayList<Character> numbers =new ArrayList<Character>();
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
  backCol = 0;
  thingCol = 255;

  numbers.add(0,'0');
  numbers.add(1,'1');
  numbers.add(2,'2');
  numbers.add(3,'3');
  // numbers.add(4,'4');
  // numbers.add(5,'5');
  // numbers.add(6,'6');
  // numbers.add(7,'7');
  // numbers.add(8,'8');
  // numbers.add(9,'9');

  manager = new SceneManager();  

  pg = createGraphics(width, height);
  myCapture = new Capture(this,640,480,"/dev/video2");
}


void draw(){
  manager.actualScene.drawScene(); 
  //drawGlobalAlpha();
}

void keyReleased(){
  if (keyCode == UP) manager.pressedKey("UP");
  if (keyCode == DOWN) manager.pressedKey("DOWN");
  if (keyCode == LEFT) manager.pressedKey("LEFT");
  if (keyCode == RIGHT) manager.pressedKey("RIGHT");

  if (key == 't'|| key =='T') manager.pressedKey("toggle");
  if (key == 'l' || key =='L') manager.pressedKey("lines");
  if (key == 'r' || key =='R') manager.pressedKey("reject");

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



