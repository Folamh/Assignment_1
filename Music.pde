import ddf.minim.*;
import ddf.minim.analysis.*;
import java.util.concurrent.TimeUnit;

class Music{
  AudioPlayer song;
  AudioMetaData meta;
  FFT fft;
  
  String sLength;//Song length in the format XX:XX
  String saveAs;//Saves the filename without .mp3
  
  boolean checked; //if it is added to the pie chart
  int c1, c2, c3; //saved colour for the song
  
  Music(String fileName){
    song = minim.loadFile(fileName);
    meta = song.getMetaData();
    int index1 = fileName.lastIndexOf("\\");
    int index2 = fileName.indexOf(".");
    saveAs = fileName.substring(index1 + 1, index2);
    
    checked = false;
    c1 = (int) random(50, 200);
    c2 = (int) random(50, 200);
    c3 = (int) random(50, 200);
    
    sLength = String.format("%02d:%02d", 
      TimeUnit.MILLISECONDS.toMinutes(meta.length()), 
      TimeUnit.MILLISECONDS.toSeconds(meta.length()) - TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(meta.length()))
    );
  }
  
  void play(){//plays the song and sets up the Fast Fourier transform of it too.
    song.play();
    fft = new FFT(song.bufferSize(), song.sampleRate());
  }
  
  void reWind(){
    song.rewind();
    song.pause();
  }
  
  void wave(int startX,int startY){
    fft.forward(song.mix);
    stroke(255, 0, 0);
    int j = 0;
    for(int i = 0; i < fft.specSize(); i++){
      line(startX + i + j, startY, startX + i + j, startY - fft.getBand(i)*4);
      line(startX + i + j, startY, startX + i + j, startY + fft.getBand(i)*4);
      j++;
    }
    
    stroke(255);
    for(int i = 0; i < song.bufferSize() - 1; i++){
      line(startX + i, startY + song.mix.get(i) * 150, startX + i + 1, startY + song.mix.get(i+1) * 150);
    }
  };

  void songTime(int startX){
    fill(255);
    textAlign(LEFT);
    text(meta.title(), startX+1, height - 22);
    
    stroke(255);
    textAlign(LEFT);
    text((String.format("%02d:%02d", 
      TimeUnit.MILLISECONDS.toMinutes(song.position()), 
      TimeUnit.MILLISECONDS.toSeconds(song.position()) - TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(song.position()))
    )), startX, height - 10);
    
    textAlign(RIGHT);
    text(sLength, width, height - 10);
    
    line(startX+35, height - 14, width - 35, height - 14);
    stroke(0, 0, 255);
    line(startX+35, height - 14, map(song.position(), 0, meta.length(), startX+35, width - 35), height - 14);
  }
}
