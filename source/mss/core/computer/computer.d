module mss.core.computer.computer;

import mss.core.component;
import mss.core.computer.computer_model;
import mss.core.matrix;
import mss.core.trace : ExecutionLog;
import mss.core.weight : Action, ComponentCategory, acquisition, storeMatrix;

class Computer
{
    this(ComputerModel model, ComponentFactory factory)
    {
        _model = model;
        _processingUnit = factory.createProcessingUnit(model.getModel(ComponentCategory.processingUnit));
        _memory = factory.createMemory(model.getModel(ComponentCategory.memory));
        _inputManager = factory.createInputManager(model.getModel(ComponentCategory.inputManager));
        _outputController = factory.createOutputController(model.getModel(ComponentCategory.outputController));
        _log = new ExecutionLog();
    }

    void acquire(const InputMatrix[] inputs)
    {
        auto matrices = new Matrix[inputs.length];
        foreach (i, input; inputs)
        {
            matrices[i] = _inputManager.acquire(input);
            _log.record(acquisition(input.getMode(), input.getSize()),
                    _model.getModel(ComponentCategory.inputManager), "Acquérir " ~ input.getName());
        }

        foreach (i, input; inputs)
        {
            _memory.storeMatrix(input.getName(), matrices[i]);
            _log.record(storeMatrix(input.getSize()),
                    _model.getModel(ComponentCategory.memory), "Stocker " ~ input.getName());
        }
    }

    unittest
    {
        import mss.core.matrix : BlockPosition;
        import mss.impl : StandardComponentFactory;

        auto model = new ComputerModel("TEST", _testComponentModel(ComponentCategory.processingUnit),
                _testComponentModel(ComponentCategory.memory),
                _testComponentModel(ComponentCategory.inputManager),
                _testComponentModel(ComponentCategory.outputController), true);
        auto computer = new Computer(model, new StandardComponentFactory());

        // dfmt off
        InputMatrix[] inputs = [
            new InputMatrix("A", Matrix.of([[1, 2], [3, 4]]),
                    AcquisitionMode.manual, "console"),
            new InputMatrix("B", Matrix.of([
                    [1, 2, 3, 4],
                    [5, 6, 7, 8],
                    [9, 10, 11, 12],
                    [13, 14, 15, 16]
            ]), AcquisitionMode.random, "seed=1")
        ];
        // dfmt on

        computer.acquire(inputs);

        immutable entries = computer.getLog().getEntries();
        assert(entries.length == 4);
        assert(entries[0].action == Action.inManualCsv2);
        assert(entries[1].action == Action.inRandom4);
        assert(entries[2].action == Action.memStoreMatrix2);
        assert(entries[3].action == Action.memStoreMatrix4);
        assert(entries[0].total == 2);
        assert(entries[1].total == 4);
        assert(entries[2].total == 7);
        assert(entries[3].total == 10);
        assert(computer.readMatrix("A").getBlock(BlockPosition(0, 0)) == Block(1, 2, 3, 4));
        assert(computer.readMatrix("B").getRowsCount() == 4);
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

    const(Matrix) readMatrix(const string name)
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

    BlockPair swap(Block block1, BlockCell cell1, Block block2, BlockCell cell2)
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

    void _processingInstruction()
    {
        // placeholder
    }
}

version (unittest)
{
    import mss.core.weight : ComponentModel, WeightTable;

    private ComponentModel _testComponentModel(ComponentCategory category)
    {
        enum defaultWeight = 1;
        enum memoryWeight = 3;
        enum inputManagerWeight = 2;

        Action[] actions;
        int weight = defaultWeight;

        final switch (category)
        {
        case ComponentCategory.processingUnit:
            actions = [
                Action.puAdd, Action.puSubstract, Action.puMultiply, Action.puSwap,
                Action.puSum
            ];
            break;
        case ComponentCategory.memory:
            actions = [
                Action.memLoadBlock, Action.memWriteBlock, Action.memStoreMatrix2,
                Action.memStoreMatrix4, Action.memStoreMatrix8,
                Action.memStoreMatrix16
            ];
            weight = memoryWeight;
            break;
        case ComponentCategory.inputManager:
            actions = [
                Action.inManualCsv2, Action.inManualCsv4, Action.inManualCsv8,
                Action.inManualCsv16, Action.inRandom2, Action.inRandom4,
                Action.inRandom8, Action.inRandom16
            ];
            weight = inputManagerWeight;
            break;
        case ComponentCategory.outputController:
            actions = [
                Action.outTraceStep, Action.outMatrix2, Action.outMatrix4,
                Action.outMatrix8, Action.outMatrix16, Action.outScalar
            ];
            break;
        }

        int[Action] weights;
        foreach (action; actions)
        {
            weights[action] = weight;
        }
        return new ComponentModel("TEST", new WeightTable(category, weights), true);
    }
}
