module mss.core.trace.execution_log;

import mss.core.error : OverflowException;
import mss.core.weight : Action, ComponentModel;
import mss.core.trace.log_entry;
import mss.core.trace.sub_total;
import std.checkedint : checked, Throw;

class ExecutionLog
{
    private static int _logId = 1;

    LogEntry record(Action action, ComponentModel model, const string context)
    {
        immutable weight = model.getWeight(action);
        auto totalWeight = checked!Throw(weight);

        try
        {
            totalWeight += weight;
        }
        catch (Throw.CheckFailure)
        {
            throw OverflowException.costCounterExceeded();
        }

        _total = totalWeight.get();

        immutable entry = LogEntry(_logId, action, model.name, weight, _total, context);
        ++_logId;
        _entries ~= entry;
        return entry;
    }

    long getTotal() const pure nothrow
    {
        return _total;
    }

    immutable(LogEntry[]) getEntries() const pure nothrow
    {
        return _entries;
    }

    SubTotal[Action] subtotals() const pure
    {
        SubTotal[Action] result;
        foreach (entry; _entries)
        {
            // On utilise require pour ajouter une entrée dans la map, car l'assignation
            // `result[entry.action] = ...` ne fonctionne pas pour une structure immuable.
            result.require(entry.action, SubTotal(entry.action,
                    entry.component, entry.number, entry.weight, entry.total));
        }
        return result;
    }

private:
    LogEntry[] _entries;
    long _total;
}
