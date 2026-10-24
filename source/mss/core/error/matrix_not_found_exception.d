module mss.core.error.matrix_not_found_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;

class MatrixNotFoundException : MssException
{
    this(const string matrixName, const string file = __FILE__, size_t line = __LINE__)
    {
        super("could not find matrix named " ~ matrixName, ErrorCode.Err14, file, line);
    }
}
