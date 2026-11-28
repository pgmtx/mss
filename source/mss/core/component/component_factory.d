module mss.core.component.component_factory;

import mss.core.component.input_manager;
import mss.core.component.memory;
import mss.core.component.output_controller;
import mss.core.component.processing_unit;
import mss.core.weight : ComponentModel;

interface ComponentFactory
{
    ProcessingUnit createProcessingUnit(ComponentModel model);
    Memory createMemory(ComponentModel model);
    InputManager createInputManager(ComponentModel model);
    OutputController createOutputController(ComponentModel model);
}
