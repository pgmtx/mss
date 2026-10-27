module mss.core.matrix.block;

import mss.core.matrix.block_cell;

immutable struct Block
{
    this(long topLeft, long topRight, long bottomLeft, long bottomRight) pure
    {
        _topLeft = topLeft;
        _topRight = topRight;
        _bottomLeft = bottomLeft;
        _bottomRight = bottomRight;
    }

    long get(BlockCell cell) const pure nothrow
    {
        final switch (cell)
        {
        case BlockCell.topLeft:
            return _topLeft;
        case BlockCell.topRight:
            return _topRight;
        case BlockCell.bottomLeft:
            return _bottomLeft;
        case BlockCell.bottomRight:
            return _bottomRight;
        }
    }

    // with est un mot-clé, donc on ne peut pas appeler la méthode ainsi.
    Block withCell(BlockCell cell, long value) const pure
    {
        final switch (cell)
        {
        case BlockCell.topLeft:
            return Block(value, _topRight, _bottomLeft, _bottomRight);
        case BlockCell.topRight:
            return Block(_topLeft, value, _bottomLeft, _bottomRight);
        case BlockCell.bottomLeft:
            return Block(_topLeft, _topRight, value, _bottomRight);
        case BlockCell.bottomRight:
            return Block(_topLeft, _topRight, _bottomLeft, value);
        }
    }

private:
    long _topLeft;
    long _topRight;
    long _bottomLeft;
    long _bottomRight;
}
