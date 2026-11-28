module mss.core.computer.computer;

import mss.core.component;
import mss.core.computer.computer_model;
import mss.core.matrix;
import mss.core.trace : ExecutionLog, LogEntry, TraceStep;
import mss.core.weight : Action, ComponentCategory, acquisition, storeMatrix, showMatrix;
import std.format : format;

class Computer
{
    this(const ComputerModel model, ComponentFactory factory)
    {
        _model = model;
        _processingUnit = factory.createProcessingUnit(
                model.getModel(ComponentCategory.processingUnit));
        _memory = factory.createMemory(model.getModel(ComponentCategory.memory));
        _inputManager = factory.createInputManager(model.getModel(ComponentCategory.inputManager));
        _outputController = factory.createOutputController(
                model.getModel(ComponentCategory.outputController));
        _log = new ExecutionLog();
    }

    void acquire(const InputMatrix[] inputs)
    {
        auto matrices = new Matrix[inputs.length];
        foreach (i, input; inputs)
        {
            immutable size = input.getSize();
            immutable name = input.getName();
            matrices[i] = _inputManager.acquire(input);
            _logRecord(acquisition(input.getMode(), size), "Acquisition de " ~ name);

            _memory.storeMatrix(name, matrices[i]);
            _logRecord(storeMatrix(size), "Stockage de " ~ name);
        }
    }

    unittest
    {
        import mss.core.matrix : BlockPosition;
        import mss.impl : StandardComponentFactory;
        import std.algorithm : map, equal;

        auto model = new ComputerModel("TEST", _testComponentModel(ComponentCategory.processingUnit),
                _testComponentModel(ComponentCategory.memory),
                _testComponentModel(ComponentCategory.inputManager),
                _testComponentModel(ComponentCategory.outputController), true);
        auto computer = new Computer(model, new StandardComponentFactory());

        // dfmt off
        const inputs = [
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
        assert(entries.map!(x => x.action).equal([
            Action.inManualCsv2, Action.memStoreMatrix2, Action.inRandom4,
            Action.memStoreMatrix4
        ]));
        assert(entries.map!(x => x.total).equal([2, 5, 7, 10]));
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
        // scope (success) exécute ses instructions si aucune exception n'est
        // levée.
        scope (success)
        {
            _logRecord(Action.memLoadBlock, format("Chargement du bloc %s%d%d",
                    name, position.row, position.column));
        }
        return _memory.loadBlock(name, position);
    }

    void writeBlock(const string name, BlockPosition position, Block block)
    {
        scope (success)
        {
            _logRecord(Action.memWriteBlock, format("Ecriture du bloc %s%d%d",
                    name, position.row, position.column));
        }
        _memory.writeBlock(name, position, block);
    }

    const(Matrix) readMatrix(const string name)
    {
        return _memory.read(name);
    }

    void showMatrix(const string name)
    {
        const matrix = readMatrix(name);
        _outputController.showMatrix(name, matrix);

        // La syntaxe .showMatrix permet de distinguer entre la méthode courante
        // et la fonction définie pour une Action.
        _logRecord(.showMatrix(matrix.getSize()), "Affichage de " ~ name);
    }

    void showScalar(const string name, long value)
    {
        _outputController.showScalar(name, value);
        _logRecord(Action.outScalar, "Affichage du scalaire " ~ name);
    }

    // --- Instructions de l'UT ---

    Block add(Block a, Block b)
    {
        return _processingInstruction(Action.puAdd, "Addition de blocs",
                () => _processingUnit.add(a, b));
    }

    Block substract(Block a, Block b)
    {
        return _processingInstruction(Action.puSubstract,
                "Soustraction de blocs", () => _processingUnit.substract(a, b));
    }

    Block multiply(Block a, Block b)
    {
        return _processingInstruction(Action.puMultiply,
                "Multiplication de blocs", () => _processingUnit.multiply(a, b));
    }

    Block swap(Block block, BlockCell cell1, BlockCell cell2)
    {
        return _processingInstruction(Action.puSwap, "Echange entre deux cellules d'un bloc",
                () => _processingUnit.swap(block, cell1, cell2));
    }

    BlockPair swap(Block block1, BlockCell cell1, Block block2, BlockCell cell2)
    {
        return _processingInstruction(Action.puSwap, "Echange entre deux cellules de deux blocs",
                () => _processingUnit.swap(block1, cell1, block2, cell2));
    }

    Block sum(Block block)
    {
        return _processingInstruction(Action.puSum, "Somme d'un bloc",
                () => _processingUnit.sum(block));
    }

    // --- Consultation ---

    const(ComputerModel) getModel() pure nothrow
    {
        return _model;
    }

    ExecutionLog getLog() pure nothrow
    {
        return _log;
    }

private:
    const ComputerModel _model;
    ExecutionLog _log;
    ProcessingUnit _processingUnit;
    Memory _memory;
    InputManager _inputManager;
    OutputController _outputController;

    LogEntry _logRecord(Action action, const string context)
    {
        return _log.record(action, _model.getModel(_getCategoryFromAction(action)), context);
    }

    ComponentCategory _getCategoryFromAction(Action action) const pure nothrow
    {
        final switch (action)
        {
        case Action.puAdd:
        case Action.puSubstract:
        case Action.puMultiply:
        case Action.puSwap:
        case Action.puSum:
            return ComponentCategory.processingUnit;
        case Action.memLoadBlock:
        case Action.memWriteBlock:
        case Action.memStoreMatrix2:
        case Action.memStoreMatrix4:
        case Action.memStoreMatrix8:
        case Action.memStoreMatrix16:
            return ComponentCategory.memory;
        case Action.inManualCsv2:
        case Action.inManualCsv4:
        case Action.inManualCsv8:
        case Action.inManualCsv16:
        case Action.inRandom2:
        case Action.inRandom4:
        case Action.inRandom8:
        case Action.inRandom16:
            return ComponentCategory.inputManager;
        case Action.outTraceStep:
        case Action.outMatrix2:
        case Action.outMatrix4:
        case Action.outMatrix8:
        case Action.outMatrix16:
        case Action.outScalar:
            return ComponentCategory.outputController;
        }
    }

    Block _processingInstruction(Action action, const string label, Block delegate() operation)
    {
        immutable result = operation();
        immutable computation = _logRecord(action, label);
        immutable display = _logRecord(Action.outTraceStep, "Suivi : " ~ label);
        immutable step = TraceStep(_model.getName(), label, [result], computation, display);
        _outputController.showTraceStep(step);
        return result;
    }

    BlockPair _processingInstruction(Action action, const string label,
            BlockPair delegate() operation)
    {
        immutable result = operation();
        immutable computation = _logRecord(action, label);
        immutable display = _logRecord(Action.outTraceStep, "Suivi : " ~ label);
        immutable step = TraceStep(_model.getName(), label, [
            result.first, result.second
        ], computation, display);
        _outputController.showTraceStep(step);
        return result;
    }
}

version (unittest)
{
    import mss.session;
    import mss.core.weight : ComponentModel, WeightTable;
    import mss.impl.standard_component_factory;
    import core.sys.bionic.err;

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

unittest
{
    auto computer = new Computer(ord1, new StandardComponentFactory());
    immutable result = computer.add(Block(1, 2, 3, 4), Block(5, 6, 7, 8));
    assert(result == Block(6, 8, 10, 12));

    immutable entries = computer.getLog().getEntries();
    assert(entries.length == 2);
    assert(entries[0].action == Action.puAdd);
    assert(entries[0].total == 3);
    assert(entries[1].action == Action.outTraceStep);
    assert(entries[1].total == 4);
}

unittest
{
    import std.exception : assertThrown;
    import mss.core.error : OverflowException;

    auto computer = new Computer(ord1, new StandardComponentFactory());
    assertThrown!OverflowException(computer.add(Block(long.max, 2, 3, 4), Block(1, 2, 3, 4)));
    assert(computer.getLog().getEntries().length == 0);
}
