class DropDown {
  String[] items;
  int posX, posY;
  boolean itsOn = false;
  String selected; //currently selected item

  DropDown(int elements, int x, int y) { //how many elements do we need?
    items = new String[elements];
    posX = x;
    posY = y;
  }

  void populate(String[] itemsIn) {
    arrayCopy(itemsIn, items); //copy the incoming array to items[]
  }

  void display() {
    strokeWeight(2);
    textFont(font, 12);

    if (itsOn) {

      //main rect
      fill(255);
      rect(posX, posY, 100, 20);

      //dropped rect
      fill(0);
      rect(posX, posY+21, 100, (items.length-1)*21);
      fill(0);
      stroke(0);
      triangle(posX + 89, posY + 8, posX + 91, posY + 6, posX + 93, posY + 8);
      triangle(posX + 89, posY + 12, posX + 91, posY + 14, posX + 93, posY + 12);
      text(items[0], posX + 5, posY + 15);

      //display the remaining elements
      stroke(255);
      for (int i = 1; i < items.length; i++) {
        if (mouseX > posX && mouseX < (posX + 100) && mouseY > (posY + i*20)&& mouseY < (posY + (i+1)*20)) {            
          //mouseOver
          fill(255);
          rect(posX, posY + i*21, 100, 20);
          fill(0);
          text(items[i], posX + 5, posY + (i+1)*19);
        }
        else {
          //non-mouseOver
          fill(255);
          text(items[i], posX + 5, posY + (i+1)*19);
        }
      }
    }
    //ifItsNotOn
    else {
      fill(0);
      rect(posX, posY, 100, 20);
      fill(255);
      triangle(posX + 89, posY + 8, posX + 91, posY + 6, posX + 93, posY + 8);
      triangle(posX + 89, posY + 12, posX + 91, posY + 14, posX + 93, posY + 12);
      text(items[0], posX + 5, posY + 15);
    }

    selected = items[0]; //first item of the array is the selected one
  }

  void checkClick() {

    //expand the list
    if (mouseX > posX && mouseX < (posX + 100) && mouseY > posY && mouseY < (posY + 20)) {
      if (itsOn) {
        itsOn = false;
      }
      else {
        itsOn = true;
      }
    }

    //choose from the options
    if (itsOn) {
      String temp; //temporary memory space for swapping array items
      for (int i = 1; i < items.length; i++) {
        if (mouseX > posX && mouseX < (posX + 100) && mouseY > (posY + i*20)&& mouseY < (posY + (i+1)*20)) {
          temp = items[0];
          items[0] = items[i];
          items[i] = temp;
          itsOn = false;
        }
      }
    }
  }
  
  String selected() {
    return selected;
  }
  
}

