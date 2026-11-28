module mss.core.error.invalid_plan_exception;

import mss.core.error.error_code;
import mss.core.error.mss_exception;

class InvalidPlanException : MssException
{
    static InvalidPlanException incompatibleDimensions()
    {
        return new InvalidPlanException(ErrorCode.Err07, "dimensions incompatibles");
    }

    static InvalidPlanException unavailableReference()
    {
        return new InvalidPlanException(ErrorCode.Err08, "référence indisponible");
    }

    static InvalidPlanException invalidEntriesKind()
    {
        return new InvalidPlanException(ErrorCode.Err09, "type d'entrées invalide");
    }

    static InvalidPlanException invalidEntriesCount()
    {
        return new InvalidPlanException(ErrorCode.Err09, "nombre d'entrées invalides");
    }

    static InvalidPlanException emptyPlan()
    {
        return new InvalidPlanException(ErrorCode.Err10, "plan vide");
    }

    private this(ErrorCode code, const string message, const string file = __FILE__,
            size_t line = __LINE__)
    in (ErrorCode.Err07 <= code && code <= ErrorCode.Err10)
    {
        super(message, code, file, line);
    }

private:
    int _step;
}
