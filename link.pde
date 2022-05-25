class Link{
  Verlet obj1;
  Verlet obj2;
  float targetDist;
  
  Link(Verlet object1, Verlet object2, float dist){
    obj1 = object1;
    obj2 = object2;
    targetDist = dist;
  }
  
  void apply(){
    PVector pos1 = obj1.currentPosition;
    PVector pos2 = obj2.currentPosition;
    
    PVector link = pos1.copy().sub(pos2);
    float dist = link.mag();
    float delta = (targetDist - dist) / 2;
    link.normalize();
    link.mult(delta);
    
    obj1.currentPosition = pos1.copy().add(link.copy());
    obj2.currentPosition = pos2.copy().sub(link.copy());
  }
  
  void show(){
    stroke(0);
    PVector pos1 = obj1.currentPosition;
    PVector pos2 = obj2.currentPosition;
    line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  
}
