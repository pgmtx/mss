module mss.execution.plan_step;

import mss.core.matrix : Matrix;
import mss.execution.operation_type;
import mss.execution.result_kind;

immutable class PlanStep
{
    int position;
    OperationType type;
    string[] inputNames;
    string resultName;
    ResultKind expectedKind;
    Matrix expectedMatrix;
    long expectedScalar;
}
