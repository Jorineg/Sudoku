class Grund {
  int x, y;
  int zahl;
  String grund; 

  public Grund(int x, int y, int zahl, int code) {
    this.x= x;
    this.y = y;

    switch(code) {
    case -5:
      grund = "In dieses Feld wurden testweise alle Ziffern eingesetzt.\nDies führte in allen fällen zu einem Wiederspruch\nbzw. zu einem unlösbaren Sudoku.";
      break;
      
    case -4:
      grund = "In diesem Block kann die " + zahl + " an keiner Stelle mehr stehen!";
      break;

    case -3:
      grund = "In dieser Spalte kann die " + zahl + " an keiner Stelle mehr stehen!";
      break;

    case -2:
      grund = "In dieser Zeile kann die " + zahl + " an keiner Stelle mehr stehen!";
      break;

    case -1:
      grund = "An dieser Stelle kann keine Ziffer mehr stehen!";
      break;

    case 0:
      grund = "Die " + zahl + " ist die einzige Ziffer die man an dieser Stelle eintragen kann.\nAlle anderen Ziffern sind nich möglich, da sie in dieser Zeile,\ndieser Spalte oder in diesem Block bereits vorhanden sind.";
      break;

    case 1:
      grund = "Die " + zahl + " muss an dieser Stelle stehen,\nda sie in dieser Zeile an keiner anderen Stelle stehen kann.";
      break;

    case 2:
      grund = "Die " + zahl + " muss an dieser Stelle stehen,\nda sie in dieser Spalte an keiner anderen Stelle stehen kann.";
      break;

    case 3:
      grund = "Die " + zahl + " muss an dieser Stelle stehen,\nda sie in diesem Block an keiner anderen Stelle stehen kann.";
      break;

    case 4:
      grund = "Durch Probieren wurde herausgefunden das hier eine " + zahl + " stehen muss.\nWenn das Sudoku nicht eindeutig lösbar ist\nkönnten hier vielleicht noch andere Ziffern stehen.";
    }
  }
}