Feld feld;
Loeser loeser;

int selectedFeldx=0;
int selectedFeldy=0;

String grundFuerZiffer = "";
String fehlEingabeText = "";

int[][] beispiel = {{0,8,0,4,0,0,0,0,0},{0,0,7,0,1,0,6,0,0},{5,0,0,0,0,3,0,4,0},{3,0,0,0,0,2,5,0,0},{0,0,1,0,7,0,0,0,0},{0,0,0,5,0,0,0,0,9},{0,0,5,3,0,0,0,0,7},{0,2,0,0,0,8,0,3,0},{0,0,0,0,6,0,9,0,0}}; 

void setup() {
  frameRate(60);
  size(1200, 550);
  background(255);
  feld = new Feld();
  loeser = new Loeser(feld);
}

void draw() {
  int normaleFarbe = color(0, 200, 0);
  int fehlerFarbe = color(200, 0, 0);

  background(255);
  drawLines();

  noFill();
  strokeWeight(2);
  stroke(feld.fehler?fehlerFarbe:normaleFarbe);
  rect(selectedFeldx*50+54, selectedFeldy*50+54, 42, 42);
  showNumbers();

  textSize(15);
  text("Klicke auf die Felder und gib die Ziffern ein um das Sudoku zu füllen.\nDrücke Entfernen um das ganze Feld zu leeren.\nDrücke Enter um den Nächsten Schritt zu sehen\noder die Leertase um das Sudoku auf einmal lösen zu lassen.", 550, 50);

  if (feld.fertig()) {
    noStroke();
    fill(normaleFarbe);
    text("Sudoku gelöst!", 550, 300);
  } else if (feld.fehler) {
    noStroke();
    fill(fehlerFarbe);
    text("Sudoku unlösbar!", 550, 300);
  }

  fill(fehlerFarbe);
  text(fehlEingabeText, 550, 400);

  fill(0);
  text(grundFuerZiffer, 550, 200);
  
  text("Um ein Beispielsudoku zu laden, drücke b.", 550, 460);
  
  text("Sudokulöser\n©2018 Jorin Eggers", 50, 520);
}

void mousePressed() {
  fehlEingabeText = "";
  if (mouseX>50&&mouseX<500&&mouseY>50&&mouseY<500) {
    selectedFeldx =(mouseX-50)/50;
    selectedFeldy=(mouseY-50)/50;
  }
}


//Tastaureingaben verarbeiten
void keyPressed() {
  fehlEingabeText = "";

  if (((int)key>=48&&(int)key<=57) || key == BACKSPACE) {
    feld.setze(selectedFeldx, selectedFeldy, key-48);
    if (feld.frei(selectedFeldx, selectedFeldy) && key > 48 && key != BACKSPACE)fehlEingabeText = "Die " +(key-48) + " ist an dieser Stelle nicht möglich!";
    grundFuerZiffer = "";
  }

  if (key==ENTER||key==RETURN) {
    loeser.schritt();
    zeigeGrund();
  } else if (key == ' ') {
    loeser.komplettLoesen();
    if(feld.fehler)zeigeGrund();
  } else if (key == DELETE) {
    feld.allesLeeren();
    grundFuerZiffer = "";
  }else if(key == 'b'){
    feld.allesLeeren();
    feld.setzeFeld(beispiel);
    fehlEingabeText = "";
    grundFuerZiffer = "";
  }else if(keyCode == UP){
    selectedFeldy--;
    if(selectedFeldy<0)selectedFeldy+=9;
  }else if(keyCode == DOWN){
    selectedFeldy++;
    if(selectedFeldy>8)selectedFeldy-=9;
  }else if(keyCode == LEFT){
    selectedFeldx--;
    if(selectedFeldx<0)selectedFeldx+=9;
  }else if(keyCode == RIGHT){
    selectedFeldx++;
    if(selectedFeldx>8)selectedFeldx-=9;
  }
}

void zeigeGrund() {
  Grund grund = loeser.Gruende.get(loeser.Gruende.size()-1);
  grundFuerZiffer = grund.grund;
  selectedFeldx = grund.x;
  selectedFeldy = grund.y;
}


//Sudoku feld malen
void drawLines() {
  stroke(0);
  for (int i=0; i<=450; i+=50) {
    if (i%150==0) {
      strokeWeight(2);
    } else {
      strokeWeight(1);
    }
    line(i+50, 50, i+50, 500);
  }

  for (int i=0; i<=450; i+=50) {
    if (i%150==0) {
      strokeWeight(2);
    } else {
      strokeWeight(1);
    }
    line(50, i+50, 500, i+50);
  }
  strokeWeight(1);
}



//nummer im Sudoku anzeigen
void showNumbers() {
  fill(0);
  noStroke();
  for (int x=0; x<=8; x++) {
    for (int y=0; y<=8; y++) {
      textSize(40);
      text(feld.getZifferString(x, y), x*50+62, y*50+90);
    }
  }
}