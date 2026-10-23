module mss.core.trace.log_entry;

import mss.core.weight : Action;

immutable class LogEntry
{
    int number;
    Action action;
    string component;
    int weight;
    long total;
    string context;
}
