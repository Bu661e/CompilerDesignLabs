package symbol;

import type.SymbolType;

public class GrammarSymbol {

  // 名字
  private String name;
  // 文法符的类别
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


