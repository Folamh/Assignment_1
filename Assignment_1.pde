import ddf.minim.*;
import controlP5.*;
import java.util.*;

ControlP5 cp5;
Minim minim;
ArrayList<Music> file = new ArrayList<Music>();
List fileList = new ArrayList();

ArrayList<Integer> pieChart = new ArrayList<Integer>();
int totalPie = 0;

int menuWidth = 256;

boolean graph = false;

int track = 2;
void setup(){
  size(1280, 640);
  frameRate(24);
  minim = new Minim(this);
  cp5 = new ControlP5(this);
  
  //Setup of data
  file.add(new Music("The Sword - Acheron_Unleashing the Orb.mp3"));//file.get(0)
  file.add(new Music("Tchaikovsky - Swan Lake.mp3"));//file.get(1)
  file.add(new Music("Pegboard Nerds & Tristam - Razor Sharp.mp3"));//file.get(2)
  file.add(new Music("The Beatles - Penny Lane.mp3"));//file.get(3)
  file.add(new Music("The Fellowship of the Ring Soundtrack-02-Concerning Hobbits.mp3"));//file.get(4)
  file.add(new Music("Star Wars Episode IV Soundtrack - Rebel Blockade Runner.mp3"));//file.get(5)
  file.add(new Music("ZHU - Faded (ODESZA Remix).mp3"));//file.get(6)
  file.add(new Music("Foals - Spanish Sahara Lyrics.mp3"));//file.get(7)
  file.add(new Music("Mt Eden Dubstep - Sierra Leone.mp3"));//file.get(8)
  file.add(new Music("Massive Attack - Pray for Rain.mp3"));//file.get(9)
  
  for(int i = 0; i < file.size(); i++){
    fileList.add(file.get(i).saveAs);
  }
  cp5.addScrollableList("Music")
     .setPosition(0, 0)
     .setSize(menuWidth, 300)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(fileList)
     .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
     
  cp5.addButton("Play")
     .setPosition(0, height - 20)
     .setSize(menuWidth/2 - 1, 19)
     .setValue(0)
     ;
     
  cp5.addButton("Pause")
     .setPosition(menuWidth/2 + 1, height - 20)
     .setSize(menuWidth/2 - 1, 19)
     ;
  
  cp5.addButton("Graph")
     .setPosition(0, height - 19 - 50)
     .setSize(menuWidth, 48)
     ;     
}

float n;
 
void draw(){
  background(0);
  
  if(graph){
    
    float thetaPrev = 0;
    float centX = menuWidth/2 + width/2;
    float centY = height/2;
    for(int i = 0 ; i < pieChart.size(); i++){
       fill(file.get(pieChart.get(i)).c1, file.get(pieChart.get(i)).c2, file.get(pieChart.get(i)).c3);
       stroke(file.get(pieChart.get(i)).c1, file.get(pieChart.get(i)).c2, file.get(pieChart.get(i)).c3);
       
       float theta = map(file.get(pieChart.get(i)).meta.length(), 0, totalPie, 0, TWO_PI);
       textAlign(CENTER);
       float thetaNext = thetaPrev + theta;
       float radius = 550 * 0.6f;       
       float x = centX + sin(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;      
       float y = centY - cos(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;
       arc(centX, centY, 500, 500, thetaPrev, thetaNext);
       fill(255);
       text(file.get(pieChart.get(i)).saveAs, x, y);     
       thetaPrev = thetaNext;
     }
  }
  else{
    if(file.get(track).song.isPlaying()){
      file.get(track).songTitle(menuWidth);
      file.get(track).freq(menuWidth, height / 2);
      file.get(track).wave(menuWidth, height / 2);
    }
  }
  file.get(track).songTime(menuWidth);
  n += (1-n)* 0.1; 
}

void Music(int play) {
  if(graph){
    file.get(play).checked = ! file.get(play).checked;
    CColor c = new CColor();
    
    if(file.get(play).checked){
      pieChart.add(play);
      c.setBackground(color(255,0,0));
      cp5.get(ScrollableList.class, "Music").getItem(play).put("color", c);
    }
    else{
      for(int i = 0; i < pieChart.size(); i++){
        if(play == pieChart.get(i)){
          pieChart.remove(i);
        }
      }
      c.setBackground(color(2, 52, 77));
      cp5.get(ScrollableList.class, "Music").getItem(play).put("color", c);
    }
  }
  else{
    file.get(track).reWind();
    track = play;
    file.get(play).play();
  }
  totalPie = 0;
  for(int i = 0; i < pieChart.size(); i++){
    totalPie = file.get(pieChart.get(i)).meta.length() + totalPie;
  }
}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  n = 0;
}

public void Play(){
  if(! file.get(track).song.isPlaying()){
    file.get(track).play();
  }
}
public void Pause(){
  if(file.get(track).song.isPlaying()){
    file.get(track).song.pause();
  }
}

public void Graph(){
  graph = ! graph;
  if(graph){
    
    }
    else{
      
    }
}
