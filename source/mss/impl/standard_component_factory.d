module mss.impl.standard_component_factory;

import mss.core.component;
import mss.core.matrix : AcquisitionMode;
import mss.core.weight : ComponentModel;
import mss.impl.console_input_manager;
import mss.impl.console_output_controller;
import mss.impl.standard_memory;
import mss.impl.standard_processing_unit;

class StandardComponentFactory : ComponentFactory
{
    override ProcessingUnit createProcessingUnit(ComponentModel model)
    {
        return new StandardProcessingUnit(model);
    }

    override Memory createMemory(ComponentModel model)
    {
        return new StandardMemory(model);
    }

    override InputManager createInputManager(ComponentModel model)
    {
        return new ConsoleInputManager(model);
    }

    override OutputController createOutputController(ComponentModel model)
    {
        return new ConsoleOutputController(model);
    }
}
