module mss.impl.console_output_controller;

import mss.core.component : OutputController;
import mss.core.error : MssException;
import mss.core.matrix : Matrix;
import mss.core.trace : TraceStep;
import mss.core.weight : ComponentModel;
import std.stdio : write, writeln, writefln;

class ConsoleOutputController : OutputController
{
    this(ComponentModel model)
    {
        _model = model;
    }

    override void showMessage(const string text)
    {
        write(text);
    }

    override void showError(const MssException exception)
    {
        write(exception.msg);
    }

    override void showTraceStep(const TraceStep step)
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

    override void showMatrix(const string name, const Matrix matrix)
    {
        // placeholder
    }

    override void showScalar(const string name, long value)
    {
        // placeholder
    }

    override ComponentModel getModel() const
    {
        return _model;
    }

    private ComponentModel _model;
}
