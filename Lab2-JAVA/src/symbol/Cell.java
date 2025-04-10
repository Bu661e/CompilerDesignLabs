package symbol;


public class Cell {
  private NonTerminalSymbol nonTerminalSymbol;
  private TerminalSymbol terminalSymbol;
  private Production production;

  public Cell(NonTerminalSymbol nonTerminalSymbol, TerminalSymbol terminalSymbol,
      Production production) {
    this.nonTerminalSymbol = nonTerminalSymbol;
    this.terminalSymbol = terminalSymbol;
    this.production = production;
  }

  public String toString() {
    return "[" 
        + nonTerminalSymbol.getName() +
        ", " + production +
        ", " + terminalSymbol.getName() +
        ']' + '\n';
  }
}
