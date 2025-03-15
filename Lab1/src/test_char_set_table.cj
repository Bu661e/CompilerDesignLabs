package Lab1
import std.collection.*
func testCharSetTable_append(): Unit {
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'z'), (r'A', r'Z')]))
    charSetTable.print()

    
}
func testCharSetTable_range(): Unit {
    charSetTable.range(r'a', r'z')
    charSetTable.range(r'e', r'e')
    charSetTable.print()

}

func testCharSetTable_union_c(): Unit {

    charSetTable.union(r'a', r'z')
    charSetTable.union(r'e', r'e')
    charSetTable.print()
    
}

func testCharSetTable_union_c_charSetId(): Unit {
    charSetTable.range(r'a', r'z')
    charSetTable.union(r'a', r'z')

    charSetTable.union(0, r'a')
    charSetTable.union(1, r'0')
    charSetTable.print()

}

func testCharSetTable_union_charSetId_charSetId(): Unit {
    charSetTable.range(r'a', r'z')
    charSetTable.union(r'a', r'z')
    charSetTable.range(r'a', r'z')
    charSetTable.union(r'A', r'Z')

    charSetTable.union(0, 1)
    charSetTable.union(0, 3)
    charSetTable.print()

}

func testCharSetTable_difference(): Unit {
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'a')]))
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'z')]))
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'z')]))
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'z')]))
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'z')]))


    charSetTable.difference(0, r'a')
    charSetTable.difference(1, r'a')
    charSetTable.difference(2, r'z')
    charSetTable.difference(3, r'f')
    charSetTable.difference(4, r'0')
    charSetTable.print()


}