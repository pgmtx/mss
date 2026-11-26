module mss.core.matrix.matrix_rules;

import std.exception : enforce;
import mss.core.error : InvalidMatrixException;
import mss.core.matrix.matrix_size;

class MatrixRules
{
    // Pour éviter que cette classe ne soit instanciée
    @disable this();

static:
    enum minValue = -99;
    enum maxValue = 99;

    void check(const long[][] values)
    {
        import std.algorithm : canFind;

        immutable validSizes = [
            MatrixSize.s2, MatrixSize.s4, MatrixSize.s8, MatrixSize.s16
        ];

        immutable rows = values.length;
        immutable columns = values.length > 0 ? values[0].length : 0;
        immutable isArrayValid = rows == columns && validSizes.canFind(rows);
        enforce(isArrayValid, new InvalidMatrixException(rows, columns));
    }

    unittest
    {
        import std.exception : assertThrown;

        long[][] matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9],];
        assertThrown!InvalidMatrixException(check(matrix));

        matrix = [[1, 2, 3], [4, 5],];
        assertThrown!InvalidMatrixException(check(matrix));
    }

    void checkValue(long value)
    {
        enforce(minValue <= value && value <= maxValue,
                new InvalidMatrixException(value, minValue, maxValue));
    }

    void normalizeName(ref string name)
    {
        import std.string : strip;

        enforce(name != "", "invalid name");
        name = strip(name);
    }

    void checkName(string name)
    {
        normalizeName(name);
    }
}
