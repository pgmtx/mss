module mss.core.component.output_controller;

import mss.core.matrix.matrix;
import mss.core.error.mss_exception;
import mss.core.trace.trace_step;

interface OutputController
{
    void showMessage(string text);
    void showError(MssException exception);
    void showTraceStep(TraceStep step);
    void showMatrix(string name, Matrix matrix);
    void showScalar(string name, long value);
}
