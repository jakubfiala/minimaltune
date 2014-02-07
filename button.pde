class Button {
  int posX, posY;
  boolean on = false;
  String label;

  Button(int bposX, int bposY, String blabel) { //button is constructed with its coordinates as arguments
    posX = bposX;
    posY = bposY;
    label = blabel;
  }

  void mouseOver() { //this method turns the button on if, at the time of calling, the cursor is placed over the button. 
    if (mouseX > posX && mouseX < (posX+30) && mouseY > posY && mouseY < (posY+30)) {
      on = !on;
    }
  }

  void display() {
    if (on) {
      fill(255);
    }
    if (!on) {
      fill(0);
    }
    rect(posX, posY, 30, 30);
    if (on) {
      fill(0);
    }
    if (!on) {
      fill(255);
    }
    textSize(28);
    text(label, posX+7, posY+26);
  }
  
  boolean isOn() {
    return on;
  }
  
  void turnOff() {
    if (on) {
      on = false;
    }
  }
  
}

