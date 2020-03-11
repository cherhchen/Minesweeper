import de.bezier.guido.*;
public final static int NUM_ROWS = 18;
public final static int NUM_COLS = 18; 
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> ();; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(395, 395);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
   buttons = new MSButton[NUM_ROWS][NUM_COLS]; 
   for (int r = 0; r < buttons.length; r++) {
    for (int c = 0; c < buttons[r].length; c++) {
        buttons[r][c] = new MSButton(r,c);
    }
   }
    
    setMines();
}
public void setMines()
{
    //your code
    for (int i = 0; i < 40; i++) {
        int r = (int)(Math.random()*NUM_ROWS);
        int c = (int)(Math.random()*NUM_COLS);
        if (!mines.contains(buttons[r][c])) {
            mines.add(buttons[r][c]);
            //System.out.println(r + ", " + c);
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!mines.contains(buttons[r][c]) && buttons[r][c].clicked == false) {
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    //your code here
    buttons[7][4].setLabel("Y");
    buttons[7][5].setLabel("O");
    buttons[7][6].setLabel("U");
    buttons[7][7].setLabel(" ");
    buttons[7][8].setLabel("L");
    buttons[7][9].setLabel("O");
    buttons[7][10].setLabel("S");
    buttons[7][11].setLabel("E");
    buttons[7][12].setLabel("!");
    for (int i = 0; i < mines.size(); i++) {
      mines.get(i).clicked = true;
    }
}
public void displayWinningMessage()
{
    //your code here
    buttons[7][4].setLabel("Y");
    buttons[7][5].setLabel("O");
    buttons[7][6].setLabel("U");
    buttons[7][7].setLabel(" ");
    buttons[7][8].setLabel("W");
    buttons[7][9].setLabel("O");
    buttons[7][10].setLabel("N");
    buttons[7][11].setLabel("!");
}
public boolean isValid(int r, int c)
{
    //your code here
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
        return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for (int r = row-1; r <= row+1; r++) {
        for (int c = col-1; c <= col+1; c++) {
            if (isValid(r,c) == true && mines.contains(buttons[r][c])) {
                numMines++;
            }
        }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if (mouseButton == RIGHT) {
            flagged = !flagged;
            if (flagged == false) {
                clicked = false;
            }
        }
        else if (mines.contains(this)) {
            displayLosingMessage();
            noLoop();
        }
        else if (countMines(myRow,myCol) > 0) {
            setLabel(countMines(myRow,myCol));
        }
        else {
            for (int r = myRow-1; r <= myRow+1; r++) {
                for (int c = myCol-1; c <= myCol+1; c++) {
                    if (isValid(r,c) == true && buttons[r][c].clicked == false) {
                        buttons[r][c].mousePressed();
                    }
                }
            }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 75, 237, 21 );
        else 
            fill( 32, 81, 92 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
