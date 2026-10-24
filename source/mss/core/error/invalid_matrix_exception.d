module mss.core.error.invalid_matrix_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;

class InvalidMatrixException : MssException
{
    this(const string file = __FILE__, size_t line = __LINE__)
    {
        super("invalid value entered", ErrorCode.Err01, file, line);
        _row = -1;
        _column = -1;
    }

    this(int row, int column, const string file = __FILE__, size_t line = __LINE__)
    {
        super("invalid shape or size", ErrorCode.Err03, file, line);
        _row = row;
        _column = column;
    }

private:
    int _row;
    int _column;
}
