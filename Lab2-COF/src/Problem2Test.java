
import generator.GeneratorLR;
import lr0.ItemSet;
import lr0.LR0Item;
import type.ItemCategoy;



public class Problem2Test {
  public static void main(String[] args) {
    System.out.println("Problem2Test");
    Problem2Test test = new Problem2Test();

    // test.TestGetClosure();
    // test.TestExhaustTransition();
    // test.TestGetDFA();
    // test.TestIsSLR1();
    test.TestGetCell();
    
  }

  public void TestGetClosure() {
    Grammar grammar = new Grammar("lr");

    ItemSet itemSet = grammar.addItemSet();
    grammar.addLr0Item(itemSet, new LR0Item(grammar.start, grammar.start.getpProductionTable().get(0), 0, ItemCategoy.CORE));
    grammar.getClosure(itemSet);

    grammar.printItemSets();

  }
  
  
  
  public void TestExhaustTransition() {
    Grammar grammar = new Grammar("lr");

    // I0
    ItemSet oriItemSet = grammar.addItemSet();
    grammar.addLr0Item(oriItemSet, new LR0Item(grammar.start, grammar.start.getpProductionTable().get(0), 0, ItemCategoy.CORE));
    grammar.getClosure(oriItemSet);

    grammar.exhaustTransition(oriItemSet);

    grammar.printItemSets();

  }

  
  public void TestGetDFA() {
    Grammar grammar = new Grammar("lr");

    ItemSet oriItemSet = grammar.addItemSet();

    grammar.addLr0Item(oriItemSet, new LR0Item(grammar.start, grammar.start.getpProductionTable().get(0), 0, ItemCategoy.CORE));
    
    grammar.getClosure(oriItemSet);

    grammar.getDFA(oriItemSet);
    
    grammar.printDFA();

  }


  public void TestIsSLR1() {

    Grammar grammar = new Grammar("slr");
    grammar.generateFirstOfNonTerminal();
    grammar.generateFollowOfNonTerminal();
    grammar.generateFollowDependent();

    ItemSet oriItemSet = grammar.addItemSet();

    grammar.addLr0Item(oriItemSet, new LR0Item(grammar.start, grammar.start.getpProductionTable().get(0), 0, ItemCategoy.CORE));
    
    grammar.getClosure(oriItemSet);

    grammar.getDFA(oriItemSet);

    grammar.printDFA();

    System.out.println(grammar.isSLR1()? "是SLR(1)文法" : "不是SLR(1)文法");

  }
  

  public void TestGetCell() {
    Grammar grammar = new Grammar("lr");
    grammar.generateFirstOfNonTerminal();

    grammar.generateFollowOfNonTerminal();

    grammar.generateFollowDependent();




    ItemSet oriItemSet = grammar.addItemSet();

    grammar.addLr0Item(oriItemSet, new LR0Item(grammar.start, grammar.start.getpProductionTable().get(0), 0, ItemCategoy.CORE));
    
    grammar.getClosure(oriItemSet);

    grammar.getDFA(oriItemSet);

    grammar.printNonTerminalSymbols();

    grammar.printDFA();

    System.out.println(grammar.isSLR1()? "是SLR(1)文法" : "不是SLR(1)文法");
    System.out.println();

    // 语法分析表
    GeneratorLR.getCell(grammar.dfa);

    System.out.println("ACTION表:");
    System.out.println(GeneratorLR.getpActionCellTable());
    System.out.println();
    System.out.println("GOTO表:");
    System.out.println(GeneratorLR.getpGotoCellTable());
  }

}
