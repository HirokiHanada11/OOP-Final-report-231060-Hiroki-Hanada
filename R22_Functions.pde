void drawGrid(){
  for(int i = 0; i < DIM; i++){
    for(int j = 0; j < DIM; j++){
      Grid[i][j].display();
    }
  }
}

void initGrid(){
  for(int i = 0; i < DIM; i++){
    for(int j = 0; j < DIM; j++){
      if(i == 0 || j == 0 || i == DIM - 1 || j == DIM - 1){
        Grid[i][j] = new Wall(i, j);
        Grid[i][j].display();
      } else if(i == 1 && j == 1){
        Grid[i][j] = new CheckPoint('s', i, j);
        Grid[i][j].display();
        PathsList = (ListEntry[])append(PathsList, new ListEntry(i, j, 0));
      }else if (i == DIM - 2 && j == DIM - 2){
        Grid[i][j] = new CheckPoint('g', i, j);
        Grid[i][j].display();
      } else {
        Grid[i][j] = new Path(i, j);
        Grid[i][j].display();
      }
    }
  }
}

// turns a path at the mouse position into a wall
void makeWall(int mx, int my){
  if(mx < 0 || mx > DIM*CELLSIZE || my < 0 || my > DIM*CELLSIZE){
    return;
  } else {
    int i = floor(mx / CELLSIZE);
    int j = floor(my / CELLSIZE);
    if(Grid[i][j].type == 'p'){
      Grid[i][j] = new Wall(i, j);
    }
  }
}

// pathfinding algorithm function called every tick
void pathFind(int iter) throws RuntimeException {
  int initPathsListLength = PathsList.length;
  for(int i = 0; i < PathsList.length; i++){
    if(PathsList[i].iter == iter){
      Grid[PathsList[i].x][PathsList[i].y].lastVisited = true;
      Grid[PathsList[i].x][PathsList[i].y].visited = false; 
      if(updatePerimeter(PathsList[i])){
        return;
      }
    }else if(PathsList[i].iter == iter - 1){
      Grid[PathsList[i].x][PathsList[i].y].lastVisited = false;
      Grid[PathsList[i].x][PathsList[i].y].visited = true;
    }
  }
  process.inc();
  if(PathsList.length == initPathsListLength){
    throw new ClosedPathException();
  } else if(process.iter > MAXITER){
    throw new MaxIterException();
  }
}

// check and update the 4 surrounding cells
Boolean updatePerimeter(ListEntry c){
  Boolean found = false;
  if(checkCell(c.x, c.y - 1, c.iter)){
    println("path found at iter ", c.iter+1);
    found = true;
  } else if(checkCell(c.x, c.y + 1, c.iter)){
    println("path found at iter ", c.iter+1);
    found = true;
  } else if(checkCell(c.x - 1, c.y, c.iter)){
    println("path found at iter ", c.iter+1);
    found = true;
  } else if(checkCell(c.x + 1, c.y, c.iter)){
    println("path found at iter ", c.iter+1);
    found = true;
  }
  return found;
}

// checks the type of the cell
Boolean checkCell(int i, int j, int iter){
  Boolean found = false;
  if(Grid[i][j].type == 'w'){
    println(i,j,"wall");
  } else if(Grid[i][j].type == 'p' && checkUnique(i,j)){
    Grid[i][j].iter = iter + 1;
    PathsList = (ListEntry[])append(PathsList, new ListEntry(i, j, iter+1));
    println(i,j,"new path");
  } else if(Grid[i][j].type == 'g'){
    OptimumPathsList = (ListEntry[])append(OptimumPathsList, new ListEntry(i, j, iter+1));
    found = true;
    process.found();
  }
  return found;
}

// checks if the new path is not already in the PathsList
Boolean checkUnique(int i, int j){
  Boolean isUnique = true;
  for(int k = 0; k < PathsList.length; k++){
    if(PathsList[k].CheckUnique(i,j)){
      isUnique = false;
      break;
    }
  } 
  return isUnique;
}

// solving the shortest path after the goal is found
void solvePath(){
  ListEntry LastOptimum = OptimumPathsList[OptimumPathsList.length - 1];
  for(int k = PathsList.length - 1; k >= 0; k--){
    if(PathsList[k].iter == LastOptimum.iter - 1){
      if(checkAdjacent(PathsList[k], LastOptimum)){
        if(PathsList[k].iter == 1){
          process.solved();
        }
        OptimumPathsList = (ListEntry[])append(OptimumPathsList, PathsList[k]);
        Grid[PathsList[k].x][PathsList[k].y] = new ShortestPath('o', PathsList[k].x, PathsList[k].y);
        return;
      }
    }
  } 
}

// checks if the cell in the path list is adjacent to the shortest path entry
Boolean checkAdjacent(ListEntry pl, ListEntry opl){
  Boolean isAdjacent = false;
  if(
    pl.x == opl.x && pl.y == opl.y - 1 ||
    pl.x == opl.x && pl.y == opl.y + 1 ||
    pl.x == opl.x + 1 && pl.y == opl.y ||
    pl.x == opl.x - 1 && pl.y == opl.y
    ){
      isAdjacent = true;
    }
  return isAdjacent;
} 
