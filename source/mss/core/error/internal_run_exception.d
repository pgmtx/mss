module mss.core.error.internal_run_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;

class InternalRunException : MssException
{
    this(const string message, const string file = __FILE__, size_t line = __LINE__)
    {
        super(message, ErrorCode.Err14, file, line);
    }
}
