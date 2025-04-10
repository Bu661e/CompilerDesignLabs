package lr0;

import symbol.GrammarSymbol;


public class TransitionEdge {

  private GrammarSymbol driverSymbol;

  private ItemSet fromItemSet;

  private ItemSet toItemSet;

  public TransitionEdge(GrammarSymbol driverSymbol, ItemSet fromItemSet, ItemSet toItemSet) {
    this.driverSymbol = driverSymbol;
    this.fromItemSet = fromItemSet;
    this.toItemSet = toItemSet;
  }

  public GrammarSymbol getDriverSymbol() {
    return driverSymbol;
  }

  public void setDriverSymbol(GrammarSymbol driverSymbol) {
    this.driverSymbol = driverSymbol;
  }

  public ItemSet getFromItemSet() {
    return fromItemSet;
  }

  public void setFromItemSet(ItemSet fromItemSet) {
    this.fromItemSet = fromItemSet;
  }

  public ItemSet getToItemSet() {
    return toItemSet;
  }

  public void setToItemSet(ItemSet toItemSet) {
    this.toItemSet = toItemSet;
  }

  @Override
  public String toString() {
    return "I" + fromItemSet.getStateId() + "   "
    +"--[" +driverSymbol.getName() +"]-->"+ "   "
     + toItemSet.getStateId(); 

  }
}
