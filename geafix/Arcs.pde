class Arcs implements Scene
{   
  arq[] arcs;
  float ray;
  int maxi;

  public Arcs(){};

  void closeScene(){};
  void initialScene(){
  	cleanPg();
    maxi=(int)sqrt(width/2*370+width/2*370)*2;
    pg.background(backCol);
    arcs= new arq[10];
    ray = 0;
    for(int a=0;a<10;a++){
      arcs[a]=new arq(width/2,height/2,50+a*45);
    }
    arcs=(arq[]) reverse(arcs);
    
    
    pg.smooth(); 
    
    
  };
  void drawScene(){
    ray+=0.9; 
    if(ray>45){
      ray=0;
      for(int a=0;a<arcs.length;a++){
        arcs[a].r+=45;
      }
       arcs = (arq[]) append (arcs, new arq(width/2,height/2,50));
        if(arcs[0].r>maxi){
         arcs = (arq[]) subset (arcs, 1);
        }
    }
    pg.beginDraw();
    pg.noFill();
    pg.background(backCol);
    pg.strokeWeight(20); 
    pg.strokeCap(SQUARE);
    pg.stroke(thingCol);
    for(int a=0;a<arcs.length;a++){
      arcs[a].dessine();
    }
    pg.ellipse(width/2,height/2,45,45);
    pg.endDraw();
    image(pg, 0, 0);
  };
  String getSceneName(){return "Arcs";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

  class arq{
    int x,y;
    mouvement m;
    float r,a,l,v;
    arq(int _x, int _y, int _r){
      m = new mouvement();
      x=_x;
      y=_y;
      r=_r;
      a=random(TWO_PI);
      l=random(0.3,0.7);
      v=random(-0.04,0.04);
    }
    void dessine(){
      pg.arc(x, y, r+ray, r+ray, a, a+l*PI); 
      pg.arc(x, y, r+ray, r+ray, a+PI, a+PI+l*PI);
      l=l+(1-l)*0.002;
      a+=m.bouge();
    }
  }

  class mouvement{
    float n,v,v2;
    mouvement(){
      n=0;v=PI/100;v2=random(0.01,0.05);
    } 
    float bouge(){
      n+=v;
      return cos(n)*v2;
    }
  }
}