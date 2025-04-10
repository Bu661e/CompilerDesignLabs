package symbol;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;


public class Production {


  private int productionId;
  private int bodySize = 0;

  private GrammarSymbol left = new GrammarSymbol("not set", null);

  private ArrayList<GrammarSymbol> pBodySymbolTable  = new ArrayList<>();

  private Set<TerminalSymbol> pFirstSet = new HashSet<>() ;

  public static int idNum = 0;

  public Production() {
    productionId = idNum++;
  }

  public Production(GrammarSymbol gs, ArrayList<GrammarSymbol> al_gs) {
    productionId = idNum++;

    left = gs;
    pBodySymbolTable = al_gs;
    bodySize = al_gs.size();

  }

  public int getProductionId() {
    return productionId;
  }

  public void setProductionId(int productionId) {
    this.productionId = productionId;
  }

  public GrammarSymbol getLeft() {
    return left;
  }

  public void setLeft(GrammarSymbol gs) {
    this.left = gs;
  }

  public int getBodySize() {
    return bodySize;
  }

  public void setBodySize(int bodySize) {
    this.bodySize = bodySize;
  }

  public ArrayList<GrammarSymbol> getpBodySymbolTable() {
    return pBodySymbolTable;
  }

  public void setpBodySymbolTable(ArrayList<GrammarSymbol> pBodySymbolTable) {
    this.pBodySymbolTable = pBodySymbolTable;
  }

  public Set<TerminalSymbol> getpFirstSet() {
    return pFirstSet;
  }

  public void setpFirstSet(Set<TerminalSymbol> pFirstSet) {
    this.pFirstSet = pFirstSet;
  }

  public void addSymbolAtLast(GrammarSymbol symbol) {
    pBodySymbolTable.add(symbol);
    bodySize ++;
  }

  public void removeFirstSymbol(GrammarSymbol symbol) {
    pBodySymbolTable.remove(symbol);
    bodySize --;
  }

  public Boolean isEpsilon() {
    if (bodySize == 1 && pBodySymbolTable.get(0).getName().equals("ε")) {
      return true;
    }
    else {
      return false;
    }
  }

  @Override
  public String toString() {
    String s = new String();
    for (GrammarSymbol symbol: pBodySymbolTable) {
      s += symbol.getName();
    }
    // return "(" + productionId + ") " + left.getName() + "-> " + s;
    return "(" + productionId + ") " +  "-> " + s;
  }

  public void printInfo() {
    String ans = toString() + "\t" + pFirstSet;
    System.out.println(ans);
  }


  
}

