module mss.execution.run_result;

import mss.core.trace : ExecutionLog;
import mss.core.error : MssException;
import mss.execution.run_status;
import optional : Optional;

struct RunResult
{
    this(const string planName, const string computerName, int planRevision,
            RunStatus status, ExecutionLog log, int lastCompletedStep) pure nothrow
    {
        _planName = planName;
        _computerName = computerName;
        _planRevision = planRevision;
        _status = status;
        _log = log;
        _lastCompletedStep = lastCompletedStep;
    }

    this(const string planName, const string computerName, int planRevision,
            RunStatus status, ExecutionLog log, int lastCompletedStep, MssException exception) pure nothrow
    {
        _planName = planName;
        _computerName = computerName;
        _planRevision = planRevision;
        _status = status;
        _log = log;
        _lastCompletedStep = lastCompletedStep;
        _exception = exception;
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

    string getComputerName() const pure nothrow
    {
        return _computerName;
    }

private:
    string _planName;
    string _computerName;
    int _planRevision;
    RunStatus _status;
    ExecutionLog _log;
    int _lastCompletedStep;
    Optional!MssException _exception;
}
