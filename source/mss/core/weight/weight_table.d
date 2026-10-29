module mss.core.weight.weight_table;

import mss.core.weight.action;
import mss.core.weight.component_category;

class WeightTable
{
    enum minWeight = 1;
    enum maxWeight = 10;

    this(ComponentCategory category, int[Action] weights)
    {
        import mss.core.error : InvalidWeightException;
        import std.algorithm;
        import std.conv : to;
        import std.exception : enforce;

        auto actions = _getActionsFromCategory(category).sort();
        auto actionKeys = weights.keys.sort();
        enforce!InvalidWeightException(actionKeys.length >= actions.length,
                "some actions are missing for the category " ~ to!string(category));
        enforce!InvalidWeightException(actionKeys == actions,
                "some actions do not correspond to " ~ to!string(category));
        enforce!InvalidWeightException(weights.byValue.all!(v => minWeight <= v
                && v <= maxWeight), "found an out-of-bounds weight");

        _category = category;
        _weights = weights;
    }

private:
    ComponentCategory _category;
    int[Action] _weights;

    Action[] _getActionsFromCategory(ComponentCategory category)
    {
        final switch (category)
        {
        case ComponentCategory.processingUnit:
            return [
                Action.puAdd, Action.puSubstract, Action.puMultiply, Action.puSwap,
                Action.puSum
            ];
        case ComponentCategory.memory:
            return [
                Action.memLoadBlock, Action.memWriteBlock, Action.memStoreMatrix2,
                Action.memStoreMatrix4, Action.memStoreMatrix8,
                Action.memStoreMatrix16
            ];
        case ComponentCategory.inputManager:
            return [
                Action.inManualCsv2, Action.inManualCsv4, Action.inManualCsv8,
                Action.inManualCsv16, Action.inRandom2, Action.inRandom4,
                Action.inRandom8, Action.inRandom16
            ];
        case ComponentCategory.outputController:
            return [
                Action.outTraceStep, Action.outMatrix2, Action.outMatrix4,
                Action.outMatrix8, Action.outMatrix16, Action.outScalar
            ];
        }
    }
}
