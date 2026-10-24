module mss.core.error.mss_exception;

import mss.core.error.error_code;

class MssException : Exception
{
    this(const string message, ErrorCode code, const string file = __FILE__, size_t line = __LINE__)
    {
        super(message, file, line);
        _code = code;
    }

    ErrorCode getCode() const pure nothrow
    {
        return _code;
    }

private:
    ErrorCode _code;
}
