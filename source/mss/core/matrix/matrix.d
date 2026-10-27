module mss.core.matrix.matrix;

import mss.core.matrix.matrix_size;

const class Matrix
{
    this(const long[][] values)
    in
    {
        import std.exception : assertNotThrown;

        assertNotThrown(fromSide(cast(int) values.length));
        assertNotThrown(fromSide(cast(int) values[0].length));
        assert(values.length == values[0].length);
    }
    do
    {
        size = fromSide(cast(int) values.length);
        this.values = values;
    }

    MatrixSize size;
    long[][] values;
}
