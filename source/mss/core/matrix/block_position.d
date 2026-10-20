module mss.core.matrix.block_position;

immutable class BlockPosition
{
    int row;
    int column;

    this(int row, int column)
    {
        this.row = row;
        this.column = column;
    }
}
