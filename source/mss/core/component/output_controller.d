module mss.core.component.output_controller;

import mss.core.matrix.matrix;
import mss.core.error.mss_exception;
import mss.core.trace.trace_step;

interface OutputController
{
    void showMessage(const string text);
    void showError(const MssException exception);
    void showTraceStep(const TraceStep step);
    void showMatrix(const string name, Matrix matrix);
    void showScalar(const string name, long value);
}
