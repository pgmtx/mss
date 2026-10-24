module mss.core.error.unreadable_file_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;

class UnreadableFileException : MssException
{
    this(const string filename, const string file = __FILE__, size_t line = __LINE__)
    {
        super("unreachable csv: " ~ filename, ErrorCode.Err02, file, line);
    }
}
