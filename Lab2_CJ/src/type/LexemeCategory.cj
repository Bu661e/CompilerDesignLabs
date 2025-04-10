package Lab2_CJ.type

enum LexemeCategory {
    // 空字符
    EMPTY |
    // 整数常量
    INTEGER_CONST |
    // 实数常量
    FLOAT_CONST |
    // 科学计数法常量
    SCIENTIFIC_CONST |
    // 数值运算词
    NUMERIC_OPERATOR |
    // 注释
    NOTE |
    // 字符串常量
    STRING_CONST |
    // 空格常量
    SPACE_CONST |
    // 比较运算词
    COMPARE_OPERATOR |
    // 标识符
    IDENTIFIER |
    // 关键字
    KEYWORD |
    // 界符
    DELIMITER
}