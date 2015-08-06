class SquareFrac implements Scene
{ 
  float radio=160.0f;
  float angulo=0.0f;
  float escalamiento=0.65f;
  float angulo2=0.0f;
  int fade=25;
  int tol=3;
  int brazos=1;  

  public SquareFrac(){};

  void closeScene(){};
  void initialScene(){
    //resetDancers();
    dPos= new PVector(0,0);
    //cleanPg();
  }
  void drawScene(){
    if (frameCount % 5 == 0) {
      dancers.getDancers();
      if(dancers.hasDancers()){
        dPos = dancers.getFirstDancerMiddleAndTop();
      }
    }
    pg.beginDraw();
    //diferentes maneras de limpiar la pantalla
   //  background(0);
    pg.noStroke();
    pg.fill(backCol,fade);
    pg.rect(0,0,width,height);
    pg.stroke(thingCol);
    
    //trasladamos al centro
    pg.translate(width/2, height/2);
    //calculamos angulos con la posicion del mouse
    angulo=(dPos.x/float(width-20))*TWO_PI;
    angulo2=(dPos.y/float(height-20))*TWO_PI;
   //emepzamos el fractal en la etapa 0
    drawFractal(0);
    pg.endDraw();
    image(pg, 0, 0);
    //debug
   // fill(255,0,0);
    //ellipse(dPos.x, dPos.y, 14, 14);
  };
  String getSceneName(){return "SquareFrac";};
  void onPressedKey(String k){
    if (k== "UP") {
      tol+=1;
      println("tol "+tol);
    } 
    if (k == "DOWN") {
      tol-=1;
      println("tol "+tol);
    } 
    if (k == "RIGHT"){
      brazos+=1;
      println("brazos "+brazos);
    }
    if(k == "LEFT"){
      brazos-=1;
      println("brazos "+brazos);
    }
  };
  void onImg(PImage img){};

  void drawFractal(int n) {
    //si no nos hemos pasado en nuestra iteracion
    //si lo dibujamos
    if( n < tol ) {
      pg.fill(255,20);
      pg.rect(-radio/2,-radio/2,radio,radio);
      //circuloChido(20);

      //Aqui dibujo un brazo
      for(int i=0; i < brazos; i++) {
        pg.pushMatrix();
        pg.translate(radio*cos(angulo2 *i),radio*sin(angulo2 *i));
        pg.scale(escalamiento);
        pg.rotate(angulo);
        drawFractal(n+1);
        pg.popMatrix();
      }
    }
  }

}
