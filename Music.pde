import ddf.minim.*;



class Music{
  AudioPlayer song;
  
  
  Music(String fileName){
    song = minim.loadFile(fileName);
  }
  
  void play(){
    song.play();
  }
  
  void wave(int startX,int startY){
    for(int i = 0; i < song.bufferSize() - 1; i++){
      line(startX + i, startY + song.mix.get(i) * 150, startX + i + 1, startY + song.mix.get(i+1) * 150);
    }
  }
}
