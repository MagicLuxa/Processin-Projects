class Verlet{
  PVector currentPosition;
  PVector oldPosition;
  PVector acceleration;
  float radius;
  boolean fixed;
  PVector spawn;
  
  Verlet(PVector pos, PVector vel, float r, boolean fix){
    currentPosition = pos.copy();
    spawn = pos.copy();
    oldPosition = pos.copy().sub(vel);
    acceleration = new PVector(0, 0);
    radius = r;
    fixed = fix;
  }
  
  void updatePosition(float dt){
    if (fixed == false){
      PVector vel = currentPosition.copy().sub(oldPosition);
      oldPosition = currentPosition.copy();
      currentPosition = currentPosition.copy().add(vel.copy().add(this.acceleration.copy().mult(dt * dt)));
      acceleration = new PVector(0, 0);
    }
    else{
      currentPosition = spawn.copy();
    }
  }
  
  void accelerate(PVector acc){
    acceleration.add(acc);
  }
  
}
