void renderTrail(){
  for(int r = 0; r < trail.length; r++){
    for(int c = 0; c < trail.length; c++){
      stroke(color(trail[r][c]*100));
      point(r,c);
    }
  }
}
