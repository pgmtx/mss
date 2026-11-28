module mss.execution.plan_validator;

import mss.core.error : InvalidPlanException;
import mss.core.matrix : MatrixSize, Matrix;
import mss.execution.operation_type : OperationType, getArity, getResultKind;
import mss.execution.result_kind;
import mss.execution.test_plan;

import either : isLeft, when;
import std.exception : enforce;
import std.file;

class PlanValidator
{
    @disable this();

    static void validate(TestPlan plan)
    {
        auto inputs = plan.getInputs();
        auto steps = plan.getSteps();
        enforce(steps.length > 0, InvalidPlanException.emptyPlan());

        ResultKind[string] knownTypes;
        MatrixSize[string] matrixSizes;

        foreach (input; inputs)
        {
            immutable name = input.getName();
            enforce(name.length > 0, InvalidPlanException.invalidEntriesKind());
            enforce((name in knownTypes) is null, InvalidPlanException.invalidEntriesKind());

            knownTypes[name] = ResultKind.matrix;
            matrixSizes[name] = input.getSize();
        }

        foreach (step; steps)
        {
            immutable operation = step.getOperation();
            const inputNames = step.getInputNames();
            enforce(inputNames.length == getArity(operation),
                    InvalidPlanException.invalidEntriesCount());

            foreach (name; inputNames)
            {
                enforce(name.length != 0, InvalidPlanException.invalidEntriesKind());
                enforce((name in knownTypes) !is null, InvalidPlanException.unavailableReference());
                enforce(knownTypes[name] == ResultKind.matrix,
                        InvalidPlanException.invalidEntriesKind());
            }

            if (operation == OperationType.addition || operation == OperationType.substraction
                    || operation == OperationType.multiplication)
            {
                enforce(matrixSizes[inputNames[0]] == matrixSizes[inputNames[1]],
                        InvalidPlanException.incompatibleDimensions());
            }

            immutable resultName = step.getResultName();
            enforce(resultName.length > 0, InvalidPlanException.invalidEntriesKind());
            enforce((resultName in knownTypes) is null, InvalidPlanException.invalidEntriesKind());

            immutable resultKind = getResultKind(operation);
            if (step.hasReference())
            {
                auto expected = step.getExpectedValue();
                immutable isReferenceMatrix = isLeft(expected.front);
                enforce(isReferenceMatrix == (resultKind == ResultKind.matrix),
                        InvalidPlanException.invalidEntriesKind());
                expected.front.when((const Matrix matrix) {
                    enforce(matrix.getSize() == matrixSizes[inputNames[0]],
                        InvalidPlanException.incompatibleDimensions());
                });
            }

            knownTypes[resultName] = resultKind;
            if (resultKind == ResultKind.matrix)
            {
                matrixSizes[resultName] = matrixSizes[inputNames[0]];
            }
        }

        plan.setReady();
    }
}

unittest
{
    import mss.core.matrix : AcquisitionMode, InputMatrix;
    import mss.execution.plan_state;
    import mss.execution.plan_step;

    auto plan = new TestPlan("Test");

    // dfmt off
    plan.addInput(new InputMatrix(
        "A", Matrix.of([[1, 2], [3, 4]]), AcquisitionMode.manual, "test"
    ));
    // dfmt on
    plan.addStep(new PlanStep(1, OperationType.sum, ["A"], "total"),);
    PlanValidator.validate(plan);
    assert(plan.getState() == PlanState.ready);
}
