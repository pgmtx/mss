module mss.execution.test_plan;

import mss.core.matrix : InputMatrix;
import mss.execution.plan_step;
import mss.execution.plan_state;

class TestPlan
{
    this(const string name) pure nothrow
    {
        _name = name;
    }

    void addInput(InputMatrix input) nothrow
    {
        _inputs ~= input;
        touch();
    }

    void addStep(PlanStep step) nothrow
    {
        _steps ~= step;
        touch();
    }

    void touch() nothrow
    {
        ++_revision;
        _state = PlanState.draft;
    }

    void setReady()
    {
        _state = PlanState.ready;
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

    string getName() const pure nothrow
    {
        return _name;
    }

    int getRevision() const pure nothrow
    {
        return _revision;
    }

    PlanState getState() const pure nothrow
    {
        return _state;
    }

    InputMatrix[] getInputs() const pure nothrow
    {
        return deepCopyArray!InputMatrix(_inputs);
    }

    PlanStep[] getSteps() const pure nothrow
    {
        return deepCopyArray!PlanStep(_steps);
    }

private:
    string _name;
    int _revision;
    InputMatrix[] _inputs;
    PlanStep[] _steps;
    PlanState _state;
}

private T[] deepCopyArray(T)(const T[] values)
{
    T[] result;
    foreach (i, value; values)
    {
        result ~= value;
    }
    return result;
}
