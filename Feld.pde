class Feld {
  private int[][] feld = new int[9][9];
  boolean fehler = false;

  public Feld() {
    allesLeeren();
  }


  public Feld kopieren() {
    Feld kopie = new Feld();
    for (int x=0; x<9; x++) {
      for (int y=0; y<9; y++) {
        kopie.setze(x, y, feld[x][y]);
      }
    }
    kopie.fehler = fehler;
    return kopie;
  }
  
  public void setzeFeld(int[][] neuesFeld){
    for(int x=0; x<9; x++){
      for(int y=0; y<9; y++){
        setze(x,y, neuesFeld[x][y]);
      }
    }
  }


  //feld wird über Konsole ausgegeben
  public void zeigeFeld() {
    println();
    for (int y=0; y<9; y++) {
      for (int x=0; x<9; x++) {
        print(getZifferString(x, y)+" ");
      }
      println();
    }
    println();
  }


  //ist das Sudoku gelöst?
  public boolean fertig() {
    for (int x=0; x<9; x++) {
      for (int y=0; y<9; y++) {
        if (frei(x, y))return false;
      }
    }
    if (istFehler())return false;
    return true;
  }


  //alle Zahlen löschen
  public void allesLeeren() {
    for (int x=0; x<9; x++) {
      for (int y=0; y<9; y++) {
        feld[x][y] = 0;
      }
    }
    fehler = false;
  }


  //ist ein offensichtlicher Fehler im Sudoku?
  //z.B. dass in einer Spalte, zeile oder Block eine Ziffer doppelt auftaucht?
  private boolean istFehler() {
    for (int i=0; i<9; i++) {
      ArrayList<Integer> zeilen = ziffernInZeile(i);
      if (doppelt(zeilen))return true;
    }

    for (int i=0; i<9; i++) {
      ArrayList<Integer> spalten = ziffernInSpalte(i);
      if (doppelt(spalten))return true;
    }

    for (int i=0; i<9; i++) {
      ArrayList<Integer> bloecke = ziffernInBlock(i);
      if (doppelt(bloecke))return true;
    }
    return false;
  }


  //kommt eine Ziffer in einer liste doppelt vor?
  private boolean doppelt(ArrayList<Integer> liste) {
    for (int i=0; i<liste.size()-1; i++) {
      for (int j = i+1; j<liste.size(); j++) {
        if (liste.get(i)==liste.get(j))return true;
      }
    }
    return false;
  }


  //gibt String der die Ziffer des Feldes enthält zurück
  public String getZifferString(int x, int y) {
    if (frei(x, y))return " ";
    return feld[x][y]+"";
  }


  //nummer eingeben
  //wenn sie offensichtlich nicht geht wird sie nicht eingegeben
  public boolean setze(int x, int y, int nummer) {
    if (nummer >= 1 && nummer <= 9) {
      feld[x][y] = nummer;
      if (istFehler())feld[x][y] = 0;
    } else {
      feld[x][y] = 0;
    }
    fehler = false;
    if (frei(x, y))return false;
    return true;
  }



  //ist das Feld leer?
  public boolean frei(int x, int y) {
    return feld[x][y] == 0;
  }


  //gebe liste mit allen Ziffern in Zeile zurück
  public ArrayList<Integer> ziffernInZeile(int zeile) {
    ArrayList<Integer> ziffern = new ArrayList<Integer>(9);
    for (int x=0; x<9; x++) {
      if (!frei(x, zeile))ziffern.add(feld[x][zeile]);
    }
    return ziffern;
  } 


  //gebe liste mit allen Ziffern in Spalte zurück
  public ArrayList<Integer> ziffernInSpalte(int spalte) {
    ArrayList<Integer> ziffern = new ArrayList<Integer>(9);
    for (int y=0; y<9; y++) {
      if (!frei(spalte, y))ziffern.add(feld[spalte][y]);
    }
    return ziffern;
  }


  //gebe liste mit allen Ziffern in Block zurück
  public ArrayList<Integer> ziffernInBlock(int block) {
    ArrayList<Integer> ziffern = new ArrayList<Integer>(9);
    int xStart = xKoordinateVonBlock(block);
    int yStart = yKoordinateVonBlock(block);

    for (int x = xStart; x < xStart+3; x++) {
      for (int y = yStart; y < yStart+3; y++) {
        if (!frei(x, y))ziffern.add(feld[x][y]);
      }
    }
    return ziffern;
  }

  public int xKoordinateVonBlock(int block) {
    return (block%3)*3;
  }

  public int yKoordinateVonBlock(int block) {
    return ((int)(block/3))*3;
  }

  public ArrayList<Integer> ziffernInBlock(int x, int y) {
    int block = blockDerKoordinaten(x, y);
    return ziffernInBlock(block);
  }

  public boolean zunaechstMoeglich(int x, int y, int ziffer) {
    if (feld[x][y] == ziffer)return true;
    if (!frei(x, y))return false;

    boolean inZeile = ziffernInZeile(y).contains(ziffer);
    boolean inSpalte = ziffernInSpalte(x).contains(ziffer);
    boolean inBlock = ziffernInBlock(x, y).contains(ziffer);
    return (!inZeile) && (!inSpalte) && (!inBlock);
  }

  private int blockDerKoordinaten(int x, int y) {
    return ((int)(y/3))*3 + ((int)(x/3));
  }
}