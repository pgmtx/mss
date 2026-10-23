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

    string label(const string name) const pure
    {
        import std.string : format;

        return format("%s%d%d", name, row + 1, column + 1);
    }
}
