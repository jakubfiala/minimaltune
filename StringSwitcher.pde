class StringSwitcher {

  int posX, posY;
  String[] labels = { 
    "E", "A", "D", "G", "B", "E"
  };
  int[] midinotes = { 
    40, 45, 50, 55, 59, 64
  }; //notes it will play
  Button[] buttons;
  int strings; //number of strings
  Synth synth;

  StringSwitcher(int theStrings, int x, int y) {
    strings = theStrings;
    buttons = new Button[strings];
    posX = x;
    posY = y;
    for (int i = 0; i < strings; i++) { //create buttons with appropriate positions and labels
      buttons[i] = new Button(posX+(i*35), posY, labels[i]);
    }
    synth = new Synth();
    synth.instrument(25); //General MIDI steel-stringed acoustic guitar
  }

  void display() {
    for (int i = 0; i < strings; i++) {
      buttons[i].display();
    }
  }

  void play() { //switcher's main functionality
    for (int i = 0; i < strings; i++) {
      if (buttons[i].isOn()) {
        synth.play(midinotes[i], 80, 5000); //if the button is on, play the appropriate note with velocity 80 and duration 5s
        buttons[i].turnOff(); //turn button off
      }
    }
  }

  void checkClick() {
    for (int i = 0; i < strings; i++) {
      buttons[i].mouseOver(); //button's checkClick function, copied from my previous program so it's called mouseOver
      if (buttons[i].isOn()) {
        //turn off all other buttons
        for (int j = 0; j < strings; j++) {
          if (j != i) {
            buttons[j].turnOff();
          }
        }
      }
    }
  }
}

