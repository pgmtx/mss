module mss.core.weight.component_model;

import mss.core.weight.weight_table;
import mss.core.weight.action;

immutable class ComponentModel
{
    int getWeight(Action action) pure nothrow
    {
        // placeholder
        return 0;
    }

    string name;
    WeightTable weights;
    bool predefined;
}
