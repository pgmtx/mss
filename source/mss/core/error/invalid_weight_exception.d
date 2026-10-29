module mss.core.error.invalid_weight_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;

class InvalidWeightException : MssException
{
    this(const string message, const string file = __FILE__, size_t line = __LINE__)
    {
        super(message, ErrorCode.Err05, file, line);
    }
}
