// abstract class for cell object
abstract class Cell {
  int x;
  int y;
  int iter;
  Boolean visited;
  Boolean lastVisited;
  char type; // p: path. w: wall, s: start, g: goal, o: shortest path
  
  //abstract method for drawing each cells
  abstract void display();
}

// Cell inheritant with wall properties
class Wall extends Cell {
  Wall(int ix, int iy){
    x = ix;
    y = iy;
    type = 'w';
  }
  void display(){
    fill(128);
    square(x*CELLSIZE, y*CELLSIZE, CELLSIZE);
  }
}

// Cell inheritant with Path properties
class Path extends Cell {
  int iter = 0;
  Path(int ix, int iy){
    x = ix;
    y = iy;
    visited = false;
    lastVisited = false;
    type = 'p';
  }
  void display(){
    if(visited){
      fill(173, 216, 230);
    } else if (lastVisited){
      fill(253, 253, 150);
    } else {
      fill(255);
    }
    square(x*CELLSIZE, y*CELLSIZE, CELLSIZE);
  }
}

// class for checkpoints
class CheckPoint extends Cell {
  int iter = 0;
  CheckPoint(char itype, int ix, int iy){
    x = ix;
    y = iy;
    type = itype;
  }
  
  void display(){
    fill(173,255,47);
    square(x*CELLSIZE, y*CELLSIZE, CELLSIZE);
  }
}

// class for drawing the shortest path found
class ShortestPath extends Cell {
  int iter = 0;
  ShortestPath(char itype, int ix, int iy){
    x = ix;
    y = iy;
    type = itype;
  }
  
  void display(){
    fill(255,192,203);
    square(x*CELLSIZE, y*CELLSIZE, CELLSIZE);
  }
}

// class for indicating the process state
class Process {
  int iter;
  Boolean pathFound;
  Boolean addingWall;
  Boolean pathSolved;
  
  Process(){
    iter = 0;
    pathFound = false;
    addingWall = true;
    pathSolved = false;
  }
  
  void initPathfinding(){
    addingWall = false;
  }
  
  //used to increment iter when searching
  void inc(){
    iter++;
  }
  
  //used to decrement iter when solving
  void dec(){
    iter++;
  }
  
  void found(){
    pathFound = true;
  }
  
  void solved(){
    pathSolved = true;
  }
  
  void reset(){
    iter = 0;
    pathFound = false;
    addingWall = true;
  }
}

// object for keeping track of the path cells traveled
class ListEntry {
  int x;
  int y;
  int iter;
  
  ListEntry(int ix, int iy, int iiter){
    x = ix;
    y = iy;
    iter = iiter;
  }
  
  Boolean CheckUnique(int i, int j){
    return x == i && y == j;
  }
  
}

// class for exception when the program reaches max iter without reaching the goal
class MaxIterException extends RuntimeException {
  MaxIterException(){
    super("Max iteration has been reached and route was not found");
  }
}

// class for exception when the program reaches max iter without reaching the goal
class ClosedPathException extends RuntimeException {
  ClosedPathException(){
    super("No new path has been found, the route does not exit.");
  }
}
