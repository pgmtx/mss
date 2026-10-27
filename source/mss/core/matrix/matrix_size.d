module mss.core.matrix.matrix_size;

enum MatrixSize
{
    s2 = 2,
    s4 = 4,
    s8 = 8,
    s16 = 16
}

size_t getSide(MatrixSize size) pure
{
    return size;
}

size_t getBlocksPerSide(MatrixSize size) pure
{
    return size / 2;
}

size_t getBlockCount(MatrixSize size) pure
{
    return size * size / 4;
}

MatrixSize fromSide(size_t n)
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
