module mss.core.trace.trace_step;

import mss.core.matrix : Block;
import mss.core.trace.log_entry;

immutable class TraceStep
{
    string computer;
    string label;
    Block[] results;
    LogEntry computation;
    LogEntry display;
}
