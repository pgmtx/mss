module mss.core.error.invalid_matrix_exception;

import mss.core.error.mss_exception;

class InvalidMatrixException : MssException
{
    this(string message, string file = __FILE__, size_t line = __LINE__)
    {
        super(message, file, line);
    }
}
