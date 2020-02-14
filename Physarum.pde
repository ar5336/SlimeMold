float[][] trail;
ArrayList<Mold> slime = new ArrayList();

//VARIABLES TO FIDDLE WITH

//mold properties
float       SENSE_DIST     = 25;
float       TRAVEL_DIST    = 3;
static int  BLUR_RAD       = 1;
boolean     LINE_DOT       = false;
float       TARGET_TRAIL   = .1;
int         NUM_SENSORS    = 3;
float       SENSOR_SPAN    = PI/6;

//trail properties
float       TRAIL_DENSITY = .05;
float       TRAIL_DECAY   = .8;
float       TRAIL_SWEEP   = 0;
float       TRAIL_MAX     = 5;

//spawning the molds
float       LAND_COVERED  = 1;
boolean     RANDOM_UNIFORM= false;


float BORDER = 0;
void setup(){
  size(500,500);
  trail = new float[height][width];
  placeStart();
  renderTrail();
  
  if(RANDOM_UNIFORM){
    for(int i = 0; i < (width*height)*LAND_COVERED; i++){
      slime.add(new Mold(random(2*PI),random(BORDER,width-BORDER), random(BORDER, height-BORDER)));
    }
  } else {
    for(int x = 0; x < width; x++){
      for(int y = 0; y < height; y++){
        if(random(1) < LAND_COVERED){
          slime.add(new Mold(random(2*PI),x,y));
        }
      }
    }
  }
}

void draw(){
  
  for(Mold mold : slime){
    mold.makeMove();
  }
  trail = getUpdatedTrail();
  renderTrail();
  //saveFrame("output/smoke/smoke-######.png");
}
