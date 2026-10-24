module mss.core.error.overflow_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;

class OverflowException : MssException
{
    this(ErrorCode code, const string file = __FILE__, size_t line = __LINE__)
    in (code == ErrorCode.Err11 || code == ErrorCode.Err12)
    {
        if (code == ErrorCode.Err11)
        {
            super("numeric overflow occurred during a computation", code, file, line);
        }
        else
        {
            super("cost counter was exceeded", code, file, line);
        }
    }
}
