package lr0;


public class ActionCell {
  private int stateId;

  private String terminalSymbolName;

  private ActionCategory type ;

  private int id;

  public ActionCell(int stateId, String terminalSymbolName, ActionCategory type, int id) {
    this.stateId = stateId;
    this.terminalSymbolName = terminalSymbolName;
    this.type = type;
    this.id = id;
  }

  @Override
  public String toString() {
    return "[" 
        + "I" + stateId +
        ", " + type + id +
        ", " + terminalSymbolName +
        ']' + '\n';
  }
}
