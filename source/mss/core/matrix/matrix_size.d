module mss.core.matrix.matrix_size;

enum MatrixSize
{
    s2 = 2,
    s4 = 4,
    s8 = 8,
    s16 = 16
}

int getSide(MatrixSize size)
{
    return size;
}

int getBlocksPerSide(MatrixSize size)
{
    return size / 2;
}

int getBlockCount(MatrixSize size)
{
    return size * size / 4;
}

MatrixSize fromSide(int n)
{
    import std.conv : to, ConvException;
    import mss.core.error.invalid_matrix_exception;

    try
    {
        return to!MatrixSize(n);
    }
    catch (ConvException e)
    {
        throw new InvalidMatrixException("invalid size : " ~ to!string(n));
    }
}
