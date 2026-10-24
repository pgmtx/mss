module mss.core.error.duplicate_name_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;

class DuplicateNameException : MssException
{
    this(const string matrixName, const string file = __FILE__, size_t line = __LINE__)
    {
        super("duplicate name found: " ~ matrixName, ErrorCode.Err04, file, line);
    }
}
