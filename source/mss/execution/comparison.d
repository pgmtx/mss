module mss.execution.comparison;

import mss.execution.run_result;
import mss.execution.run_status;

struct Comparison
{
    this(const RunResult[] results)
    {
        _results = results;
    }

    const(RunResult)[] ranking() const
    {
        import std.algorithm : sort;

        size_t[] order;
        foreach (i, result; _results)
        {
            if (result.getStatus() != RunStatus.incomplete)
            {
                order ~= i;
            }
        }

        sort!((a, b) => _results[a].getLog().getTotal() < _results[b].getLog().getTotal())(order);

        const(RunResult)[] completed;
        foreach (i; order)
        {
            completed ~= _results[i];
        }
        return completed;
    }

    const(RunResult)[][] ties() const
    {
        const(RunResult)[][] groups;
        const(RunResult)[] group;

        foreach (result; ranking())
        {
            if (group.length > 0 && group[0].getLog().getTotal() != result.getLog().getTotal())
            {
                if (group.length > 1)
                {
                    groups ~= deepCopyArray(group);
                }
                group = [];
            }
            group ~= result;
        }

        if (group.length > 1)
        {
            groups ~= deepCopyArray(group);
        }
        return groups;
    }

private:
    const RunResult[] _results;
}

private const(RunResult)[] deepCopyArray(const(RunResult)[] values)
{
    const(RunResult)[] result;
    foreach (i, value; values)
    {
        result ~= value;
    }
    return result;
}
