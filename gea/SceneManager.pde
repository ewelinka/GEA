

class SceneManager{

  Scene[] scenes;  
  Scene actualScene;
  int actualSceneNr;
  
  SceneManager(){

    Scene [] allScenes = {  
      new Nothing() ,        // 0
      new RotatingSphere(),  // 1
      new RotatingFrac(),    // 2
      new DepthSquare(),     // 3
      new Curtain(),         // 4
      new Fluid(),           // 5
      new Rain(),            // 6
      new SemiCircles() ,    // 7
      new FluidAndRotate(),  // 7.2
      new RotatingFrac(),
      new SquareFrac(),
      new Fluid(),
      new SquareBackgroundK(),
      new LineArt() ,
      new HypnoticCircle() 
    };

    scenes =allScenes;
    actualSceneNr = 0;
    scenes[0].initialScene();
    actualScene = scenes[0];
  }

  int getScenesNr(){ return scenes.length;}

  void updateTimeDisplace(PImage img){
    scenes[6].onImg(img);
  }

  void setBlack(){
    background(0);
  }

  void activateNextScene(){
    int sceneNr = (actualSceneNr+1)%(scenes.length);
    activate(sceneNr);
  }

  void activatePrevScene(){
    int sceneNr;
    if(actualSceneNr-1 < 0) sceneNr = scenes.length -1;
    else sceneNr = (actualSceneNr-1)%(scenes.length);
    activate(sceneNr);
  }

  void activate(int sceneNr){
    actualSceneNr = sceneNr;
    actualScene.closeScene();
    //setBlack();
    actualScene = scenes[sceneNr];
    resetDancers();
    cleanPg();
    defaultModes();
    actualScene.initialScene();
    println(sceneNr+" "+actualScene.getSceneName());
  }

  void pressedKey(String pKey){
    actualScene.onPressedKey(pKey);
  }
}

/**
  Scene
*/
 
interface Scene
{ 
    void initialScene();
    void drawScene();
    void closeScene();
    String getSceneName();
    void onPressedKey(String k);
    void onImg(PImage img);
}


class Example implements Scene
{   
  public Example(){};

  void closeScene(){};
  void initialScene(){};
  void drawScene(){};
  String getSceneName(){return "Example";};
  void onPressedKey(String k){};
  void onImg(PImage img){};
}