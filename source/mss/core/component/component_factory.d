module mss.core.component.component_factory;

import mss.core.matrix.acquisition_mode;
import mss.core.component.processing_unit;
import mss.core.component.memory;
import mss.core.component.input_manager;
import mss.core.component.output_controller;

interface ComponentFactory
{
    ProcessingUnit createProcessing(AcquisitionMode mode);
    Memory createMemory(AcquisitionMode mode);
    InputManager createInputManager(AcquisitionMode mode);
    OutputController createOutputController(AcquisitionMode mode);
}
