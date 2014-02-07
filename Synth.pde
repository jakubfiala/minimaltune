//class written by Tim Blackwell

import javax.sound.midi.*;

class Synth {

  Synthesizer synthesizer = null; // the Java MIDI synth
  MidiChannel channel; // the single MIDI channel

    long[] notesOn;
  int polyphony;
  int totalOn;

  Synth() { 

    // Get synth and open it
    try {
      synthesizer = MidiSystem.getSynthesizer();
      synthesizer.open();
    }
    catch (MidiUnavailableException e) {
      e.printStackTrace();
    }

    // Available polyphony
    //System.out.println("max polyphony " + synthesizer.getMaxPolyphony());
    polyphony = synthesizer.getMaxPolyphony();
    totalOn = 0;

    // Set our channel to the first MIDI channel
    MidiChannel[] channels = synthesizer.getChannels();
    channel = channels[0];

    notesOn = new long[128];
    for (int i =0 ;i < notesOn.length; ++i)
      notesOn[i] =-1; // i.e. note is off
  }

  // Simple control change to set pan
  void pan(int i) {
    channel.controlChange(10, i);
  }

  // Select an instrument 
  void instrument(int i) {
    channel.programChange(0, i);
  }

  // Panic button to kill all sounding notes
  void allNotesOff() {
    channel.allNotesOff();
  }

  void update() {
    long now = System.currentTimeMillis();
    for (int i = 0; i < notesOn.length; ++i) {
      if (notesOn[i] > -1 && now > notesOn[i] ) { // if note is not off and is due for termination
        play(i, 0);
        notesOn[i] = -1;
      }
    }
  }

  // Play a note. The caller will have to manage note-off's
  void play(int noteIn, int vel) {
    channel.noteOn(noteIn, vel);
    if (vel > 0) ++totalOn;
    else --totalOn;
  }

  // Play a note at a given velocity and for a given duration
  void play(int noteIn, int vel, long deltaT) {

    // Client should be calling update() at a resolution that is at most the minimum required duration 
    update();

    // check polyphony
    if (totalOn >= polyphony) {
      return;
    }

    long now = System.currentTimeMillis();

    // Either

    // only sound if this note is off 
    if (notesOn[noteIn] == -1) {
      play(noteIn, vel);
      notesOn[noteIn] = now + deltaT;
    }

    // or, play anyway
    //    if(notesOn[noteIn] > -1) {
    //      play(noteIn, 0);
    //    }
    //    play(noteIn, vel);
    //    notesOn[noteIn] = now + deltaT;
  }

  // Close and release resources
  void close() {
    synthesizer.close();
  }
}

