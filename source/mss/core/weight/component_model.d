module mss.core.weight.component_model;

import mss.core.weight.weight_table;
import mss.core.weight.action;

const class ComponentModel
{
    this(const string name, const WeightTable weights, bool predefined)
    {
        this.name = name;
        this.weights = weights;
        this.predefined = predefined;
    }

    int getWeight(Action action) pure nothrow
    {
        // placeholder
        return 0;
    }

    string name;
    WeightTable weights;
    bool predefined;
}
