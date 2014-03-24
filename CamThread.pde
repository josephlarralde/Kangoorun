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

public class CamThread extends Thread {
  
  Capture cam;

  boolean available;
  boolean running;
  int wait;
  int count;
  
  CamThread(PApplet p) {
    
    //this.url = url;

    available = false;
    running = false;
    wait = 0;
    count = 0;
    
    String[] cameras = Capture.list();
  
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        println(cameras[i]);
      }
    
      // The camera can be initialized directly using an 
      // element from the array returned by list():
      //cam = new Capture(p, cameras[15]); // Live! fps=30
      cam = new Capture(p, cameras[0]);
      cam.start();     
    }      

  }
  
  void start() {
    running = true;
    super.start();
  }
  
  void run() {
    while(running) {
      if (cam.available() == true) {
        cam.read();
        available = true;
      }
      try {
        sleep((long)(100));
      }
      catch(Exception e) {
      }
    }
  }
  
  void quit() {
    running = false; // Setting running to false ends the loop in run()
    interrupt();     // In case the thread is waiting ...
  }
  
  boolean available() {
    return available;
  }
  
  void takeShot() {
    available = false;
    cam.save("jump.jpg");
  }

  void takeShot(String s) {
    available = false;
    cam.save(s + ".jpg");
  }
}
