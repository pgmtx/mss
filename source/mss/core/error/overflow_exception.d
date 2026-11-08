module mss.core.error.overflow_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;

class OverflowException : MssException
{
    static OverflowException badComputation(const string file = __FILE__, size_t line = __LINE__)
    {
        return new OverflowException("numeric overflow occurred during a computation", ErrorCode.Err11, file, line);
    }

    static OverflowException costCounterExceeded(const string file = __FILE__, size_t line = __LINE__)
    {
        return new OverflowException("cost counter was exceeded", ErrorCode.Err12, file, line);
    }

    private this(const string message, ErrorCode code, const string file = __FILE__, size_t line = __LINE__)
    {
        super(message, code, file, line);
    }
}
