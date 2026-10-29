module mss.impl.console_output_controller;

import mss.core.component : OutputController;
import mss.core.error : MssException;
import mss.core.matrix : Matrix;
import mss.core.trace : TraceStep;
import std.stdio : write, writeln, writefln;

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
        writefln("%s | %s | %s", step.computer, step.label, "");
        writeln("Résultat P : ", step.results[0]);
    }

    void showMatrix(const string name, Matrix matrix)
    {

    }

    void showScalar(const string name, long value)
    {

    }
}
