
// RIGHT
PVector getMostRight(){
  context.update();
  int[]   userMap = context.userMap();
  int steps = 1;
  int index;
 float  maxRight_x = 0;
 float maxRight_y = 0;

  boolean gotOne =false;
  for(int x=(context.depthWidth()-1);x > 0 && !gotOne;x-=steps)
    {
    for(int y=0;y < context.depthHeight() && !gotOne;y+=steps)
    {
      index = x + y * context.depthWidth();

      if(userMap[index] > 0)
      { 
        maxRight_x = map_just_x(x);
        maxRight_y = map_y(y);

        gotOne = true;
      }
    }
  }
  PVector mostRight = new PVector(maxRight_x,maxRight_y);
  return mostRight;
}


PImage getBigImage(){
  PImage img = new PImage(context.depthWidth(),context.depthHeight()); 
  img.loadPixels();
  PImage bigImg = new PImage(width,height); 
  bigImg.loadPixels();
  context.update();

  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();

  int steps = 1;
  int index;


  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      img.pixels[index] = color(255);
      int d = depthMap[index];
      if( d > 0){
        if(userMap[index]>0){
          float r = map(x, 0, width, 0, 255);
          float b = map(y, 0, height, 0, 255);
          img.pixels[index] = color(r,0,b);
        }
      } 
    }
  } 
  img.updatePixels(); 

  bigImg.copy(img, 0, 0, 640, 480, 0, 0, width, height);
  return bigImg;

}

void trackingSkeleton(){
  context.update();
  int[] userList = context.getUsers();
  boolean allFalse = false;
  for(int i=0;i<userList.length;i++)
  {
    //if(userList.length==1){
      if(context.isTrackingSkeleton(userList[i]))
      {
        ArrayList<PVector> actualPos = setNewPositions(userList[i]);

        if(captured){
          if(frameCount%200 == 0 )println("lastPos "+dancerPos + " actualPos "+actualPos);

          lastPos = dancerPos;
          dancerPos = actualPos;

        }else{
          dancerPos = actualPos;
          lastPos = dancerPos;
          captured = true;
        }
        allFalse = true;
      } else{
        captured = false;
      }   
   // } 
  }
  if(!allFalse){
    dancerPos.clear();
    lastPos.clear();
    captured = false;
  }
}


ArrayList<PVector> setNewPositions(int userId){
  ArrayList<PVector> currentPos= new ArrayList<PVector>();
  if(captured){
    PVector leftHand=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
    PVector leftHand_Proj = new PVector(); 
    context.convertRealWorldToProjective(leftHand,leftHand_Proj);
    leftHand_Proj= rescaleXY(leftHand_Proj);
    PVector last = (PVector) lastPos.get(0);
    leftHand_Proj = new PVector(last.x + constrain(leftHand_Proj.x -last.x,-5,5), last.y + constrain(leftHand_Proj.y -last.y,-20,20));
    currentPos.add(leftHand_Proj);

    PVector rightHand=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
    PVector rightHand_Proj = new PVector(); 
    context.convertRealWorldToProjective(rightHand,rightHand_Proj);
    rightHand_Proj= rescaleXY(rightHand_Proj);
    last = (PVector) lastPos.get(1);
    rightHand_Proj = new PVector(last.x + constrain(rightHand_Proj.x -last.x,-5,5), last.y + constrain(rightHand_Proj.y -last.y,-20,20));
    
    currentPos.add(rightHand_Proj);

    // PVector head=new PVector();
    // context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, head);
    // PVector head_Proj = new PVector(); 
    // context.convertRealWorldToProjective(head,head_Proj);
    // head_Proj= rescaleXY(head_Proj);
    // last = (PVector) lastPos.get(2);
    // head_Proj = new PVector(last.x + constrain(head_Proj.x -last.x,-5,5), last.y + constrain(head_Proj.y -last.y,-20,20));
    // currentPos.add(head_Proj);

    PVector leftFoot=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, leftFoot);
    PVector leftFoot_Proj = new PVector(); 
    context.convertRealWorldToProjective(leftFoot,leftFoot_Proj);
    leftFoot_Proj= rescaleXY(leftFoot_Proj);
    last = (PVector) lastPos.get(2);
    leftFoot_Proj = new PVector(last.x + constrain(leftFoot_Proj.x -last.x,-5,5), last.y + constrain(leftFoot_Proj.y -last.y,-20,20));
    currentPos.add(leftFoot_Proj);

    PVector rightFoot=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, rightFoot);
    PVector rightFoot_Proj = new PVector(); 
    context.convertRealWorldToProjective(rightFoot,rightFoot_Proj);
    rightFoot_Proj= rescaleXY(rightFoot_Proj);
    last = (PVector) lastPos.get(3);
    rightFoot_Proj = new PVector(last.x + constrain(rightFoot_Proj.x -last.x,-5,5), last.y + constrain(rightFoot_Proj.y -last.y,-20,20));
    currentPos.add(rightFoot_Proj);
  }else{  
    PVector leftHand=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
    PVector leftHand_Proj = new PVector(); 
    context.convertRealWorldToProjective(leftHand,leftHand_Proj);
    leftHand_Proj= rescaleXY(leftHand_Proj);
    currentPos.add(leftHand_Proj);

    PVector rightHand=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
    PVector rightHand_Proj = new PVector(); 
    context.convertRealWorldToProjective(rightHand,rightHand_Proj);
    rightHand_Proj= rescaleXY(rightHand_Proj);
    currentPos.add(rightHand_Proj);

    // PVector head=new PVector();
    // context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, head);
    // PVector head_Proj = new PVector(); 
    // context.convertRealWorldToProjective(head,head_Proj);
    // head_Proj= rescaleXY(head_Proj);
    // currentPos.add(head_Proj);

    PVector leftFoot=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, leftFoot);
    PVector leftFoot_Proj = new PVector(); 
    context.convertRealWorldToProjective(leftFoot,leftFoot_Proj);
    leftFoot_Proj= rescaleXY(leftFoot_Proj);
    currentPos.add(leftFoot_Proj);

    PVector rightFoot=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, rightFoot);
    PVector rightFoot_Proj = new PVector(); 
    context.convertRealWorldToProjective(rightFoot,rightFoot_Proj);
    rightFoot_Proj= rescaleXY(rightFoot_Proj);
    currentPos.add(rightFoot_Proj);
  }

  return currentPos;
  
}

ArrayList<PVector> setHandsPositions(int userId){
  ArrayList<PVector> currentPos= new ArrayList<PVector>();
  if(captured){
    PVector leftHand=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
    PVector leftHand_Proj = new PVector(); 
    context.convertRealWorldToProjective(leftHand,leftHand_Proj);
    PVector last = (PVector) lastPos.get(0);
    leftHand_Proj = new PVector(last.x + constrain(leftHand_Proj.x -last.x,-5,5), last.y + constrain(leftHand_Proj.y -last.y,-20,20));
    currentPos.add(leftHand_Proj);

    PVector rightHand=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
    PVector rightHand_Proj = new PVector(); 
    context.convertRealWorldToProjective(rightHand,rightHand_Proj);
    last = (PVector) lastPos.get(1);
    rightHand_Proj = new PVector(last.x + constrain(rightHand_Proj.x -last.x,-5,5), last.y + constrain(rightHand_Proj.y -last.y,-20,20));
    currentPos.add(rightHand_Proj);
  }else{  
    PVector leftHand=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
    PVector leftHand_Proj = new PVector(); 
    context.convertRealWorldToProjective(leftHand,leftHand_Proj);
    currentPos.add(leftHand_Proj);

    PVector rightHand=new PVector();
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
    PVector rightHand_Proj = new PVector(); 
    context.convertRealWorldToProjective(rightHand,rightHand_Proj);
    currentPos.add(rightHand_Proj);
  }

  return currentPos;
}


void trackingHands(){
  context.update();
  int[] userList = context.getUsers();

  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      ArrayList<PVector> actualPos = setHandsPositions(userList[i]);

      if(captured){
        lastPos = dancerPos;
        dancerPos = actualPos;

      }else{
        dancerPos = actualPos;
        lastPos = dancerPos;
        captured = true;
      }
    } else{
      dancerPos.clear();
      lastPos.clear();
      captured = false;
    }   
  } 
}
// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId+ " start tracking skeleton");
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}