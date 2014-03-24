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

public class Level {

  PImage bg;
  PShape obstacle;
  float osize;
  PShape decor;
  float dsize;
    
  int omincnt, omaxcnt, dmincnt, dmaxcnt;
  float ominsize, omaxsize, dminsize, dmaxsize;
  float ospeed, dspeed;
  float ominy, omaxy, dminy, dmaxy;
 
  Level(PImage img) {
    bg = img;
    bg.resize(width,height);
  }
 
  void setObstacle(PShape o, float speed, float miny, float maxy, float mins, float maxs, int mincnt, int maxcnt) {
    obstacle = o;
    ospeed = speed;
    ominy = miny;
    omaxy = maxy;
    ominsize = mins;
    omaxsize = maxs;
    omincnt = mincnt;
    omaxcnt = maxcnt;
  }
  void setDecor(PShape o, float speed, float miny, float maxy, float mins, float maxs, int mincnt, int maxcnt) {
    decor = o;
    dspeed = speed;
    dminy = miny;
    dmaxy = maxy;
    dminsize = mins;
    dmaxsize = maxs;
    dmincnt = mincnt;
    dmaxcnt = maxcnt;
  }
}
