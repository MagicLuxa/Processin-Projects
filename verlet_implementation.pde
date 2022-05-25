Solver solver;
ArrayList<Verlet> objects;
ArrayList<Link> links;
float dt;
int n = 0;
int count = 0;

void setup(){
  // fullScreen();
  size(900, 900);
  frameRate(60);
  dt = 1.0/60;
  
  objects = new ArrayList();
  links = new ArrayList();
  
  
  // spawn a chain
  int chainLength = 35;
  float spacing = 7;
  for (int i = 0; i < chainLength; i++){
    if (i == 0 || i == chainLength-1){
      objects.add(new Verlet(new PVector(width/2+spacing*2*i-chainLength*spacing, height-200), new PVector(0, 0), 5, true));
    }
    else{
      objects.add(new Verlet(new PVector(width/2+spacing*2*i-chainLength*spacing, height-200), new PVector(0, 0), 5, false));
    }
  }
  
  // add joints for the chain
  for (int i = 0; i < chainLength-1; i++){
    links.add(new Link(objects.get(i), objects.get(i+1), spacing));
  }
  
  // spawn a cube
  int lastIdx = objects.size()-1;
  float l = 100;
  // x, y are the coordinates of the top left corner
  float x = width/2-0.5*l;
  float y = 100;
  objects.add(new Verlet(new PVector(x, y), new PVector(0, 0), 8, false));
  objects.add(new Verlet(new PVector(x+l, y), new PVector(0, 0), 8, false));
  objects.add(new Verlet(new PVector(x, y+l), new PVector(0, 0), 8, false));
  objects.add(new Verlet(new PVector(x+l, y+l), new PVector(0, 0), 8, false));
  
  links.add(new Link(objects.get(lastIdx+1), objects.get(lastIdx+2), l));
  links.add(new Link(objects.get(lastIdx+1), objects.get(lastIdx+3), l));
  links.add(new Link(objects.get(lastIdx+2), objects.get(lastIdx+4), l));
  links.add(new Link(objects.get(lastIdx+3), objects.get(lastIdx+4), l));
  // changing sqrt(2) to e.g. 1 turns cube to paralelogramm
  links.add(new Link(objects.get(lastIdx+1), objects.get(lastIdx+4), sqrt(2)*l));
  
  solver = new Solver(objects, links);
}

void draw(){
  background(255);
  
  int substeps = 1;
  dt = 1/frameRate;
  for (int i = 0; i < substeps; i++){
    solver.update(dt/substeps);
  }
  solver.show();
  
  PFont f = createFont("Arial",16,true);
  textFont(f,16);
  text(str(round(frameRate)), 10, 20);
  text(str(solver.objects.size()), width-40, 20);
}

void mousePressed(){
  Verlet obj = new Verlet(new PVector(mouseX, mouseY), new PVector(0, 2), 8, false);
  objects.add(obj);
}

void spawn(int n){
  PVector spawn = new PVector(width/2, 200);
  
  if (n < 4000){
    int speed = 50;
    float angle = map(n%speed, 0, speed, PI/5, 4*PI/5);
    PVector vel;
    vel = getVectorFromAngle(angle, 2).copy();
    Verlet obj = new Verlet(spawn, vel, 5, false);
    solver.addObject(obj);
    n++;
  }
  
}

PVector getVectorFromAngle(float angle, float len){
  float x = cos(angle);
  float y = sin(angle);
  PVector v = new PVector(x, y);
  
  v.mult(len);
  return v;
}
