module mss.impl.standard_component_factory;

import mss.core.component;
import mss.core.matrix : AcquisitionMode;
import mss.impl.console_input_manager;
import mss.impl.console_output_controller;
import mss.impl.standard_memory;
import mss.impl.standard_processing_unit;

class StandardComponentFactory : ComponentFactory
{
    ProcessingUnit createProcessingUnit(AcquisitionMode mode)
    {
        // placeholder
        return new StandardProcessingUnit;
    }

    Memory createMemory(AcquisitionMode mode)
    {
        // placeholder
        return new StandardMemory;
    }

    InputManager createInputManager(AcquisitionMode mode)
    {
        // placeholder
        return new ConsoleInputManager;
    }

    OutputController createOutputController(AcquisitionMode mode)
    {
        // placeholder
        return new ConsoleOutputController;
    }
}
