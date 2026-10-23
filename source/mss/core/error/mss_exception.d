module mss.core.error.mss_exception;

class MssException : Exception
{
    this(string message, string file = __FILE__, size_t line = __LINE__) {
        super(message, file, line);
    }
}
