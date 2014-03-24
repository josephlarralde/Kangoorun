/*
  This file is part of Kangoorun
  a processing game inspired by Flappy Bird
  created in march 2014 by the french BioBx team (c) :
  code : Joseph Larralde
  hardware interaction : Sophie Itey
  graphicly designed by students from Digital Campus school (Bordeaux)
  >>> Fabien Cangini, Tess Sinamal, Nicolas Andre, Joffrey Gentreau, Camille Laine, Chloe Delsol, Mayssa Mendjeli
  
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.  
*/

public class Obstacle {
  PVector pos;
  //PVector ground;
  PShape shp;
  float size;
  PVector[] bbox;
  
  Obstacle(PShape ps, float y, float s) { // y : ground line

    shp = ps;
    size = s;

    pos = new PVector(width + 100, y);
    bbox = new PVector[2];
    bbox[0] = new PVector(pos.x + shp.width*size/2 - shp.width*size/4,
                          pos.y - shp.height*size);
    bbox[1] = new PVector(shp.width*size*2/4,
                          shp.height*size);
  }
  
  void update(float speed) {
    pos.x -= speed;
    bbox[0].x -= speed;
  }
  
  void display() {
    // UNCOMMENT TO SHOW COLLISION BOX :
    //rect(bbox[0].x, bbox[0].y, bbox[1].x, bbox[1].y);
    
    noFill();
    fill(255);
    shape(shp, pos.x, pos.y - shp.height*size,
          shp.width*size, shp.height*size);
    fill(255);
  }
}

