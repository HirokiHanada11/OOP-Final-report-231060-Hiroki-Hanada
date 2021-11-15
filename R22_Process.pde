int DIM = 16; // A constant to define the grid dimension
int CELLSIZE = 50; // A constant to define the size of each cell
int MAXITER = DIM*DIM;
ListEntry[] PathsList = new ListEntry[0];
ListEntry[] OptimumPathsList = new ListEntry[0];
Cell[][] Grid = new Cell[DIM][DIM];
Process process = new Process();

void settings(){
  size(DIM*CELLSIZE,DIM*CELLSIZE);

}

void setup(){
  frameRate(2);
  //generate grid
  initGrid();
}

void draw(){
  drawGrid();
  if(!process.addingWall && !process.pathFound){
    println("pathfinding", process.iter);
    try {
      pathFind(process.iter);
    } catch (MaxIterException e){
      println(e);
      process.reset();
    } catch (ClosedPathException e){
      println(e);
      process.reset();
    }
  } else if(process.pathFound && !process.pathSolved){
    println("Solving optimum path");
    solvePath();
  } 
}

// adds wall type cell on mouse click and drug
void mouseDragged(){
  if(process.addingWall){
    makeWall(mouseX, mouseY);
  }
}

// initiates pathfinding with the walls currently set
void keyPressed(){
  if(key == 's'){
    process.initPathfinding();
  } else if(key == 'q'){
    process.reset();
    initGrid();
  } else {
    return;
  }
}
