module mss.core.matrix.matrix;

import mss.core.matrix.block;
import mss.core.matrix.block_cell;
import mss.core.matrix.block_position;
import mss.core.matrix.matrix_size;
import mss.core.matrix.matrix_rules;

private long[][] deepCopyArray(const long[][] values)
{
    if (values.length == 0)
    {
        return [];
    }

    // On ne peut pas directement appeler values.dup, car cela
    // copierait seulement le tableau général et non chaque ligne.
    auto result = new long[][](values.length, values[0].length);
    foreach (i, row; values)
    {
        result[i] = row.dup;
    }
    return result;
}

class Matrix
{
    this(MatrixSize size)
    {
        _size = size;
        _values = new long[][](size, size);
    }

    static Matrix of(const long[][] values)
    {
        return new Matrix(values);
    }

    Matrix copy() const
    {
        return new Matrix(_values);
    }

    unittest
    {
        long[][] values = [
            [-27, 64, 5, -81], [38, -12, 93, 7], [-54, 21, -3, 76],
            [9, -68, 44, -19],
        ];

        auto matrix = Matrix.of(values);
        assert(matrix.getBlock(BlockPosition(0, 0)).topLeft == -27);
        values[0][0] = 1;
        assert(matrix.getBlock(BlockPosition(0, 0)).topLeft == -27);
    }

    Matrix withBlock(BlockPosition position, Block block) const
    in
    {
        immutable blocksPerSide = getBlocksPerSide(_size);
        assert(position.row < blocksPerSide);
        assert(position.column < blocksPerSide);
    }
    do
    {
        auto values = deepCopyArray(_values);

        values[2 * position.row][2 * position.column] = block.topLeft;
        values[2 * position.row][2 * position.column + 1] = block.topRight;
        values[2 * position.row + 1][2 * position.column] = block.bottomLeft;
        values[2 * position.row + 1][2 * position.column + 1] = block.bottomRight;

        return Matrix.of(values);
    }

    Block getBlock(BlockPosition position) const
    in
    {
        immutable blocksPerSide = getBlocksPerSide(_size);
        assert(position.row < blocksPerSide);
        assert(position.column < blocksPerSide);
    }
    do
    {
        return Block(_values[2 * position.row][2 * position.column],
                _values[2 * position.row][2 * position.column + 1],
                _values[2 * position.row + 1][2 * position.column],
                _values[2 * position.row + 1][2 * position.column + 1]);
    }

    unittest
    {
        // dfmt off
        const m = Matrix.of([
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [8, 7, 6, 5],
            [4, 3, 2, 1]
        ]);
        // dfmt on

        immutable position = BlockPosition(1, 1);
        immutable expectedBlock = Block(92, 58, 65, 39);

        const m2 = m.withBlock(position, expectedBlock);
        assert(m.getBlock(position) != expectedBlock);
        assert(m2.getBlock(position) == expectedBlock);
    }

    BlockPosition[] getBlockPositions() const
    {
        immutable blocksPerSide = getBlocksPerSide(_size);
        BlockPosition[] result;

        foreach (i; 0 .. blocksPerSide)
        {
            foreach (j; 0 .. blocksPerSide)
            {
                result ~= BlockPosition(i, j);
            }
        }

        return result;
    }

    unittest
    {
        // dfmt off
        const m = Matrix.of([
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [8, 7, 6, 5],
            [4, 3, 2, 1]
        ]);
        // dfmt on

        immutable expected = [
            BlockPosition(0, 0), BlockPosition(0, 1), BlockPosition(1, 0),
            BlockPosition(1, 1)
        ];
        assert(m.getBlockPositions() == expected);
    }

    private this(const long[][] values)
    {
        MatrixRules.check(values);
        _size = fromSide(values.length);
        _values = deepCopyArray(values);
    }

    size_t getRowsCount() const pure nothrow
    {
        return _values.length;
    }

    MatrixSize getSize() const pure nothrow
    {
        return _size;
    }

    size_t getColumnsCount() const pure nothrow
    {
        return _values[0].length;
    }

    // Redéfinit l'opérateur `==`
    bool opEquals(const Matrix other) const pure nothrow
    {
        return _size == other._size && _values == other._values;
    }

    override string toString() const pure
    {
        import std.conv : to;

        string result = "[";
        foreach (i, row; _values)
        {
            if (i > 0)
                result ~= "\n ";
            result ~= to!string(row);
        }
        result ~= ']';
        return result;
    }

private:
    const MatrixSize _size;
    const long[][] _values;
}
