module mss.impl.console_output_controller;

import mss.core.component : OutputController;
import mss.core.error : MssException;
import mss.core.matrix : Matrix;
import mss.core.trace : TraceStep;
import std.stdio : write;

class ConsoleOutputController : OutputController
{
    void showMessage(const string text)
    {
        write(text);
    }

    void showError(const MssException exception)
    {
        write(exception.msg);
    }

    void showTraceStep(const TraceStep step)
    {

    }

    void showMatrix(const string name, Matrix matrix)
    {

    }

    void showScalar(const string name, long value)
    {

    }
}
