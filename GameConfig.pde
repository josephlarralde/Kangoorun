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

public class GameConfig {
  
  int maxlevels;
  int nobstacles;
  float speed;
  int fadelength;
  String serverpath;
  
  PFont f;

  PImage play;
  PImage over;
  
  PShape hero;
  
  ArrayList<Obstacle> obstacles;
  ArrayList<Obstacle> decors;
  ArrayList<Level> levels;
  
  GameConfig() {
    
    obstacles = new ArrayList<Obstacle>();
    decors = new ArrayList<Obstacle>();
    levels = new ArrayList<Level>();
    
    maxlevels = 4;
    nobstacles = 10;
    speed = 4.;
    fadelength = 25;
    //serverpath = "http://www.josephlarralde.fr/jstests/flappytruc/data/";
    serverpath = "";
    
    f = createFont("Verdana", 12);

    play = loadImage(serverpath + "jumpforstart.png");
    // play.resize(100, 50);
    over = loadImage(serverpath + "gameover.png");

    hero = loadShape(serverpath + "kangy.svg");

    // ADD LEVELS /////////////////////////////////////////////////////////////////
    
    levels.add(new Level(loadImage(serverpath + "bg_athletic.jpg")));
    levels.add(new Level(loadImage(serverpath + "bg_mountain.jpg")));
    levels.add(new Level(loadImage(serverpath + "bg_town.jpg")));
    levels.add(new Level(loadImage(serverpath + "bg_desert.jpg")));
  
    // CONFIGURE LEVELS //////////////////////////////////////////////////////////
  
    // Level 1 (index 0) //////////////////////////////////////////////////////
  
    levels.get(0).setObstacle(loadShape(serverpath + "hedge.svg"), 
    1., // speed factor
    4.75 * height / 5, // min altitude
    4.75 * height / 5, // max altitude
    1., // minsize
    1., // maxsize
    120, // mincnt
    140); // maxcnt
    levels.get(0).setDecor(loadShape(serverpath + "grass.svg"), 
    0.75, // speed factor
    4.18 * height / 5, // min altitude
    4.18 * height / 5, // max altitude
    1.3, // minsize
    1.3, // maxsize
    2, // mincnt
    200); // maxcnt
  
    // Level 2 (index 1) //////////////////////////////////////////////////////
  
    levels.get(1).setObstacle(loadShape(serverpath + "snowman.svg"), 
    1., // speed factor
    4.75 * height / 5, // min altitude
    4.75 * height / 5, // max altitude
    1., // minsize
    1.25, // maxsize
    110, // mincnt
    140); // maxcnt
    levels.get(1).setDecor(loadShape(serverpath + "cloud.svg"), 
    0.3, // speed factor
    1. * height / 5, // min altitude
    3. * height / 5, // max altitude
    0.8, // minsize
    1.2, // maxsize
    100, // mincnt
    400); // maxcnt
  
    // Level 3 (index 2) //////////////////////////////////////////////////////
  
    levels.get(2).setObstacle(loadShape(serverpath + "trash.svg"), 
    1., // speed factor
    4.75 * height / 5, // min altitude
    4.75 * height / 5, // max altitude
    1., // minsize
    1.25, // maxsize
    110, // mincnt
    140); // maxcnt
    levels.get(2).setDecor(loadShape(serverpath + "cloud_dark.svg"), 
    0.3, // speed factor
    1. * height / 5, // min altitude
    3. * height / 5, // max altitude
    0.8, // minsize
    1.2, // maxsize
    100, // mincnt
    400); // maxcnt
    
    // Level 4 (index 3) //////////////////////////////////////////////////////
  
    levels.get(3).setObstacle(loadShape(serverpath + "cactus.svg"), 
    1., // speed factor
    4.75 * height / 5, // min altitude
    4.75 * height / 5, // max altitude
    0.75, // minsize
    1.25, // maxsize
    110, // mincnt
    140); // maxcnt
    levels.get(3).setDecor(loadShape(serverpath + "grass.svg"), 
    0.75, // speed factor
    4.3 * height / 5, // min altitude
    4.3 * height / 5, // max altitude
    1.3, // minsize
    1.3, // maxsize
    2, // mincnt
    200); // maxcnt 
  }
}
