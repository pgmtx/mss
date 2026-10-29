module mss.core.trace.sub_total;

import mss.core.weight : Action;

immutable struct SubTotal
{
    Action action;
    string component;
    int count;
    int unitWeight;
    long amount;
}
