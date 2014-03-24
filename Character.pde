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

public class Character {
  
  PShape shp;
  PVector pos, ground;
  float size;
  PVector[] bbox;       // topleft coords and (width,height)
  
  boolean jumping;      // true if character is jumping
  boolean falling;      // true if character is falling
  
  float wheight, jheight, jstep, jaccum, fallstart;
  int wframes, wframe, jframes, jframe, maxjframe, fframes, fframe;
  
  Character(PShape ps) {
    shp = ps;
    
    // TODO : put into GameConfig
    size = 4.5; 
    ground = new PVector(width/2-(shp.width*size)/2, 4.55*height/5); // arbitrary value for y

    pos = new PVector(ground.x, ground.y);
    bbox = new PVector[2];
    updatebbox();       // according to pos and shp

    //jump = false;
    jumping = false;
    falling = false;
    wheight = 25;       // jump height in walking mode
    jheight = 18;       // height of top bell of jump trajectory (height after start falling) 
    jstep = 10;         // initial height increment at beginning of jump
    jaccum = 0;         // jump accumulator
    fallstart = pos.y;  // falling starting point

    wframes = 24;       // number of frames for a walk anim cycle
    wframe = 0;         // walking frame counter
    jframes = 18;       // number of frames decelerating at beginning of jump
    maxjframe = 60;     // force stop jump (start fall) after this number of frames
    jframe = 0;         // jumping frame counter
    fframes = 18;       // number of frames terminating jump before going down (bell duration)
    fframe = 0;         // falling frame counter
  }
  
  void startjump() {    // as the name says
    
    // this prevents flying kangaroo
    if(!falling && !jumping) {
      jumping = true;
      jaccum = -jstep;
      jframe = 0;
    }
  }
  
  void endjump() {      // as the name says
    
    if(jumping) {
      falling = true;
      jumping = false;
      jaccum = 0;
      fframe = 0;
    }
  }
  
  boolean checkCollision(Obstacle o) {
        
    PVector[] obb = new PVector[2];
    obb[0] = new PVector(o.bbox[0].x,o.bbox[0].y);
    obb[1] = new PVector(o.bbox[1].x,o.bbox[1].y);
    
    if(bbox[0].x + bbox[1].x > obb[0].x
       && bbox[0].x < obb[0].x + obb[1].x
       && bbox[0].y + bbox[1].y > obb[0].y
       && bbox[0].y < obb[0].y + obb[1].y) {
      return true;
    } else {
      return false;
    }
  }
  
  void update() {
    
    if(!jumping && !falling) { ////////////////////////// --- walking
    
      pos.y = ground.y + map(sin(((float)wframe/wframes)*PI),1.,0.,0.,wheight);
      wframe++;
      if(wframe >= wframes) {
        wframe = 0;
      }
      
    } else {
      
      if(jumping) { ///////////////////////////////////// --- jumping
      
        pos.y += jaccum;
        if(jframe < jframes) {
          jaccum *= 0.97; 
        }
        jframe++;
        if(jframe > maxjframe) {
          endjump();
        }
        fallstart = pos.y;
        
      } else { ////////////////////////////////////////// --- falling
      
        if(fframe < fframes) {          
          jaccum = map(sin(((float)fframe/fframes)*PI),0.,1.,0.,jheight);
          pos.y = fallstart - jaccum;
          fframe++;
        } else {
          pos.y += jaccum;
          jaccum *= 1.1;
        }
        
        if(pos.y >= ground.y) {
          falling = false;
          pos.y = ground.y;
          wframe = 0;
        }
        
      }
    }
    
    updatebbox();
  }
  
  void display() {
    // UNCOMMENT TO SHOW COLLISION BOX :
    //rect(bbox[0].x, bbox[0].y, bbox[1].x, bbox[1].y);
         
    shape(shp, pos.x, pos.y - shp.height*size,
          shp.width*size,shp.height*size);
  }
  
  void updatebbox() {
    bbox[0] = new PVector(pos.x + shp.width*size/2 - shp.width*size/4,
                          pos.y - shp.height*size);
    bbox[1] = new PVector(shp.width*size*2/4,
                          shp.height*size);
  }
}
