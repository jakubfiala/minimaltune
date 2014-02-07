//minimaltune by Jakub Fiala
//using minim library by Damien Di Fede < http://code.compartmental.net/tools/minim/ >
//and SimplePolyMidiSynth class by Tim Blackwell < http://timblackwell.com >

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioInput input;
AudioOutput output;
Analyser analyser;
Meter meter;
DropDown modeMenu, freqMenu;
StringSwitcher switcher;
PFont font;

void setup() {
  //set up the environment
  background(0);
  size(900,600);
  frameRate(60);
  stroke(255);
  font = loadFont("Krungthep.vlw");
  //instantiate audio objects
  minim = new Minim(this);
  input = minim.getLineIn(minim.MONO, 8192);
  output = minim.getLineOut(); //output is only initialized so it can be closed
  analyser = new Analyser(input, 3.0);
  //eliminate feedback by closing the output
  output.noSound();
  //instantiate UI elements
  meter = new Meter(110);
  modeMenu = new DropDown(2,350,438);
  freqMenu = new DropDown(4,455,438);
  switcher = new StringSwitcher(6,350,385);
  //populate menus with arrays of items
  String[] modeItems = { "chromatic","tones" };
  String[] freqItems = { "440","441","442","443" };
  modeMenu.populate(modeItems);
  freqMenu.populate(freqItems);
}

void draw() {
  fill(255);
  background(0);
  textSize(46);
  //labels
  text("minimaltune",294,210);
  textSize(12);
  text("mode:",350,433);
  text("a4 frequency:",455,433);
  //display UI
  meter.display();
  freqMenu.display();
  modeMenu.display();
  switcher.display();
  //communication between meter and analyser objects 
  if (modeMenu.selected() == "chromatic") {
    analyser.refFreq = Integer.parseInt(freqMenu.selected()); //set the a4 frequency
    meter.note = analyser.getNote(input);
    meter.noteShouldDisplay = analyser.isItLoudEnough(); //only display the note if the sound is analysed
    meter.diff = analyser.deviation(); //control meter's pointer
    
    //debug features – display the spectrum, display current estimated frequency
      //analyser.spectrum(input);
      //text(analyser.getFreq(input),350,470);
  }
  else {
    switcher.play(); //if "tones" mode is selected, switcher object will work
  }
}

void mouseReleased() {
  //check UI elements for mouse clicks
  modeMenu.checkClick();
  freqMenu.checkClick();
  switcher.checkClick();
}

void stop()
{
  // always close Minim audio classes when you finish with them
  input.close();
  minim.stop(); 
  super.stop();
}
