class Analyser {

  FFT fft;   
  float refFreq; //reference (a4) frequency
  float threshold; //
  boolean itsLoudEnough = false; //is audio input above the volume threshold?
  float ndiff; //difference between n and the current note value
  String note = " "; //note (character form)

  //array of MIDI note values grouped by note they represent
  float[][] nums = { 
    { 36, 48, 60, 72 }, 
    { 37, 49, 61, 73 }, 
    { 38, 50, 62, 74 }, 
    { 39, 51, 63, 75 }, 
    { 40, 52, 64, 76 }, 
    { 41, 53, 65, 77 }, 
    { 42, 54, 66, 78 }, 
    { 43, 55, 67, 79 }, 
    { 44, 56, 68, 80 }, 
    { 45, 57, 69, 81 }, 
    { 46, 58, 70, 82 }, 
    { 47, 59, 71, 83 }
  };

  //note strings (easily mapped to note values via array indices)
  String[] notes = { "C", "C.", "D", "D.", "E", "F", "F.", "G", "G.", "A", "A.", "B" };

  Analyser(AudioInput in, float thresh) { //pass the desired input and volume threshold to constructor
    fft = new FFT(in.bufferSize(), in.sampleRate()); //create FFT object with parameters of the audio input
    threshold = thresh; //set threshold
  }


  float getFreq(AudioInput in) {

    fft.forward(in.left); //get the spectrum
    fft.window(FourierTransform.HAMMING); //clarify the spectrum by "windowing" it by the Hamming constant
    
    float[] bandAmps = new float[fft.specSize()]; //create an array for the spectrum
    int bandIndex = 0;
    float freq = 0;   
    
    
    for (int i = 0; i < fft.specSize(); i++)
    {
      bandAmps[i] = fft.getBand(i); //save spectrum into array
    }
    
    float maxAmp = 0; //current highest amplitude detected
    for (int i = 0; i<(bandAmps.length/64); i++) { //we will only be using the first 128 frequency bands, or 1/64 of buffer size
      if (bandAmps[i] > maxAmp) { //in case the next band is louder than the current maximum
        maxAmp = bandAmps[i];     //its amplitude becomes the maximum
        bandIndex = i;            //and we store its index
      }
    }

    if (bandAmps[bandIndex] > threshold) {     //if the aplitude is higher than the threshold
      itsLoudEnough = true;                    //it's loud enough! and we should obtain its frequency
      
      //parabolic interpolation algorithm for precisely finding the actual frequency of the peak
      float delta = ( (1.22*(bandAmps[bandIndex+1] - bandAmps[bandIndex-1])) / (bandAmps[bandIndex] + bandAmps[bandIndex+1] + bandAmps[bandIndex-1])); //calculate deviation from the indexed band
      float peak = bandIndex + delta; //calculate exact peak position within the spectrum
      freq = peak*in.sampleRate()/in.bufferSize(); //convert to frequency
    }
    else {
      itsLoudEnough = false;                   //otherwise, it's not loud enough
    }
    
    return freq;
  }

  String getNote(AudioInput in) {

    float frequency = getFreq(in);
    //calculate the current note value
    float nfreq = 69 + 12*(log(frequency/refFreq)/log(2.0));
    //difference between the target value and the current one
    ndiff = round(nfreq) - nfreq;
    //find what note it is
    for (int i = 0; i < 12; i++) {
      for (int j = 0; j < 4; j++) {
        if (nums[i][j] == round(nfreq)) {
          note = notes[i];
        }
      }
    }
    
      return note;
  }

  boolean isItLoudEnough() {
    return itsLoudEnough;
  }
  
  float deviation() {
    return ndiff;
  }

  //debug feature, get and visualize the current spectrum of audio input 
  void spectrum(AudioInput in) {
    fft.forward(in.left); //get the spectrum
    //make a line as long as the amplitude of each band
    for (int i = 0; i < fft.specSize(); i++)
    {
      stroke(255);
      line(i, height, i, height - fft.getBand(i) * 8);
    }
  }


}

