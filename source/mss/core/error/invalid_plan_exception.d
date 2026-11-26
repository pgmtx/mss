module mss.core.error.invalid_plan_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;

class InvalidPlanException : MssException
{
    this(ErrorCode code, const string file = __FILE__, size_t line = __LINE__)
    in (ErrorCode.Err07 <= code && code <= ErrorCode.Err10)
    {
        super(_getMessage(code), code, file, line);
    }

private:
    int step;

    string _getMessage(ErrorCode code) const pure nothrow
    {
        switch (code)
        {
        case ErrorCode.Err07:
            return "dimensions incompatibles";
        case ErrorCode.Err08:
            return "référence indisponible";
        case ErrorCode.Err09:
            return "type ou nombre d'entrées invalides";
        default:
            return "plan vide";
        }
    }
}
