class Meter {
  float theta = 0.2, target, diff; //current pointer position (radians), target position, frequency deviation
  int rad; //radius of the pointer reach
  String note;
  boolean noteShouldDisplay = false;

  Meter(int radius) {
    rad = radius;
  }

  void display() {
    noFill();
    stroke(255);
    strokeWeight(5);

    //frame
    rect(300, 225, 300, 150);
    fill(255);
    arc(450.0, 375.0, 80, 80, PI, TWO_PI, PIE);

    //pointer with smoothing implementation
    target = map(diff, 0.5, -0.5, 0.2, PI-0.2); //set target angle
    if (theta < target && theta < PI-0.2) { //if below target and below the left limit, increase theta
      theta+=0.04;
    }
    else if (theta > (target+0.05) && theta > 0.2 ) { //if above target and above right limit, decrease theta (0.05 added to avoid the "trembling" effect)
      theta-=0.04;
    } 
    line(450, 375, 450-cos(theta)*rad, 375-sin(theta)*rad); //draw the line /w trigonometric functions

    //scale
    noFill();
    strokeWeight(2);
    arc(450.0, 375.0, 270, 270, PI+0.2, TWO_PI-0.2, OPEN);
    line(450, 240, 450, 250);

    //display
    if (noteShouldDisplay) {
    if (theta < (HALF_PI+0.07) && theta > (HALF_PI-0.07)) { //change fill to green if pointer is near the center 
      fill(0, 200, 0);
    }
    else {
      fill(0);
    }
      //note
      textSize(40);
      text(note, 437, 370);
      strokeWeight(0);
      //lower indicator
      fill(0);    
      if (theta > (HALF_PI+0.07)) {
        fill(200, 0, 0);
      }
      triangle(464, 350, 472, 357, 464, 364);
      //higher indicator
      fill(0);
      if (theta < (HALF_PI-0.07)) {
        fill(200, 0, 0);
      }
      triangle(435, 350, 427, 357, 435, 364);
    }
  }
}

