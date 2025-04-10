package symbol;

import type.SymbolType;

public class GrammarSymbol {

  private String name;

  private SymbolType type;

  public GrammarSymbol(String name, SymbolType type) {
    this.name = name;
    this.type = type;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public SymbolType getType() {
    return type;
  }

  public void setType(SymbolType type) {
    this.type = type;
  }


  public String toString() {
    return this.getName();
  }


}


