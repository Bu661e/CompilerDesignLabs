package lr0;

// import com.sun.org.apache.bcel.internal.generic.GOTO;
import java.util.ArrayList;

import symbol.GrammarSymbol;


public class DFA {
  // 开始项集
  private ItemSet startupItemSet;
  // 变迁边表
  private ArrayList<TransitionEdge> pEdgeTable;

  public DFA(){}
  public DFA(ItemSet startupItemSet) {
    this.startupItemSet = startupItemSet;
    pEdgeTable = new ArrayList<>();
  }

  public void addEdges(ArrayList<TransitionEdge> edges) {
    pEdgeTable.addAll(edges);
  }

  public ItemSet findNextSet(ItemSet from, GrammarSymbol symbol) {
    for (TransitionEdge edge: pEdgeTable) {
      if (edge.getFromItemSet() == from && edge.getDriverSymbol() == symbol) {
        return edge.getToItemSet();
      }
    }
    return null;
  }


  public String toString() {
    String ans = "DFA:\n";
    ans += "startupItemSet:" + startupItemSet.getStateId() + "\n";
    ans += "edgeTable:\n";
    for (TransitionEdge edge: pEdgeTable) {
      ans += edge.toString() + "\n";
    }

    return ans;
  }

  public void printInfo() {
    System.out.println(this.toString());
  }
}
