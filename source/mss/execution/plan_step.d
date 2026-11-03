module mss.execution.plan_step;

import mss.core.matrix : Matrix;
import mss.execution.operation_type;
import mss.execution.result_kind;

import optional : Optional, some, none;
import either : Either;

const class PlanStep
{
    this(int position, OperationType operation, const string[] inputNames, const string resultName) pure nothrow
    {
        _position = position;
        _operation = operation;
        _inputNames = inputNames;
        _resultName = resultName;
        _expectedValue = none;
    }

    this(int position, OperationType operation, const string[] inputNames,
            const string resultName, Matrix expectedMatrix) pure nothrow
    {
        _position = position;
        _operation = operation;
        _inputNames = inputNames;
        _resultName = resultName;
        _expectedValue = some(Either!(Matrix, long)(expectedMatrix));
    }

    this(int position, OperationType operation, const string[] inputNames,
            const string resultName, long expectedScalar) pure nothrow
    {
        _position = position;
        _operation = operation;
        _inputNames = inputNames;
        _resultName = resultName;
        _expectedValue = some(Either!(Matrix, long)(expectedScalar));
    }

    bool hasReference() pure nothrow
    {
        return _expectedValue != none;
    }

private:
    int _position;
    OperationType _operation;
    string[] _inputNames;
    string _resultName;

    // On utilise Optional car la valeur de référence est facultative.
    // Either assure que l'on utilise un seul type.
    // Cela évite aussi les valeurs invalides.
    Optional!(Either!(Matrix, long)) _expectedValue;
}
