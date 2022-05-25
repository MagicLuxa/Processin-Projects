class Solver{
  
  ArrayList<Verlet> objects; 
  ArrayList<Link> links; 
  PVector g = new PVector(0, 200);
  
  Solver(ArrayList<Verlet> objs, ArrayList<Link> lks){
    objects = objs;
    links = lks;
  }
  
  void update(float dt){
    applyGravity();
    applyConstraint();
    solveCollisions();
    updatePosition(dt);
  }
  
  void updatePosition(float dt){
    for (Verlet obj : objects) {
      obj.updatePosition(dt);
    }
    
    for (Link l : links) {
      l.apply();
    }
  }
  
  void applyGravity(){
    for (Verlet obj : objects) {
      obj.accelerate(g);
    }
  }
  
  void applyConstraint(){
    for (Verlet obj : objects){
      if (obj.currentPosition.x < obj.radius){
        float toCorrect = obj.currentPosition.x - obj.radius;
        PVector dir = new PVector(1, 0);
        dir.mult(toCorrect);
        //obj.currentPosition = obj.currentPosition.copy().add(dir);
        obj.currentPosition.x = obj.radius;
      }
      else if (obj.currentPosition.x > width-obj.radius){
        float toCorrect = width-obj.radius-obj.currentPosition.x;
        PVector dir = new PVector(-1, 0);
        dir.mult(toCorrect);
        // obj.currentPosition = obj.currentPosition.copy().add(dir);
        obj.currentPosition.x = width-obj.radius;
      }
      
      if (obj.currentPosition.y < obj.radius){
        float toCorrect = obj.currentPosition.y - obj.radius;
        PVector dir = new PVector(0, 1);
        dir.mult(toCorrect);
        // obj.currentPosition = obj.currentPosition.copy().add(dir);
        obj.currentPosition.y = obj.radius;
      }
      else if (obj.currentPosition.y > height-obj.radius){ 
        float toCorrect = height-obj.radius-obj.currentPosition.y;
        PVector dir = new PVector(0, -1);
        dir.mult(toCorrect);
        // obj.currentPosition = obj.currentPosition.copy().add(dir);
        obj.currentPosition.y = height-obj.radius;
      }
    }
  }
  
  void applyConstraintCircle(){
    PVector center = new PVector(width/2, height/2);
    float radius = 400;
    
    for (Verlet obj : objects) {
      PVector toObj = obj.currentPosition.copy().sub(center);
      float dist = toObj.mag();
      
      if (dist > radius - obj.radius && dist < radius + obj.radius){
        toObj.normalize();
        float n = radius - obj.radius;
        obj.currentPosition = center.copy().add(toObj.copy().mult(n));
      }
    }
    noFill();
    stroke(0);
    circle(center.x, center.y, 2*radius);
  }
  
  void solveCollisions(){
    int amount = objects.size();
    
    for (int idx1 = 0; idx1 < amount; idx1++){
      for (int idx2 = idx1+1; idx2 < amount; idx2++){
        Verlet obj1 = objects.get(idx1);
        Verlet obj2 = objects.get(idx2);
        
        PVector collisionAxis = obj1.currentPosition.copy().sub(obj2.currentPosition);
        float dist = collisionAxis.mag();
        float minDist = obj1.radius + obj2.radius;
        collisionAxis.normalize();
        float delta = (minDist - dist) / 2;
        
        if (dist <= minDist){
          obj1.currentPosition = obj1.currentPosition.copy().add(collisionAxis.copy().mult(delta));
          obj2.currentPosition = obj2.currentPosition.copy().sub(collisionAxis.copy().mult(delta));
        }
      }
    }
  }
  
  void addObject(Verlet obj){
    objects.add(obj);
  }
  
  void show(){
    noStroke();
    fill(0);
    for (Verlet obj : objects) {
      PVector pos = obj.currentPosition;
      circle(pos.x, pos.y, 2*obj.radius);
    }
    
    for (Link l : links) {
      l.show();
    }
  }    
  
}
