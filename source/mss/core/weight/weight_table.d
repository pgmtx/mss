module mss.core.weight.weight_table;

import mss.core.weight.action;
import mss.core.weight.component_category;

class WeightTable
{
    enum minWeight = 1;
    enum maxWeight = 10;

private:
    ComponentCategory category;
    int[Action] weights;
}
