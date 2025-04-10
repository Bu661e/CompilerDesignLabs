package symbol;

import type.LexemeCategory;
import type.SymbolType;

public class TerminalSymbol extends GrammarSymbol {

  private LexemeCategory category;

  public TerminalSymbol(String name, SymbolType type) {
    super(name, type);
  }


  public String printInfo() {

    String ans =  this.getName() + "{" +
                  "\ntype=" + getType() +
                  ", \ncategory=" + category +
                  '}';
    return ans;

  }

  public LexemeCategory getCategory() {
    return category;
  }

  public void setCategory(LexemeCategory category) {
    this.category = category;
  }


}
