module mss.execution.run_result;

import mss.core.trace : ExecutionLog;
import mss.execution.run_status;

class RunResult
{
private:
    string _planName;
    int _planRevision;
    RunStatus _status;
    ExecutionLog _log;
    int _lastCompletedStep;
}
