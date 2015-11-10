import ddf.minim.*;

Minim minim;
ArrayList<Music> file = new ArrayList<Music>();

void setup(){
  size(1280, 640);
  
  minim = new Minim(this);
  
  //Setup of data
  file.add(new Music("The Sword - Acheron_Unleashing the Orb.mp3"));//file.get(0)
  file.add(new Music("Tchaikovsky - Swan Lake.mp3"));//file.get(1)
  file.add(new Music("Pegboard Nerds & Tristam - Razor Sharp.mp3"));//file.get(2)
  file.add(new Music("The Beatles - Penny Lane.mp3"));//file.get(3)
  file.add(new Music("The Fellowship of the Ring Soundtrack-02-Concerning Hobbits.mp3"));//file.get(4)
  file.add(new Music("Star Wars Episode IV Soundtrack - Rebel Blockade Runner.mp3"));//file.get(5)
  /*file.add(new Music(""));//file.get(6)
  file.add(new Music(""));//file.get(7)
  file.add(new Music(""));//file.get(8)
  file.add(new Music(""));//file.get(9)*/
  
  file.get(0).play();
}
 
void draw(){
  background(0);
  
  file.get(0).songTitle();
  file.get(0).freq(128, height / 2);
  file.get(0).wave(128, height / 2);
  file.get(0).songTime();
}
