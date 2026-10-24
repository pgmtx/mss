module mss.core.error.invalid_configuration_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;

class InvalidConfigurationException : MssException
{
    this(const string file = __FILE__, size_t line = __LINE__)
    {
        super("incomplete configuration", ErrorCode.Err06, file, line);
    }
}
