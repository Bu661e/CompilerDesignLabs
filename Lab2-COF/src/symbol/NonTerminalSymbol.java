package symbol;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

import type.SymbolType;


public class NonTerminalSymbol extends GrammarSymbol{
  /**
   * 非终结符
   */

  // 有关非终结符构成的产生式
  private ArrayList<Production> pProductionTable;
  // 产生式的个数
  private int numOfProduction;
  // 非终结符的 FIRST 函数值
  private Set<TerminalSymbol> pFirstSet;
  // 非终结符的 FOLLOW 函数值
  private Set <TerminalSymbol> pFollowSet;
  // 求非终结符的 FOLLOW 函数值时，存放所依赖的非终结符。
  private Set <NonTerminalSymbol> pDependentSetInFollow;

  public NonTerminalSymbol(String name, SymbolType type) {
    super(name, type);
    pProductionTable = new ArrayList<>();
    numOfProduction = 0;
    pFirstSet = new HashSet<>();
    pFollowSet = new HashSet<>();
    pDependentSetInFollow = new HashSet<>();
  }
  
  public void removeProduction(Production production) {
    pProductionTable.remove(production);
    numOfProduction --;
  }

  public void addProduction(Production production) {
    pProductionTable.add(production);
    numOfProduction ++;
  }

  public void addDependentSetFollow(NonTerminalSymbol symbol) {
    if (symbol.getName() != getName()) {
      pDependentSetInFollow.add(symbol);
    }
  }

  public void addFollowSet(Set<TerminalSymbol> follow) {
    pFollowSet.addAll(follow);
  }

  public void addFollow(TerminalSymbol follow) {
    pFollowSet.add(follow);
  }

  public Set<TerminalSymbol> removeEpsilon() {
    Set<TerminalSymbol> first= new HashSet<>(pFirstSet);
    for (TerminalSymbol symbol: first) {
      if (symbol.getName().equals("ε")) {
        first.remove(symbol);
        break;
      }
    }
    return first;
  }

  public Boolean containsEpsilon(){
    for (TerminalSymbol symbol: pFirstSet) {
      if (symbol.getName().equals("ε")) {
        return true;
      }
    }
    return false;
  }

  public void addFollowDependent() {
    for (NonTerminalSymbol symbol: pDependentSetInFollow) {
      addFollowSet(symbol.pFollowSet);
    }
  }

  public  String printInfo(){

    String ans = this.getName() + ":" +
    "\n\tProductions = " + pProductionTable +
    ", \n\tnumOfProductions = " + numOfProduction +
    ", \n\tFirstSet = " + this.pFirstSet +
    ", \n\tFollowSet = " + this.pFollowSet +
    ", \n\tDependentSetInFollow=" + this.pDependentSetInFollow;
    System.out.println(ans);  
    return ans;

  }



  public ArrayList<Production> getpProductionTable() {
    return pProductionTable;
  }

  public void setpProductionTable(ArrayList<Production> pProductionTable) {
    this.pProductionTable = pProductionTable;
  }

  public int getNumOfProduction() {
    return numOfProduction;
  }

  public void setNumOfProduction(int numOfProduction) {
    this.numOfProduction = numOfProduction;
  }

  public Set<TerminalSymbol> getpFirstSet() {
    return pFirstSet;
  }

  public void setpFirstSet(Set<TerminalSymbol> pFirstSet) {
    this.pFirstSet = pFirstSet;
  }

  public Set<TerminalSymbol> getpFollowSet() {
    return pFollowSet;
  }

  public void setpFollowSet(Set<TerminalSymbol> pFollowSet) {
    this.pFollowSet = pFollowSet;
  }

  public Set<NonTerminalSymbol> getpDependentSetInFollow() {
    return pDependentSetInFollow;
  }

  public void setpDependentSetInFollow(Set<NonTerminalSymbol> pDependentSetInFollow) {
    this.pDependentSetInFollow = pDependentSetInFollow;
  }


}
