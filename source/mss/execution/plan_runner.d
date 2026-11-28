module mss.execution.plan_runner;

import either : isLeft, isRight, when;
import mss.core.component : ComponentFactory;
import mss.core.computer : Computer, ComputerModel;
import mss.core.error : MssException;
import mss.core.matrix : Matrix;
import mss.execution.operation_type;
import mss.execution.plan_step;
import mss.execution.plan_validator;
import mss.execution.run_result;
import mss.execution.run_status;
import mss.execution.test_plan;
import mss.operations;

class PlanRunner
{
    @disable this();

    static RunResult run(TestPlan plan, const ComputerModel model, ComponentFactory factory)
    {
        PlanValidator.validate(plan);

        auto computer = new Computer(model, factory);
        const inputs = plan.getInputs();
        const steps = plan.getSteps();

        int lastCompletedStep = -1;
        bool compliant = true;

        try
        {
            computer.acquire(inputs);

            foreach (step; steps)
            {
                const names = step.getInputNames();
                immutable resultName = step.getResultName();

                final switch (step.getOperation())
                {
                case OperationType.addition:
                    const result = add(computer,
                            names[0], names[1], resultName);
                    compliant = _matches(step, result) && compliant;
                    break;
                case OperationType.substraction:
                    const result = substract(computer,
                            names[0], names[1], resultName);
                    compliant = _matches(step, result) && compliant;
                    break;
                case OperationType.multiplication:
                    const result = multiply(computer,
                            names[0], names[1], resultName);
                    compliant = _matches(step, result) && compliant;
                    break;
                case OperationType.rotation:
                    const result = rotate(computer, names[0], resultName);
                    compliant = _matches(step, result) && compliant;
                    break;
                case OperationType.sum:
                    const result = sum(computer, names[0], resultName);
                    compliant = _matches(step, result) && compliant;
                    break;
                }

                lastCompletedStep = step.getPosition();
            }
        }
        catch (MssException e)
        {
            // dfmt off
            return RunResult(
                plan.getName(),
                plan.getRevision(),
                RunStatus.incomplete,
                computer.getLog(),
                lastCompletedStep,
                e
            );
            // dfmt on
        }

        // dfmt off
        return RunResult(
            plan.getName(),
            plan.getRevision(),
            compliant ? RunStatus.done : RunStatus.nonCompliant,
            computer.getLog(),
            lastCompletedStep
        );
        // dfmt on
    }

private:
    static bool _matches(PlanStep step, const Matrix actual)
    {
        if (!step.hasReference())
        {
            return true;
        }

        auto expected = step.getExpectedValue();
        if (!isLeft(expected.front))
        {
            return false;
        }

        bool matches = false;
        expected.front.when((const Matrix reference) {
            matches = actual == reference;
        });
        return matches;
    }

    static bool _matches(PlanStep step, long actual)
    {
        if (!step.hasReference())
        {
            return true;
        }

        auto expected = step.getExpectedValue();
        if (!isRight(expected.front))
        {
            return false;
        }

        bool matches;
        expected.front.when((long reference) { matches = actual == reference; });
        return matches;
    }
}
