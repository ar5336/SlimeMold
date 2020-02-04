class Mold{
  float heading;
  float x;
  float y;
  
  int numSensors = 3;
  float sensorSpan = PI/3;
  float sensorDistance = SENSE_DIST;
  
  Mold(float heading, float x, float y){
    this.heading = heading;
    this.x = x;
    this.y = y;
  }
  
  float sense(int num){ //senses at sensor num
    
    float sensorAngle = heading-sensorSpan+(((float)num/(float)numSensors)*(sensorSpan*2));
    float sensorX = x+cos(sensorAngle)*sensorDistance;
    float sensorY = y-sin(sensorAngle)*sensorDistance;
    
    //if((int)sensorX >= width || sensorX < 0){
    //  //flip heading horizontally
    //  heading = heading+2*(PI/2-heading);
    //}
    //if((int)sensorY >= height || sensorY < 0){
    //  //flip heading vertically
    //  heading = -heading;
    //}
    
    return trail[max(min((int)sensorX,width-1),0)][max(min((int)sensorY,height-1),0)];
  }
  
  void flipHor(){
    heading = PI-heading;
  }
  
  void flipVer(){
    heading = heading * -1;
  }
  
  void makeMove(){
    
    if(x > (width - BORDER) && cos(heading) > 0){
      flipHor();
      return;
    }
    if(x < BORDER && cos(heading) < 0){
      flipHor();
      return;
    }
    if(y > (height - BORDER) && sin(heading) < 0){
      flipVer();
      return;
    }
    if(y < BORDER && sin(heading) > 0){
      flipVer();
      return;
    }
    
    float[] sensorVals = new float[numSensors];
    float currentMax = -1;
    //find the most dense sensor(s)
    for(int i = 0; i < numSensors; i++){
      float datum = sense(i);
      sensorVals[i] = datum;
      if(datum > currentMax){
        currentMax = datum;
      }
    }
    boolean[] isMax = new boolean[numSensors];
    int numMaxes = 0;
    for(int i = 0; i < numSensors; i++){
      if(sensorVals[i] == currentMax){
        isMax[i] = true;
        numMaxes++;
      }
    }
    
    //moveToSensor(0);
    
    //choose randomly from densest sensors and move there
    int chosenSensor = (int)random(0,numMaxes);
    //print(chosenSensor);
    for(int i = 0; i < numSensors; i++){
      if(chosenSensor == 0 && isMax[i]){
        moveToSensor(i);
        break;
      } else if(isMax[i]){
        chosenSensor--;
      }
    }
  }
  
  void moveToSensor(int num){
    //println(num);
    float sensorAngle = -sensorSpan+(((float)num/(float)numSensors)*(sensorSpan*2));
    float dX = cos(heading+sensorAngle)*sensorDistance;
    float dY = -sin(heading+sensorAngle)*sensorDistance;
    float sensorX = x+dX;
    float sensorY = y+dY;
    
    //deposit line of trail
    for(int i = 0; i < sensorDistance; i++){
      int lineX = (int)((float)dX*((float)i)/sensorDistance);
      int lineY = (int)((float)dY*((float)i)/sensorDistance);
      
      trail[max(min((int)x+lineX,width-1),0)][max(min((int)y+lineY,height-1),0)] += 1.5;
    }
    
    this.x = sensorX;
    this.y = sensorY;
    this.heading += sensorAngle;
  }
}

float[][] getUpdatedTrail(){
  float[][] newTrail = new float[width][height];
  //disperse "every" square
  int BLUR_RAD = 1;
  for(int r = BLUR_RAD; r < width-BLUR_RAD; r++){
    for(int c = BLUR_RAD; c < height-BLUR_RAD; c++){
      disperseSquare(newTrail,r,c,BLUR_RAD);
    }
  }
  //decay every square by a bit
  for(int r = 0; r < width; r++){
    for(int c = 0; c < height; c++){
      decaySquare(newTrail,r,c);
    }
  }
  return newTrail;
}

void disperseSquare(float[][] newTrail, int ir, int ic, int BLUR_RAD){
  if(trail[ir][ic] != 0){
    int num_cells = (int)pow(1+BLUR_RAD*2,2);
    float valpos = trail[ir][ic]/num_cells;
    for(int r = -BLUR_RAD; r <= BLUR_RAD; r++){
      for(int c = -BLUR_RAD; c <= BLUR_RAD; c++){
        newTrail[ir+r][ic+c] += valpos;
      }
    }
  }
}

void decaySquare(float[][] newTrail, int r, int c){
  newTrail[r][c] *= .8;
}
