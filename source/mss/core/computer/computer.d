module mss.core.computer.computer;

import mss.core.computer.computer_model;
import mss.core.trace : ExecutionLog;
import mss.core.matrix;
import mss.core.component;

class Computer
{
    void acquire(InputMatrix[] inputs) pure nothrow
    {
        // placeholder
    }

    // --- Mémoire ---

    Matrix allocate(const string name, MatrixSize size)
    {
        return _memory.allocate(name, size);
    }

    void free(const string name)
    {
        _memory.free(name);
    }

    Block loadBlock(const string name, BlockPosition position)
    {
        return _memory.loadBlock(name, position);
    }

    void writeBlock(const string name, BlockPosition position, Block block)
    {

        _memory.writeBlock(name, position, block);
    }

    Matrix readMatrix(const string name)
    {
        return _memory.read(name);
    }

    void showMatrix(const string name) pure nothrow
    {
        // placeholder
    }

    void showScalar(const string name, long value) pure nothrow
    {
        // placeholder
    }

    // --- Instructions de l'UT ---

    Block add(Block a, Block b)
    {
        return _processingUnit.add(a, b);
    }

    Block substract(Block a, Block b)
    {
        return _processingUnit.substract(a, b);
    }

    Block multiply(Block a, Block b)
    {
        return _processingUnit.multiply(a, b);
    }

    Block swap(Block block, BlockCell cell1, BlockCell cell2)
    {
        return _processingUnit.swap(block, cell1, cell2);
    }

    Block swap(Block block1, BlockCell cell1, Block block2, BlockCell cell2)
    {
        return _processingUnit.swap(block1, cell1, block2, cell2);
    }

    Block sum(Block block)
    {
        return _processingUnit.sum(block);
    }

    // --- Consultation ---

    ComputerModel getModel() const pure nothrow
    {
        return _model;
    }

    ExecutionLog getLog() pure nothrow
    {
        return _log;
    }

private:
    ComputerModel _model;
    ExecutionLog _log;
    ProcessingUnit _processingUnit;
    Memory _memory;
    InputManager _inputManager;
    OutputController _outputController;
}
