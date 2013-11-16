// Nov 2013
// http://jiyu-kenkyu.org
// http://kow-luck.com
//
// This work is licensed under a Creative Commons 3.0 License.
// (Attribution - NonCommerical - ShareAlike)
// http://creativecommons.org/licenses/by-nc-sa/3.0/
// 
// This basically means, you are free to use it as long as you:
// 1. give http://kow-luck.com a credit
// 2. don't use it for commercial gain
// 3. share anything you create with it in the same way I have
//
// If you want to use this work as free, or encourage me,
// please contact me via http://kow-luck.com/contact

//========================================
import processing.opengl.*;

int CellNumX = 6;
int CellNumY = 6;
int CellNumZ = 6;

Cell[][][] cells = new Cell[CellNumX][CellNumY][CellNumZ];

float CellSize = 300;
float margin = CellSize/4;
float step = CellSize + margin;
float xPos, yPos, zPos;

float xStart = -step * CellNumX/2; 
float yStart = -step * CellNumY/2;
float zStart = -step * CellNumZ/2;

float rotEyeX, rotEyeY, rotEyeZ;

//========================================
void setup() {
  size(1280, 720, OPENGL);
  frameRate(60);
  colorMode(RGB, 255);
  for (int x = 0; x < CellNumX; x ++) {
    for (int y = 0; y < CellNumY; y ++) {
      for (int z = 0; z < CellNumZ; z ++) {
        xPos = xStart + step*x;
        yPos = yStart + step*y;
        zPos = zStart + step*z;

        cells[x][y][z] = new Cell(xPos, yPos, zPos, CellSize);
      }
    }
  }
  rotEyeX = 0;
  rotEyeY = 0;
  rotEyeZ = 0;
}
//========================================
void draw() {
  background(255);
  ambientLight(200, 205, 205);
  directionalLight(255, 255, 255, 1, 1, -1);
  translate(width/2, height/2, -width/2);
  eyeRotation();
  drawMe();
  println(frameRate);
}
//========================================
void drawMe() {
  for (int x = 0; x < CellNumX; x ++) {
    xPos +=step;
    for (int y = 0; y < CellNumY; y ++) {
      yPos += step;
      for (int z = 0; z < CellNumZ; z ++) {
        zPos += step;
        cells[x][y][z].display();
      }
    }
  }
}
//========================================
void eyeRotation() {
  rotateX(radians(rotEyeX) + radians(mouseY/2));
  rotateY(radians(rotEyeX) + radians(mouseX/2));
  rotateZ(radians(rotEyeX));
  rotEyeX += 0.2;
  rotEyeY += 0.1;
  rotEyeZ += 0.3;
  if (radians(rotEyeX) + radians(mouseY) > 360) {
    rotEyeX = 0;
  }
  if (radians(rotEyeY) + radians(mouseY) > 360) {
    rotEyeY = 0;
  }
  if (radians(rotEyeZ) > 360) {
    rotEyeZ = 0;
  }
}
//========================================
public class Cell {

  int seedsNUM = 15;
  float[] seedRotX = new float[seedsNUM];
  float[] seedRotY = new float[seedsNUM];
  float[] seedRotZ = new float[seedsNUM];
  int angle;
  float cellSize, seedRadius, seedW, seedH;

  float displayX, displayY, displayZ;  

  Cell(float _displayX, float _displayY, float _displayZ, float _cellSize) {
    displayX = _displayX;
    displayY = _displayY;
    displayZ = _displayZ;
    cellSize = _cellSize;

    for (int i = 0; i < seedsNUM; i++) {
      seedRotX[i] = random(0, 360);
      seedRotY[i] = random(0, 360);
      seedRotZ[i] = random(0, 360);
    }
    angle= 0;
    seedRadius = cellSize/2.5;
    seedW = cellSize/8;
    seedH = cellSize/30;
  }

  //========================================
  public void display() {
    pushMatrix();
    translate(displayX, displayY, displayZ);

    this.drawSeeds();
    this.drawBoxCore();

    popMatrix();
  }
  //========================================
  private void drawSeeds() {

    float x = sin(radians(angle))*(seedRadius);
    float y = cos(radians(angle))*(seedRadius);

    for (int i = 0; i < seedsNUM; i++) { 
      pushMatrix(); 
      rotateX(seedRotX[i]);
      rotateY(seedRotY[i]);
      rotateZ(seedRotZ[i]);

      translate(x, y, 0);
      ellipseMode(CENTER);
      fill(random(255), random(255), random(255), 150);
      ellipse(0, 0, seedW, seedH);
      popMatrix();
    }
    angle += 8;
    if (angle > 360) {
      angle = 0;
    }
  }
  //========================================
  private void drawBoxCore() {
    pushMatrix();
    noStroke();
    //pushMatrix();
    fill(200);
    sphereDetail(4);
    sphere(cellSize/4);
    //rotateX(radians(45));
    //rotateY(radians(45));
    //box(cellSize/2);
    //popMatrix();

    noStroke();
    fill(100, 20);
    box(cellSize);

    popMatrix();
  }
}

