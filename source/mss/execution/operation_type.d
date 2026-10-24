module mss.execution.operation_type;

import mss.execution.result_kind;

enum OperationType
{
    addition,
    substraction,
    multiplication,
    rotation,
    sum
}

int getArity(OperationType type)
{
    switch (type)
    {
    case OperationType.addition: .. case OperationType.multiplication:
        return 2;
    default:
        return 1;
    }
}

ResultKind getResultKind(OperationType type)
{
    if (type == OperationType.sum)
    {
        return ResultKind.integer;
    }
    return ResultKind.matrix;
}
