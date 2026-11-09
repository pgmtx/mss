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
        writefln("%s | %s | %s", step.computer, step.label, step.computation.context);
        foreach (i, result; step.results)
        {
            writefln("Résultat %d : %s", i + 1, result);
        }
        writefln("Calcul UT%d : +%d | Cumul après calcul : %d",
                step.computation.number, step.computation.weight, step.computation.total);
        writefln("Affichage du suivi SOR%d : +%d | Cumul : %d",
                step.display.number, step.display.weight, step.display.total);
    }

    void showMatrix(const string name, Matrix matrix)
    {

    }

    void showScalar(const string name, long value)
    {

    }
}
