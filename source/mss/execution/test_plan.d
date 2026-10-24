module mss.execution.test_plan;

import mss.core.matrix : InputMatrix;
import mss.execution.plan_step;
import mss.execution.plan_state;

class TestPlan
{
    this(const string name)
    {
        _name = name;
    }

    void touch()
    {
        ++_revision;
        _state = PlanState.draft;
    }

    InputMatrix[] unusedInputs() const
    {
        // placeholder
        return [];
    }

    void redraw()
    {
        // placeholder
    }

    void copyAs()
    {
        // placeholder
    }

private:
    string _name;
    int _revision;
    InputMatrix[] inputs;
    PlanStep[] steps;
    PlanState _state;
}
