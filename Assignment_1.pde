import ddf.minim.*;
import controlP5.*;
import java.util.*;

ControlP5 cp5;
Minim minim;

ArrayList<Music> file = new ArrayList<Music>(); //Arraylist that will store the song used
List fileList = new ArrayList(); //List for the use with the controlp5 menu

ArrayList<Integer> pieChart = new ArrayList<Integer>(); //Storage for the songs to be used for the pi chart
int totalPie = 0;

int menuWidth = 256;

boolean graph = false;// boolean that sets if it displays the audio visulizer or the graph
boolean pause = false;// sets if the song is paused or not.
int track = 0; //Current track/song playing

void setup(){
  size(1280, 640);
  frameRate(24); //Limited frame rate as my computer is slow, helps reduce tearing on the waveform (still happens...)
  minim = new Minim(this);
  cp5 = new ControlP5(this);
  
  //Setup of data
  file.add(new Music("The Sword - Acheron_Unleashing the Orb.mp3"));//file.get(0)
  file.add(new Music("Tchaikovsky - Swan Lake.mp3"));//file.get(1)
  file.add(new Music("Pegboard Nerds & Tristam - Razor Sharp.mp3"));//file.get(2)
  file.add(new Music("The Beatles - Penny Lane.mp3"));//file.get(3)
  file.add(new Music("The Fellowship of the Ring - Concerning Hobbits.mp3"));//file.get(4)
  file.add(new Music("Star Wars - Rebel Blockade Runner.mp3"));//file.get(5)
  file.add(new Music("ZHU - Faded (ODESZA Remix).mp3"));//file.get(6)
  file.add(new Music("Foals - Spanish Sahara.mp3"));//file.get(7)
  file.add(new Music("Mt Eden Dubstep - Sierra Leone.mp3"));//file.get(8)
  file.add(new Music("Massive Attack - Pray for Rain.mp3"));//file.get(9)
  
  for(int i = 0; i < file.size(); i++){//populate the List
    fileList.add(file.get(i).saveAs);
  }
  cp5.addScrollableList("Music")//create the dropdown list
     .setPosition(1, 1)
     .setSize(menuWidth - 2, height - 172)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(fileList)
     .setColorBackground(color(2, 52, 77))
     .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
     
  cp5.addButton("Play")// create the button: Play
     .setPosition(1, height - 20)
     .setSize(menuWidth/2 - 2, 19)
     .setValue(0)
     .setColorBackground(color(2, 52, 77))
     ;
     
  cp5.addButton("Pause")// create the button: Pause
     .setPosition(menuWidth/2 + 1, height - 20)
     .setSize(menuWidth/2 - 2, 19)
     .setColorBackground(color(2, 52, 77))
     ;
  
  cp5.addButton("Graph")// create the button: Graph
     .setPosition(1, height - 20 - 50)
     .setSize(menuWidth - 2, 48)
     .setColorBackground(color(2, 52, 77))
     ; 
  cp5.addButton("Add")// create the button: Graph
     .setPosition(1, height - 20 - 50 - 50)
     .setSize(menuWidth - 2, 48)
     .setColorBackground(color(2, 52, 77))
     ;     
}

void draw(){
  background(0);
  stroke(100);
  fill(100);
  rect(0, 0, menuWidth - 1, height);
  fill(255);
  if(graph){
    makePie();
  }
  else{
    stroke(255);
    fill(255);
    textAlign(RIGHT);
    text("Waveform", width - 16, 15);
    text("Frequency", width - 16, 30);
    rect(width - 5, 5, -10, 10);
    stroke(255, 0, 0);
    fill(255, 0, 0);
    rect(width - 5, 20, -10, 10);
    
    if(file.get(track).song.isPlaying()){
      file.get(track).wave(menuWidth, height / 2);//Displays the waveform and frequency
    }
  }
  if(! file.get(track).song.isPlaying() && pause == false){//If the song ends it will play the next track.
    file.get(track).reWind();
    track++;
    if(track >= file.size()){
      track = 0;
    }
    file.get(track).play();
  }
  file.get(track).songTime(menuWidth);
  movePlay();
}

void Music(int play) {
  if(graph){//if it is in graph mode the dropdown will work as a checklist.
    file.get(play).checked = ! file.get(play).checked;
    CColor c = new CColor();
    
    if(file.get(play).checked){//it will colour the list part red aswell as add it to list of songs to add to the pie chart.
      pieChart.add(play);
      c.setBackground(color(255,0,0));
      cp5.get(ScrollableList.class, "Music").getItem(play).put("color", c);
    }
    else{
      for(int i = 0; i < pieChart.size(); i++){//checks the song that was unchecked from the list and removes it.
        if(play == pieChart.get(i)){
          pieChart.remove(i);
        }
      }
      c.setBackground(color(2, 52, 77));
      cp5.get(ScrollableList.class, "Music").getItem(play).put("color", c);//returns the colour to normal.
    }
  }
  else{//if in play song mode it will reset the current song playing than play the song selected
    file.get(track).reWind();
    track = play;
    file.get(play).play();
  }
  totalPie = 0;//Recalculates the total time for the chart 
  for(int i = 0; i < pieChart.size(); i++){
    totalPie = file.get(pieChart.get(i)).meta.length() + totalPie;
  }
}

public void controlEvent(ControlEvent theEvent) {//the event controller for the buttons
  println(theEvent.getController().getName());
}

public void Play(){
  if(! file.get(track).song.isPlaying()){// will play the song if it has been paused
    pause = false;
    file.get(track).play();
  }
}

public void Pause(){// if the song is playing it will pause it
  if(file.get(track).song.isPlaying()){
    pause = true;
    file.get(track).song.pause();
  }
}

public void Graph(){//changes to graph mode
  graph = ! graph;
  CColor c = new CColor();
  if(graph){//changes the colour of the graph button to show which mode it is in 
      cp5.get(Button.class, "Graph").setColorBackground(color(255, 0, 0));
    }
    else{
      cp5.get(Button.class, "Graph").setColorBackground(color(2, 52, 77));
    }
}

public void Add(){// add song to list
  javax.swing.JOptionPane.showMessageDialog(null, "Please add .mp3 files with metadata\nas this program uses the metadata\ntitle for the display of data.");
  selectInput("Select a song to add:", "fileSelected");
}

void fileSelected(File selection) {
  if(selection != null){
    String check = selection.getAbsolutePath().substring(selection.getAbsolutePath().lastIndexOf("."), selection.getAbsolutePath().length());
    println(check);
    if(check.matches(".mp3")){//checks if it is .mp3
      file.add(new Music(selection.getAbsolutePath()));//Adds the file to all the lists and buttons related
      fileList.add(file.get(file.size()-1).saveAs);
      cp5.get(ScrollableList.class, "Music").addItem(file.get(file.size()-1).saveAs, cp5);
    }
    else{
      javax.swing.JOptionPane.showMessageDialog(null, "File is not .mp3!");
    }
  }
}

void makePie(){//creates the pie chart
  float thetaPrev = 0;
  float centX = menuWidth/2 + width/2;
  float centY = height/2;
  for(int i = 0 ; i < pieChart.size(); i++){
     fill(file.get(pieChart.get(i)).c1, file.get(pieChart.get(i)).c2, file.get(pieChart.get(i)).c3);
     stroke(file.get(pieChart.get(i)).c1, file.get(pieChart.get(i)).c2, file.get(pieChart.get(i)).c3);
     
     float percent = map(file.get(pieChart.get(i)).meta.length(), 0, totalPie, 0, 100);// calculates the percentage of the song to total.
     float theta = map(file.get(pieChart.get(i)).meta.length(), 0, totalPie, 0, TWO_PI);
     textAlign(CENTER);
     float thetaNext = thetaPrev + theta;
     float radius = 500 * 0.6f;       
     float x = centX + sin(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;      
     float y = centY - cos(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;
     arc(centX, centY, 500, 500, thetaPrev, thetaNext);
     fill(255);
     text(file.get(pieChart.get(i)).meta.title() + ": " + percent + "%", x, y);     
     thetaPrev = thetaNext;
  }
  fill(255);
  textAlign(LEFT);
  text("Song length comparison: " + (String.format("%02d:%02d", 
      TimeUnit.MILLISECONDS.toMinutes(totalPie), 
      TimeUnit.MILLISECONDS.toSeconds(totalPie) - TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(totalPie)))
    ), menuWidth + 5, 15);
}

void movePlay(){//Allows the user to skip forward in the song
  if((mouseX > menuWidth + 35) && (mouseX < width - 35) && (mouseY > height - 30)){
    stroke(0, 0, 255);
    fill(0, 0, 255);
    ellipseMode(CENTER);
    ellipse(mouseX, height - 14, 5, 5);
    if(mousePressed){
      int i = (int) map(mouseX, menuWidth + 35,width - 35, 0, file.get(track).meta.length());
      if(i >= 0 && i < file.get(track).song.length()){
        file.get(track).song.cue(i);
      }
    }
  }
}
