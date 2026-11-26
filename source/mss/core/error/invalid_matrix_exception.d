module mss.core.error.invalid_matrix_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;
import mss.core.matrix.matrix_size : MatrixSize;

import std.format : format;

class InvalidMatrixException : MssException
{
    this(const string message, ErrorCode code, const string file = __FILE__, size_t line = __LINE__)
    {
        super(message, code, file, line);
    }

    this(long value, long min, long max, const string file = __FILE__, size_t line = __LINE__)
    {
        // dfmt off
        immutable message = format(
            "une valeur entre %d et %d était attendue, mais la valeur entrée est %d",
            min, max, value
        );
        // dfmt on
        this(message, ErrorCode.Err01, file, line);
    }

    this(size_t rows, size_t columns, const string file = __FILE__, size_t line = __LINE__)
    {
        this(getErrorMessage(rows, columns), ErrorCode.Err03, file, line);
        _rows = rows;
        _columns = columns;
    }

    private string getErrorMessage(size_t rows, size_t columns) const
    {
        import std.algorithm : map;
        import std.array : join;
        import std.traits : EnumMembers;

        if (rows == columns)
        {
            return "seules les matrices carrées sont prises en charge";
        }

        alias formatSize = size => format("%dx%d", size, size);

        // dfmt off
        const possibleSizes = [EnumMembers!MatrixSize].map!(formatSize).join(", ");
        return format(
            "une matrice de taille %s était attendue, mais une de taille %dx%d a été reçue",
            possibleSizes, rows, columns
        );
        // dfmt on
    }

private:
    size_t _rows;
    size_t _columns;
}
