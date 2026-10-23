module mss.core.matrix.matrix_rules;

import std.exception : enforce;
import mss.core.error : InvalidMatrixException;
import mss.core.matrix.matrix;
import mss.core.matrix.matrix_size;

class MatrixRules
{
    // Pour éviter que cette classe ne soit instanciée
    @disable this() {}

static:
    enum minValue = -99;
    enum maxValue = 99;

    void check(Matrix matrix)
    {
        import std.algorithm : canFind;

        immutable validSizes = [MatrixSize.s2, MatrixSize.s4, MatrixSize.s8, MatrixSize.s16];
        enforce!InvalidMatrixException(validSizes.canFind(matrix.values.length), "invalid number of rows");
        enforce!InvalidMatrixException(validSizes.canFind(matrix.values[0].length), "invalid number of columns");
    }

    void checkValue(long value)
    {
        enforce!InvalidMatrixException(minValue <= value && value <= maxValue, "invalid input value");
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
