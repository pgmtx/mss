module mss.core.component.output_controller;

import mss.core.component.component;
import mss.core.matrix : Matrix;
import mss.core.error : MssException;
import mss.core.trace : TraceStep;

interface OutputController : Component
{
    void showMessage(const string text);
    void showError(const MssException exception);
    void showTraceStep(TraceStep step);
    void showMatrix(const string name, Matrix matrix);
    void showScalar(const string name, long value);
}
