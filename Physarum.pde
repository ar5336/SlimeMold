float[][] trail;
ArrayList<Mold> slime = new ArrayList();
float SENSE_DIST = 10;

float BORDER = SENSE_DIST*2;

void setup(){
  size(500,500);
  trail = new float[height][width];
  placeStart();
  renderTrail();
  
  for(int i = 0; i < 1000; i++){
    slime.add(new Mold(random(2*PI),random(BORDER,width-BORDER), random(BORDER, height-BORDER)));
  }
}

void draw(){
  trail = getUpdatedTrail();
  for(Mold mold : slime){
    mold.makeMove();
  }
  renderTrail();
}
