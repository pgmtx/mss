module mss.execution.plan_step;

import mss.core.matrix : Matrix;
import mss.execution.operation_type;
import mss.execution.result_kind;

immutable class PlanStep
{
    bool hasReference() pure nothrow
    {
        // placeholder
        return false;
    }

private:
    int _position;
    OperationType _operation;
    string[] _inputNames;
    string _resultName;

    // Either[Matrix, long] ???

    ResultKind _expectedKind;
    Matrix _expectedMatrix;
    long _expectedScalar;
}
