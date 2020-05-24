class Loeser {
  ArrayList<Grund> Gruende = new ArrayList<Grund>(81);
  Feld feld;

  public Loeser(Feld feld) {
    this.feld = feld;
  }

  public void komplettLoesen() {
    do {
      schritt();
    } while (!abbruch());
  }

  public boolean abbruch() {
    return feld.fertig() || feld.fehler;
  } 


  //es wird solange schritt() aufgerufen bis durch Probieren eine funktionierende Lösung gefunden wurde,
  //das Sudoku normal gelöst wurde oder es als unlösbar erkannt wurde

  public boolean loesbar() {
    Loeser l = new Loeser(feld.kopieren());
    boolean fertig = false;
    do {
      fertig = l.schritt();
    } while (!fertig && !l.feld.fehler);
    return !l.feld.fehler;
  }


  //erst wird versucht mit einfachen menschlichen Methoden das Sudoku zu lösen.
  //Wenn keine Ziffer eindeutig eingetragen werden kann, wird vom Ciomputer systematisch probiert

  public boolean schritt() {
    if (feld.fehler)return false;
    if (feld.fertig())return true;

    if (true) {            //hier false eintragen um menschliche Überlegungen abzuschalten und das Sudoku nur durch probieren zu lösen

      if (durchsucheFelder())return false;
      if (durchsucheZeilen())return false;
      if (durchsucheSpalten())return false;
      if (durchsucheBloecke())return false;
    }

    return probieren();
  }

  private boolean probieren() {
    for (int x=0; x<9; x++) {
      for (int y=0; y<9; y++) {
        if (feld.frei(x, y)) { //es wird zuerst ein freies feld gesucht
          int ziffer = 0;

          while (ziffer < 9) {    //dann wird versucht die erst-beste ziffer dort einzutragen, klappt das nicht wird einfach die nächste Ziffer probiert
            ziffer++;
            if (!feld.setze(x, y, ziffer))continue;
            if (loesbar()) {      //Das sudoku wird mit der neuen Ziffer auf lösbarkeit überprüft
              Grund g = new Grund(x, y, ziffer, 4);
              Gruende.add(g);
              return true;        //wenn es lösbar ist, sind wir fertig
            }
          }                      //sonst wird einfach mit der dächsten ziffer weitergemacht

          //funktioniert an dieser Stelle keine Ziffer ist das Sudoku wohl unlösbar
          feld.setze(x, y, 0);
          Grund abbruchGrund = new Grund(x, y, 0, -5);
          Gruende.add(abbruchGrund);
          feld.fehler = true;
          return false;
        }
      }
    }
    return false;
  }

  //menschliche Methode nummer 1:
  //jedes Feld wird einzeln betrachtet und es wird jeweils überprüft, welche Ziffern an dieser Stelle möglich wären
  //bzw. welche auf jeden Fall nicht gehen, da sie schon in der Reihe Spalte oder im Block vorhanden sind.
  //wenn nur eine Ziffer möglich ist muss diese richtig sein.

  public boolean durchsucheFelder() {
    for (int x=0; x<9; x++) {
      for (int y=0; y<9; y++) {
        if (!feld.frei(x, y))continue;

        ArrayList<Integer> moeglicheZiffern = alleMoeglichkeiten();
        moeglicheZiffern.removeAll(feld.ziffernInBlock(x, y));
        moeglicheZiffern.removeAll(feld.ziffernInSpalte(x));
        moeglicheZiffern.removeAll(feld.ziffernInZeile(y));

        if (moeglicheZiffern.size() == 0) {
          Grund abbruchGrund = new Grund(x, y, 0, -1);
          Gruende.add(abbruchGrund);
          feld.fehler = true;
          return true;
        }

        if (moeglicheZiffern.size() == 1) {
          int ziffer = moeglicheZiffern.get(0);
          feld.setze(x, y, ziffer);
          Grund grundFuerZiffer = new Grund(x, y, ziffer, 0);
          Gruende.add(grundFuerZiffer);
          return true;
        }
      }
    }
    return false;
  }

  //Menschliche Methode nummer 2:
  //Es wird jede Zeile eizeln betrachtet und überprüft welche Ziffern noch fehlen.
  //Fehlt eine Ziffer, die in dieser Zeile nur an einer möglichen Position stehen kann, wird sie an dieser Position eingetragen.


  public boolean durchsucheZeilen() {
    for (int y=0; y<9; y++) {
      for (int ziffer = 1; ziffer <= 9; ziffer++) {
        if (feld.ziffernInZeile(y).contains(ziffer))continue;
        int counter = 0;
        int feldNummer = -1;
        for (int x = 0; x<9; x++) {
          if (feld.zunaechstMoeglich(x, y, ziffer)) {
            counter++;
            feldNummer = x;
          }
        }

        if (counter == 0) {
          Grund abbruchGrund = new Grund(0, y, ziffer, -2);
          Gruende.add(abbruchGrund);
          feld.fehler = true;
          return true;
        }

        if (counter == 1) {
          feld.setze(feldNummer, y, ziffer);
          Grund grundFuerZiffer = new Grund(feldNummer, y, ziffer, 1);
          Gruende.add(grundFuerZiffer);
          return true;
        }
      }
    }
    return false;
  }

  //Menschliche Methode nummer 3:
  //Es wird jede Spalte eizeln betrachtet und überprüft welche Ziffern noch fehlen.
  //Fehlt eine Ziffer, die in dieser Spalte nur an einer möglichen Position stehen kann, wird sie an dieser Position eingetragen.


  public boolean durchsucheSpalten() {
    for (int x=0; x<9; x++) {
      for (int ziffer = 1; ziffer <= 9; ziffer++) {
        if (feld.ziffernInSpalte(x).contains(ziffer))continue;
        int counter = 0;
        int feldNummer = -1;
        for (int y = 0; y<9; y++) {
          if (feld.zunaechstMoeglich(x, y, ziffer)) {
            counter++;
            feldNummer = y;
          }
        }

        if (counter == 0) {
          Grund abbruchGrund = new Grund(x, 0, ziffer, -3);
          Gruende.add(abbruchGrund);
          feld.fehler = true;
          return true;
        }

        if (counter == 1) {
          feld.setze(x, feldNummer, ziffer);
          Grund grundFuerZiffer = new Grund(x, feldNummer, ziffer, 2);
          Gruende.add(grundFuerZiffer);
          return true;
        }
      }
    }
    return false;
  }

  //Menschliche Methode nummer 4:
  //Es wird jeder 3x3 Block eizeln betrachtet und überprüft welche Ziffern noch fehlen.
  //Fehlt eine Ziffer, die in diesem Block nur an einer möglichen Position stehen kann, wird sie an dieser Position eingetragen.


  public boolean durchsucheBloecke() {
    for (int b=0; b<9; b++) {
      for (int ziffer = 1; ziffer <= 9; ziffer++) {
        if (feld.ziffernInBlock(b).contains(ziffer))continue;
        int counter = 0;
        int feldX = -1;
        int feldY = -1;

        int xStart = feld.xKoordinateVonBlock(b);
        int yStart = feld.yKoordinateVonBlock(b);

        for (int x = xStart; x < xStart+3; x++) {
          for (int y = yStart; y< yStart+3; y++) {
            if (feld.zunaechstMoeglich(x, y, ziffer)) {
              counter++;
              feldX = x;
              feldY = y;
            }
          }
        }

        if (counter == 0) {
          Grund abbruchGrund = new Grund(xStart+1, yStart+1, ziffer, -4);
          Gruende.add(abbruchGrund);
          feld.fehler = true;
          return true;
        }

        if (counter == 1) {
          feld.setze(feldX, feldY, ziffer);
          Grund grundFuerZiffer = new Grund(feldX, feldY, ziffer, 3);
          Gruende.add(grundFuerZiffer);
          return true;
        }
      }
    }
    return false;
  }

  ArrayList<Integer> alleMoeglichkeiten() {
    ArrayList<Integer> alles = new ArrayList<Integer>();
    for (int i=1; i<=9; i++) {
      alles.add(i);
    }
    return alles;
  }
}