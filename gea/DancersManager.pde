
class DancersManager {
  HashMap<Integer,Dancer> hm;
  HashMap<Integer,Dancer> pDancers;
  IntList ids;

  DancersManager(){
    hm = new HashMap<Integer,Dancer>();
    pDancers = new HashMap<Integer,Dancer>();
    ids = new IntList();
  }
 
  void updateDancer(int nr, float x, float y, int d ) {
    //println("in update dancer with "+nr);
    Dancer dancer;
    if (hm.containsKey(nr)) {
      dancer = (Dancer)hm.get(nr);
      // we check if it is a value number
      dancer.checkRightTopDepth(x,y,d);

    } else {
      // it has to be most left point because of the algorithm
      // now we just have to look for most right and top
      dancer = new Dancer( x, y, d, nr);  
      ids.append(nr);   
    }
    hm.put(nr,dancer); 
  }

  Dancer getDancer(int dancerNr){
    return (Dancer)hm.get(dancerNr);
  }

  void cleanHm(){ 
    pDancers = hm;
    ids.clear();
    hm.clear();
  }

  void rescale(){
    for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {

      Dancer da = idancer.getValue();
      da.setRescaledValues();
      // println("left: x "+da.pos_left.x +" "+da.pos_left.y);
      // println("right: x "+da.pos_right.x +" "+da.pos_right.y);
      // println("middle:  "+da.middle);
      // println("top:  "+da.top);

      // here comes the values control
      int daId = idancer.getKey();
      //println("daId " +daId);
      // for (Entry<Integer,Dancer> pidancer : dancers.pDancers.entrySet()){
      //   int k = pidancer.getKey();
      //   println("keys in pDancers "+k);

      // }

      if (pDancers.containsKey(daId)) {
       // println("we will constrain!: ");
        Dancer pDa = (Dancer)pDancers.get(daId);

        float[] daVals = da.getAllVals();
        float[] pDaVals = pDa.getAllVals();
        float[] newVals = new float[daVals.length];
        for(int i=0; i< daVals.length;i++){
          newVals[i]= pDaVals[i] + constrain(daVals[i] - pDaVals[i], -4, 4);
        }
        pDa.setConstrainedValues(newVals);
      }
    }
  }

  int getDancersNr(){ return hm.size();}

  boolean hasDancers(){return hm.size() > 0 ;}

  boolean hasDancer(int dancerNr){
    return hm.containsKey(dancerNr);
  }

  // RANDOM DANCER
  float getRandomDancerMiddle(){
    float m = 0;
    if(hasDancers()){
      dancers.ids.shuffle();
      int randomId = dancers.ids.get(0);
      m = dancers.hm.get(randomId).getMiddle();
    }
    return m;
  }

  PVector getRandomDancerMiddleAndTop(){
    PVector p = new PVector(0,0);
    if(hasDancers()){
      dancers.ids.shuffle();
      int randomId = dancers.ids.get(0);
      float px = dancers.hm.get(randomId).getMiddle();
      float py = dancers.hm.get(randomId).getTop();
      p.set(px,py);
    }
    return p;
  }

  // ALL DANCERS
  FloatList getAllMiddles(){
    FloatList middles = new FloatList();
    for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {
      Dancer da = idancer.getValue();
      middles.append(da.getMiddle());
    }
    return middles;
  }

  ArrayList<PVector> getAllRightAndLeft(){
    ArrayList<PVector> positionsRL = new ArrayList<PVector>();
    for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {
      Dancer da = idancer.getValue();
      positionsRL.add(da.getRight());
      positionsRL.add(da.getLeft());
    }
    return positionsRL;
  }

  // CONCRETE DANCER dancerNr
  float getDancerMiddle(int dancerNr){
    Dancer d = getDancer(dancerNr);
    return d.getMiddle();
  }

  PVector getDancerMiddleAndTop(int dancerNr){
    Dancer d = getDancer(dancerNr);
    PVector mt = new PVector(d.getMiddle(), d.getTop());
    return mt;
  }


  // FIRST DANCER
  float getFirstDancerMiddle(){
    float m = 0;
    if(hasDancers()){
      int firstId = dancers.ids.get(0);
      m = dancers.hm.get(firstId).getMiddle();
    }
    return m;
  }

  PVector getFirstDancerMiddleAndTop(){
    PVector p = new PVector(0,0);
    if(hasDancers()){
      int firstId = dancers.ids.get(0);
      p.x = dancers.hm.get(firstId).getMiddle();
      p.y = dancers.hm.get(firstId).getTop();
    }
    return p;
  }

  PVector getFirstDancerMiddleXY(){
    PVector p = new PVector(0,0);
    if(hasDancers()){
      int firstId = dancers.ids.get(0);
      p = dancers.hm.get(firstId).getMiddleXY();
    }
    return p;
  }

  PVector getFirstDancerRight(){
    PVector p = new PVector(0,0);
    if(hasDancers()){
      int firstId = dancers.ids.get(0);
      p = dancers.hm.get(firstId).pos_right;
    }
    return p;
  }    

  PVector getFirstDancerLeft(){
    PVector p = new PVector(0,0);
    if(hasDancers()){
      int firstId = dancers.ids.get(0);
      p = dancers.hm.get(firstId).pos_left;
    }
    return p;
  }   

  float getFirstDancerTop(){
    float p =0;
    if(hasDancers()){
      int firstId = dancers.ids.get(0);
      p = dancers.hm.get(firstId).top;
    }
    return p;
  }   

  float getFirstDancerDepth(){
    float d = 0;
    if(hasDancers()){
      int firstId = dancers.ids.get(0);
      d = dancers.hm.get(firstId).getDepth();
    }
    return d;
  } 

  void getDancers(){
    cleanHm();
    context.update();
    int[]   userMap = context.userMap();
    int[]   depthMap = context.depthMap();

    int steps = 1;
    int index;

    for(int x=0;x <context.depthWidth();x+=steps)
    {
      for(int y=0;y < context.depthHeight() ;y+=steps)
      {
        index = x + y * context.depthWidth();
        int d = depthMap[index];
        if(d>0){
          int userNr =userMap[index];
          if( userNr > 0)
          { 
            updateDancer(userNr,x,y,d);
          }
        }
      }
    }
    rescale();
  }

  void getDancersAndAlternatives(){
    cleanHm();
    context.update();
    int[]   userMap = context.userMap();
    int[]   depthMap = context.depthMap();
    int [] alternatives = new int[context.depthWidth()];
    int [] alterDepths  = new int[context.depthWidth()];

    int steps = 1;
    int index;

    boolean hasAlternatives = false;

    for(int x=0;x <context.depthWidth();x+=steps)
    {
      // initialize this field with 0
      alternatives[x] = 0;
      alterDepths[x] = 8000;
      for(int y=0;y < context.depthHeight() ;y+=steps)
      {
        index = x + y * context.depthWidth();
        int d = depthMap[index];
        if(d>0){
          int userNr =userMap[index];
          if( userNr > 0)
          { 
            updateDancer(userNr,x,y,d);
          }
          // alternative
          if((d<3680) && (y < 570)){
            hasAlternatives =true;
            alternatives[x]+=1;
            if (d < alterDepths[x]) alterDepths[x] = d;
          }
        }
      }
    }
    if(!hasDancers()){
      // we use alternatives
      if(hasAlternatives) getDancersFromAlternatives(alternatives, alterDepths);
    }
    rescale();
  }


}


/*

void drawLine(){
  // stroke(0,255,0);
  // strokeWeight(1);
  // for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {
  //   Dancer da = idancer.getValue();
  //   float middle_x = da.getMiddle();
  //   line(middle_x,0,middle_x,height);
  //   ellipse(middle_x, da.top,10,10);
  // }
}

void drawRightLine(){
  stroke(0,255,0);
  PVector pos = dancers.getFirstDancerRight();
  line(pos.x,0,pos.x,height);
  ellipse(pos.x, pos.y,10,10);  
}

void drawRightPoint(){
  stroke(0,255,0);
  fill(255,255,0);
  PVector pos = dancers.getFirstDancerRight();
  ellipse(pos.x, pos.y,10,10);  
}

void drawFDMiddleAndTopPoint(){
  stroke(0,255,0);
  fill(255,255,0);
  PVector pos = dancers.getFirstDancerMiddleAndTop();
  ellipse(pos.x, pos.y,10,10);  
}

*/