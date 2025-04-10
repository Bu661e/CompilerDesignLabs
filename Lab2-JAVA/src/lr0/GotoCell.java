package lr0;


public class GotoCell {

  private int stateId;

  private String nonTerminalSymbolName;

  private int nextStateId;

  public GotoCell(int stateId, String nonTerminalSymbolName, int nextStateId) {
    this.stateId = stateId;
    this.nonTerminalSymbolName = nonTerminalSymbolName;
    this.nextStateId = nextStateId;
  }

  @Override
  public String toString() {
    return "[" 
        + "I" + stateId +
        ", " + "g" + nextStateId +
        ", " + nonTerminalSymbolName +
        ']' + '\n';
  }
}
