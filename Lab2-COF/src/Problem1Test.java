import java.util.ArrayList;
import java.util.Arrays;

import symbol.NonTerminalSymbol;
import symbol.TerminalSymbol;

import type.SymbolType;


public class Problem1Test {
  public static void main(String[] args) {

    Problem1Test test = new Problem1Test();

    // test.TestLeftRecursion();
    // test.TestleftCommonFactor();
    // test.TestfirstOfProduction();
    // test.TestfirstOfSymbol();
    // test.TestFollowOfSymbol();
    // test.TestIsLL1();
    test.TestParseTable();
  }

// test 左递归
  public void TestLeftRecursion() {
    Grammar myGrammar = new Grammar("ll");
    // 非终结符A和终结符a,b
    NonTerminalSymbol A = (NonTerminalSymbol)myGrammar.addSymbol("A", SymbolType.NONTERMINAL);
    TerminalSymbol a = (TerminalSymbol)myGrammar.addSymbol("a", SymbolType.TERMINAL);
    TerminalSymbol b = (TerminalSymbol)myGrammar.addSymbol("b", SymbolType.TERMINAL);

    // 产生式A=>Aa和A=>b
    myGrammar.addProduction(A, new ArrayList<>(Arrays.asList(A, a)));
    myGrammar.addProduction(A, new ArrayList<>(Arrays.asList(b)));
    
    // 判断左递归和消除左递归

    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();

    System.out.println("==============================");
    myGrammar.leftRecursion(A);

    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();
  }


// test 左公因子

  public void TestleftCommonFactor() {

    Grammar myGrammar = new Grammar("ll");
    // 非终结符A和终结符a,b,c
    NonTerminalSymbol A  =  (NonTerminalSymbol)myGrammar.addSymbol("A", SymbolType.NONTERMINAL);
    TerminalSymbol    a  =  (TerminalSymbol)myGrammar.addSymbol("a", SymbolType.TERMINAL);
    TerminalSymbol    b  =  (TerminalSymbol)myGrammar.addSymbol("b", SymbolType.TERMINAL);
    TerminalSymbol    c  =  (TerminalSymbol)myGrammar.addSymbol("c", SymbolType.TERMINAL);
    // 产生式A=>ab和A=>ac
    myGrammar.addProduction(A, new ArrayList<>(Arrays.asList(a, b)));
    myGrammar.addProduction(A, new ArrayList<>(Arrays.asList(a, c)));

    // 判断左公因子和提取左公因子
    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();

    System.out.println("==============================");
    myGrammar.leftCommonFactor(A);

    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();
  }

// 这里求的只是非终结符的first集合，没有求终结符的first集合
  public void TestfirstOfSymbol() {

    Grammar myGrammar = new Grammar("ll");

    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();

    System.out.println("==============================");
    myGrammar.generateFirstOfNonTerminal();;

    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();

  }

  public void TestfirstOfProduction() {

    Grammar myGrammar = new Grammar("ll");

    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();

    System.out.println("==============================");
    myGrammar.generateFirstOfProduction();

    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();

  }

  public void TestFollowOfSymbol() {
    Grammar myGrammar = new Grammar("ll");

    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();

    System.out.println("==============================");
    // 求FIRST集合
    myGrammar.generateFirstOfNonTerminal();
    // 求FOLLOW集合
    myGrammar.generateFollowOfNonTerminal();
    // 求FOLLOW集合的依赖
    myGrammar.generateFollowDependent();


    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();

  }
  
  public void TestIsLL1() {
    Grammar myGrammar = new Grammar("ll");

    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();

    System.out.println("==============================");

    myGrammar.generateFirstOfNonTerminal();

    myGrammar.generateFollowOfNonTerminal();

    myGrammar.generateFollowDependent();

    myGrammar.isLL1();

    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();
  }


  
  public void TestParseTable() {
    Grammar myGrammar = new Grammar("ll");

    myGrammar.printNonTerminalSymbols();
    myGrammar.printProductions();

    System.out.println("==============================");

    myGrammar.generateFirstOfNonTerminal();

    myGrammar.generateFollowOfNonTerminal();

    myGrammar.generateFollowDependent();

    myGrammar.generateParseTable();

    myGrammar.printLL1Table();


  }
}
