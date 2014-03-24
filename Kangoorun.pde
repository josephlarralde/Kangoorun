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

import ddf.minim.*;
import processing.serial.*;
import processing.video.*;

Minim minim;                  // audio manipulation class
Serial port;                  // serial class for communication with arduino
//CamThread shoota;             // threaded camera class for taking picts of the players in real-time

GameConfig gc;

AudioSample playersaut;       // jump sound fx
AudioSample playermort;       // lose sound fx

PImage bg;                    // current background
PImage nextbg;                // next background
PImage play;                  // play button image
PImage over;                  // game over image

Character kang;
ArrayList<Obstacle> obstacles;
ArrayList<Obstacle> decors;
ArrayList<Level> levels;

PFont f;
String arduinoin;             // monitor incoming data from arduino

//////////////////////////////// various counters :
int ocnt, onextcnt, dcnt, dnextcnt;
int allocnt;

float speed;                  // general speed in pixels per frame

//////////////////////////////// stuff for sensitive carpet :
float serialvalue;
float lowthresh;
float highthresh;
boolean onoff;

String serverpath;            // set to http address if picts are online

int score, highscore;
int level, maxlevels;
int nobstacles;

//////////////////////////////// stuff for interpolation between levels
Level stage, nextstage;
boolean fading;
int fadelength;
int fadeframe;
float fadefactor;

//////////////////////////////// game state variables
boolean dead;
boolean begin;
boolean pause;

// ************************************************************************************* //
// *********************************** SETUP ******************************************* //
// ************************************************************************************* //

void setup() {

  //size(800, 600);
  size(displayWidth, displayHeight);
  
  gc = new GameConfig();
  
  //serverpath = "http://www.josephlarralde.fr/jstests/flappytruc/data/";
  serverpath = "";

  ///////////////////////////////////////////////////////////// SOUND STUFF
  minim = new Minim(this);
  playersaut = minim.loadSample(serverpath + "rebond.MP3", 512);  
  playermort = minim.loadSample(serverpath + "mort.MP3", 512);

  ///////////////////////////////////////////////////////////// SERIAL STUFF
  // List all the available serial ports
  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);
  port.bufferUntil('\n');

  serialvalue = 0;
  lowthresh = 400;
  highthresh = 700;
  onoff = false;
  
  ///////////////////////////////////////////////////////////// CAMERA STUFF  
  //shoota = new CamThread(this);
  //shoota.start();
  
  /////////////////////////////////////////////////////// GAME INITIALIZATION  
  play = gc.play;
  over = gc.over;

  kang = new Character(gc.hero);
  
  maxlevels = gc.maxlevels;
  nobstacles = gc.nobstacles;
  speed = gc.speed;
  fadelength = gc.fadelength;
  
  dead = true;
  begin = true;
  pause = false;
  score = highscore = 0;
  level = 0;
  fading = false;
  fadeframe = 0;
  fadefactor = 0.;

  f = gc.f;
  textFont(f);
  arduinoin = "";

  obstacles =  gc.obstacles;
  decors =     gc.decors;
  levels =     gc.levels;

  stage = levels.get(0);
  nextstage = levels.get(1);
  bg = stage.bg;
  nextbg = nextstage.bg;

  ocnt = dcnt = allocnt = 0;
  onextcnt = (int)random(stage.omincnt, stage.omaxcnt);
  dnextcnt = (int)random(stage.dmincnt, stage.dmaxcnt);
}

// ************************************************************************************* //
// *********************************** DRAW ******************************************** //
// ************************************************************************************* //

void draw() {
  
  if(pause) {
    return;
  }
  
  /////////////////////////// CHECK IF FADING BETWEEN LEVELS ///////////////////////

  if (fading) {
    fadeframe++;

    fadefactor = (float)fadeframe/(fadelength-1);

    tint(255, 255 * pow(1. - fadefactor, 0.5));
    image(bg, 0, 0);
    tint(255, 255);

    //*
    if (fadeframe >= fadelength && obstacles.size() == 0) {
      fading = false;
      decors = new ArrayList<Obstacle>();
      fadeframe = 0;
      stage = nextstage;
      bg = nextbg;
      if (level >= maxlevels - 1) {
        nextstage = levels.get(maxlevels - 1);
      } 
      else {
        if (level == 0) { // we are beginnig from start
          nextstage = levels.get(1);
        } 
        else {
          nextstage = levels.get(level + 1);
        }
      }
      nextbg = nextstage.bg;
    }
    //*/
  } 
  else {
    image(bg, 0, 0);
  }

  ////////////////////////////////// DECORS ////////////////////////////////////////

  if (!fading) {
    dcnt++; // <=> cnt = cnt + 1;
    if (dcnt == dnextcnt && !fading) {
      decors.add(new Obstacle(stage.decor, 
      random(stage.dminy, stage.dmaxy), 
      random(stage.dminsize, stage.dmaxsize)));
      dnextcnt = (int)random(stage.dmincnt, stage.dmaxcnt); // space between obstacles in frames
      dcnt = 0;
    }
  }      

  for (int i=0; i<decors.size(); i++) {
    tint(255, 255 * pow(fadefactor, 0.5));
    decors.get(i).update(speed * stage.dspeed);
    decors.get(i).display();
    tint(255, 255);
  }

  while (decors.size () > 0 && decors.get(0).pos.x < -500) { // arbitrary value, good in most cases
    decors.remove(0);
  }

  ///////////////////////////////// NEXT BG ///////////////////////////////////////

  if (fading) {
    tint(255, 255 * pow(fadefactor, 0.5));
    image(nextbg, 0, 0);
    tint(255, 255);
  }

  ////////////////////////////////// OBSTACLES /////////////////////////////////////

  if (!fading) {
    ocnt++; // <=> cnt = cnt + 1;
    if (ocnt == onextcnt && !dead) {
      obstacles.add(new Obstacle(stage.obstacle, 
      random(stage.ominy, stage.omaxy), 
      random(stage.ominsize, stage.omaxsize)));
      allocnt++;

      // WAIT KANGY TO JUMP OVER LAST OBSTACLE OF LEVEL BEFORE CREATING A NEW ONE :
      if ((allocnt - 1) / nobstacles > level) {
        obstacles.remove(obstacles.size() - 1);
        allocnt--;
      }

      onextcnt = (int)random(stage.omincnt, stage.omaxcnt); // space between obstacles in frames
      ocnt = 0;
    }
  }

  for (int i=0; i<obstacles.size(); i++) {

    float prevpos, newpos;
    prevpos = obstacles.get(i).bbox[0].x + obstacles.get(i).bbox[1].x;
    obstacles.get(i).update(speed * stage.ospeed);
    newpos = obstacles.get(i).bbox[0].x + obstacles.get(i).bbox[1].x;

    if (prevpos >= kang.bbox[0].x && newpos < kang.bbox[0].x) {
      score++;
      if (score % nobstacles == 0 && level < score / nobstacles) {
        level = score / nobstacles;
        fading = true;
      }
    }

    // COLLISION CHECKING ///////////////////////////////////////////

    if (kang.checkCollision(obstacles.get(i))) {
      obstacles = new ArrayList<Obstacle>();
      kang.endjump();
      dead = true;
      playermort.trigger();
      allocnt = 0;
      if (score > highscore) {
        highscore = score;
      }
      score = 0;
      return;
    }      

    tint(255, 255 * pow(1. - fadefactor, 0.5));
    obstacles.get(i).display();
    tint(255, 255);
  }

  while (obstacles.size () > 0 && obstacles.get(0).pos.x < -500) { // same arbitrary value, still good in most cases
    obstacles.remove(0);
  }

  kang.update();
  kang.display();

  if (!dead) {
  }
  else {
      image(play, width/2 - play.width/2, height/2 - play.height/2);
  }

  //ellipse(serialvalue, height/2, 10, 10); // kind of fader to display capacitive sensor data
  fill(0);
  text("HIGH SCORE : " + highscore + " / YOUR SCORE : " + score, 20, 20);
  text("LEVEL : " + level, 20, 50);
  fill(255);
  text(arduinoin, width/2, height/5);
}

void reinit() {
  obstacles = new ArrayList<Obstacle>();
  if (begin) {
    stage = levels.get(0);
    bg = stage.bg;
    nextstage = levels.get(1);
    begin = false;
  } 
  else {
    nextstage = levels.get(0);
    fading = true;
  }
  nextbg = nextstage.bg;
  ocnt = dcnt = allocnt = 0;
  level = 0;
  score = 0;
  dead = false;
}

void keyPressed() {
  if (key == ' ' && !dead && !kang.jumping && !kang.falling) {
    kang.startjump();
    playersaut.trigger();
    //if(shoota.available()) {
    //  shoota.takeShot();
    //}
  }
  
  if(key == 'p' || key == 'P') {
    pause = !pause;
  }
}

void keyReleased() {
  if (key == ' ' && !dead) {
    kang.endjump();
  }
  
  if(key == 's' || key == 'S') {
    saveFrame("###_kangoo.jpg");
  }
}

void mousePressed() {
  if (dead
    && mouseX > width/2 - play.width/2
    && mouseX < width/2 + play.width/2
    && mouseY > height/2 - play.height/2
    && mouseY < height/2 + play.height/2) {
    reinit();
  }
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    arduinoin = inString;
    println(arduinoin);

    // convert to an int and map to the screen height:
    float inByte = float(inString);
    inByte = inByte > 1023 ? 1023 : inByte;
    inByte = map(inByte, 0, 1023, 0, width);
    serialvalue = inByte;
    
    int step = inString.equals("ON") ? 1 : 0;
    //println("step : " + step);

    //if (serialvalue > highthresh && !onoff) {
    if (step==1 && !onoff) {
      if (!dead) {
        onoff = true;
        kang.endjump();
      } 
    }
    
    //else if (serialvalue < lowthresh && onoff) {
    else if (step==0 && onoff) {
      onoff = false;
      if(!dead && !kang.jumping && !kang.falling) {
        //player.trigger();
        kang.startjump();
        //player.trigger();
      }
      if(dead || begin) {
        reinit();
      }
    }
  }
}

//*
boolean sketchFullScreen() {
  return true;
}
//*/
