module mss.core.trace.execution_log;

import mss.core.weight : Action, ComponentModel;
import mss.core.trace.log_entry;
import mss.core.trace.sub_total;

class ExecutionLog
{
    LogEntry record(Action action, ComponentModel model, const string context) nothrow
    {
        auto entry = LogEntry(1, action, model.name, model.getWeight(action), _total, context);
        _entries ~= entry;
        return entry;
    }

    long getTotal() const pure nothrow
    {
        return _total;
    }

    LogEntry[] getEntries() const pure nothrow
    {
        return _entries;
    }

    SubTotal[Action] subtotals() const pure nothrow
    {
        // placeholder
        return [Action.puAdd: new SubTotal];
    }

private:
    LogEntry[] _entries;
    long _total;
}
