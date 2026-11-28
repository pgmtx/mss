module mss.core.matrix.block;

import mss.core.matrix.block_cell;

struct Block
{
    long topLeft;
    long topRight;
    long bottomLeft;
    long bottomRight;

    this(long topLeft, long topRight, long bottomLeft, long bottomRight) pure
    {
        this.topLeft = topLeft;
        this.topRight = topRight;
        this.bottomLeft = bottomLeft;
        this.bottomRight = bottomRight;
    }

    long get(BlockCell cell) const pure nothrow
    {
        final switch (cell)
        {
        case BlockCell.topLeft:
            return topLeft;
        case BlockCell.topRight:
            return topRight;
        case BlockCell.bottomLeft:
            return bottomLeft;
        case BlockCell.bottomRight:
            return bottomRight;
        }
    }

    // with est un mot-clé, donc on ne peut pas appeler la méthode ainsi.
    Block withCell(BlockCell cell, long value) const pure
    {
        final switch (cell)
        {
        case BlockCell.topLeft:
            return Block(value, topRight, bottomLeft, bottomRight);
        case BlockCell.topRight:
            return Block(topLeft, value, bottomLeft, bottomRight);
        case BlockCell.bottomLeft:
            return Block(topLeft, topRight, value, bottomRight);
        case BlockCell.bottomRight:
            return Block(topLeft, topRight, bottomLeft, value);
        }
    }

    string toString() const
    {
        import std.conv : to;

        return to!string([topLeft, topRight, bottomLeft, bottomRight]);
    }
}
