import ddf.minim.*;

Minim minim;
Music file;

void setup(){
  size(1280, 640);
  
  minim = new Minim(this);
  String Filename = "Gorillaz - Feel Good Inc. (Remastered).mp3";
  
  file = new Music(Filename);
  file.play();
}
 
void draw(){
  background(0);
  stroke(255);
  
  file.wave(128, height / 2);
}
