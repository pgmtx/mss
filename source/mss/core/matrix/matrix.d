module mss.core.matrix.matrix;

import mss.core.matrix.block;
import mss.core.matrix.block_cell;
import mss.core.matrix.block_position;
import mss.core.matrix.matrix_size;
import mss.core.matrix.matrix_rules;

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

    Matrix withBlock(BlockPosition position, Block block) const
    in
    {
        immutable blocksPerSide = getBlocksPerSide(_size);
        assert(position.row < blocksPerSide);
        assert(position.column < blocksPerSide);
    }
    do
    {
        // On ne peut pas directement appeler _values.dup, car cela
        // copierait seulement le tableau général et non chaque ligne.
        auto values = new long[][](_size, _size);
        foreach (i, row; _values)
        {
            values[i] = row.dup;
        }

        values[2 * position.row][2 * position.column] = block.get(BlockCell.topLeft);
        values[2 * position.row][2 * position.column + 1] = block.get(BlockCell.topRight);
        values[2 * position.row + 1][2 * position.column] = block.get(BlockCell.bottomLeft);
        values[2 * position.row + 1][2 * position.column + 1] = block.get(BlockCell.bottomRight);

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
        const m = Matrix.of([
            [1, 2, 3, 4], [5, 6, 7, 8], [8, 7, 6, 5], [4, 3, 2, 1]
        ]);

        immutable position = BlockPosition(1, 1);
        immutable expectedBlock = Block(92, 58, 65, 39);

        const m2 = m.withBlock(position, expectedBlock);

        assert(m.getBlock(position) != expectedBlock);
        assert(m2.getBlock(position) == expectedBlock);
    }

    BlockPosition[] blockPositions() const
    {
        BlockPosition[] result;

        for (size_t i = 0; i < _size; i += 2)
        {
            for (size_t j = 0; j < _size; j += 2)
            {
                result ~= BlockPosition(i, j);
            }
        }

        return result;
    }

    unittest
    {
        const m = Matrix.of([
            [1, 2, 3, 4], [5, 6, 7, 8], [8, 7, 6, 5], [4, 3, 2, 1]
        ]);

        immutable expected = [
            BlockPosition(0, 0), BlockPosition(0, 2), BlockPosition(2, 0),
            BlockPosition(2, 2)
        ];
        assert(m.blockPositions() == expected);
    }

    private this(const long[][] values)
    in
    {
        import std.exception : assertNotThrown;

        assert(values.length == values[0].length);
        assertNotThrown(fromSide(values.length));
        assertNotThrown(fromSide(values[0].length));
    }
    do
    {
        _size = fromSide(values.length);
        _values = values;
    }

    size_t getRowsCount() const pure nothrow
    {
        return _values.length;
    }

    size_t getColumnsCount() const pure nothrow
    {
        return _values[0].length;
    }

private:
    const MatrixSize _size;
    const long[][] _values;
}
