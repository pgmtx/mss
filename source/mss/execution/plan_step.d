module mss.execution.plan_step;

import mss.core.matrix : InputMatrix, Matrix;
import mss.execution.operation_type;
import mss.execution.result_kind;
import mss.execution.test_plan;

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

    bool hasReference() const pure nothrow
    {
        return _expectedValue != none;
    }

    int getPosition() const pure nothrow
    {
        return _position;
    }

    OperationType getOperation() const pure nothrow
    {
        return _operation;
    }

    string[] getInputNames() const pure nothrow
    {
        return _inputNames.dup;
    }

    string getResultName() const pure nothrow
    {
        return _resultName;
    }

    const(Optional!(Either!(Matrix, long))) getExpectedValue() const pure nothrow
    {
        return _expectedValue;
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

unittest
{
    import mss.core.matrix : AcquisitionMode;
    import mss.execution.operation_type;
    import mss.execution.plan_state;

    auto plan = new TestPlan("Test");
    auto input = new InputMatrix("A", Matrix.of([[1, 2], [3, 4]]), AcquisitionMode.manual, "test");
    auto step = new PlanStep(1, OperationType.sum, ["A"], "total", 10);

    plan.addInput(input);
    plan.addStep(step);
    assert(plan.getRevision() == 2);
    assert(plan.getState() == PlanState.draft);

    plan.setReady();

    const inputs = plan.getInputs();
    const steps = plan.getSteps();

    assert(inputs.ptr !is plan.getInputs().ptr);
    assert(steps.ptr !is plan.getSteps().ptr);

    assert(step.hasReference());
    assert(step.getExpectedValue() != none);

    plan.addInput(inputs[0]);
    assert(plan.getRevision() == 3);
    assert(plan.getState() == PlanState.draft);
}
