module mss.core.computer.computer_model;

import mss.core.weight : ComponentModel, ComponentCategory;

immutable class ComputerModel
{
    string getName() pure nothrow
    {
        return _name;
    }

    ComponentModel getModel(ComponentCategory category) pure nothrow
    {
        final switch (category)
        {
        case ComponentCategory.processingUnit:
            return _processingUnit;
        case ComponentCategory.memory:
            return _memory;
        case ComponentCategory.inputManager:
            return _inputManager;
        case ComponentCategory.outputController:
            return _outputController;
        }
    }

    bool isPredefined() pure nothrow
    {
        return _predefined;
    }

    string describe() pure nothrow
    {
        // placeholder
        return "";
    }

private:
    string _name;
    ComponentModel _processingUnit;
    ComponentModel _memory;
    ComponentModel _inputManager;
    ComponentModel _outputController;
    bool _predefined;
}
