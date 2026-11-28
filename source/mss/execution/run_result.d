module mss.execution.run_result;

import mss.core.trace : ExecutionLog;
import mss.execution.run_status;

const class RunResult
{
    this(const string planName, int planRevision, RunStatus status,
            ExecutionLog log, int lastCompletedStep) pure nothrow
    {
        _planName = planName;
        _planRevision = planRevision;
        _status = status;
        _log = log;
        _lastCompletedStep = lastCompletedStep;
    }

    string getPlanName() const pure nothrow
    {
        return _planName;
    }

    int getPlanRevision() const pure nothrow
    {
        return _planRevision;
    }

    RunStatus getStatus() const pure nothrow
    {
        return _status;
    }

    const(ExecutionLog) getLog() const pure nothrow
    {
        return _log;
    }

    int getLastCompletedStep() const pure nothrow
    {
        return _lastCompletedStep;
    }

private:
    string _planName;
    int _planRevision;
    RunStatus _status;
    ExecutionLog _log;
    int _lastCompletedStep;
}
