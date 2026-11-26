module mss.core.matrix.matrix_size;

enum MatrixSize
{
    s2 = 2,
    s4 = 4,
    s8 = 8,
    s16 = 16
}

size_t getSide(MatrixSize size) pure nothrow
{
    return size;
}

size_t getBlocksPerSide(MatrixSize size) pure nothrow
{
    return size / 2;
}

size_t getBlockCount(MatrixSize size) pure nothrow
{
    return size * size / 4;
}

MatrixSize fromSide(size_t n)
{
    import std.conv : to, ConvException;
    import std.format : format;
    import mss.core.error : InvalidMatrixException, ErrorCode;

    try
    {
        return to!MatrixSize(n);
    }
    catch (ConvException)
    {
        immutable message = format("impossible de convertir la valeur %d en MatrixSize", n);
        throw new InvalidMatrixException(message, ErrorCode.Err03);
    }
}
