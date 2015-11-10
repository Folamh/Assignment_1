import ddf.minim.*;
import ddf.minim.analysis.*;
import java.util.concurrent.TimeUnit;

class Music{
  AudioPlayer song;
  AudioMetaData meta;
  FFT fft;
  
  String sLength;
  
  Music(String fileName){
    song = minim.loadFile(fileName);
    meta = song.getMetaData();
    
    sLength = String.format("%02d:%02d", 
      TimeUnit.MILLISECONDS.toMinutes(meta.length()), 
      TimeUnit.MILLISECONDS.toSeconds(meta.length()) - TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(meta.length()))
    );
  }
  
  void play(){
    song.play();
    fft = new FFT(song.bufferSize(), song.sampleRate());
  }
  
  void wave(int startX,int startY){
    for(int i = 0; i < song.bufferSize() - 1; i++){
      stroke(255);
      line(startX + i, startY + song.mix.get(i) * 150, startX + i + 1, startY + song.mix.get(i+1) * 150);
    }
  }
  
  void freq(int startX,int startY){
    fft.forward(song.mix);
    stroke(255, 0, 0);
    int j = 0;
    for(int i = 0; i < fft.specSize(); i++){
      line(startX + i + j, startY, startX + i + j, startY - fft.getBand(i)*4);
      line(startX + i + j, startY, startX + i + j, startY + fft.getBand(i)*4);
      j++;
    }
  };
  
  void songTitle(){
    stroke(255);
    textAlign(CENTER);
    text(meta.title(), width/2, 10);
    
    
  }
  
  void songTime(){
    stroke(255);
    textAlign(LEFT);
    text((String.format("%02d:%02d", 
      TimeUnit.MILLISECONDS.toMinutes(song.position()), 
      TimeUnit.MILLISECONDS.toSeconds(song.position()) - TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(song.position()))
    )), 128, height - 10);
    
    textAlign(RIGHT);
    text(sLength, width - 128, height - 10);
    
    line(160, height - 14, width - 165, height - 14);
    stroke(0, 0, 255);
    line(160, height - 14, map(song.position(), 0, meta.length(), 160, width - 165), height - 14);
  }
}
