module mss.core.weight.component_model;

import mss.core.weight.weight_table;
import mss.core.weight.action;

immutable class ComponentModel
{
    int getWeight(Action action)
    {
        // placeholder
        return 0;
    }

private:
    string name;
    WeightTable weights;
    bool predefined;
}
