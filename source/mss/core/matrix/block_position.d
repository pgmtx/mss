module mss.core.matrix.block_position;

immutable struct BlockPosition
{
    size_t row;
    size_t column;

    string label(const string name) const pure
    {
        import std.string : format;

        return format("%s%d%d", name, row + 1, column + 1);
    }
}
