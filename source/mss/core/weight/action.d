module mss.core.weight.action;

import mss.core.matrix.acquisition_mode;
import mss.core.matrix.matrix_size;

enum Action
{
    puAdd,
    puSubstract,
    puMultiply,
    puSwap,
    puSum,

    memLoadBlock,
    memWriteBlock,
    memStoreMatrix2,
    memStoreMatrix4,
    memStoreMatrix8,
    memStoreMatrix16,

    inManualCsv2,
    inManualCsv4,
    inManualCsv8,
    inManualCsv16,

    inRandom2,
    inRandom4,
    inRandom8,
    inRandom16,

    outTraceStep,
    outMatrix2,
    outMatrix4,
    outMatrix8,
    outMatrix16,
    outScalar,
}

Action acquisition(AcquisitionMode mode, MatrixSize size)
{
    if (mode == AcquisitionMode.random)
    {
        final switch (size)
        {
        case MatrixSize.s2:
            return Action.inRandom2;
        case MatrixSize.s4:
            return Action.inRandom4;
        case MatrixSize.s8:
            return Action.inRandom8;
        case MatrixSize.s16:
            return Action.inRandom16;
        }
    }

    final switch (size)
    {
    case MatrixSize.s2:
        return Action.inManualCsv2;
    case MatrixSize.s4:
        return Action.inManualCsv4;
    case MatrixSize.s8:
        return Action.inManualCsv8;
    case MatrixSize.s16:
        return Action.inManualCsv16;
    }
}

unittest
{
    assert(acquisition(AcquisitionMode.manual,
            MatrixSize.s4) == acquisition(AcquisitionMode.csv, MatrixSize.s4));
}

Action storeMatrix(MatrixSize size)
{
    final switch (size)
    {
    case MatrixSize.s2:
        return Action.memStoreMatrix2;
    case MatrixSize.s4:
        return Action.memStoreMatrix4;
    case MatrixSize.s8:
        return Action.memStoreMatrix8;
    case MatrixSize.s16:
        return Action.memStoreMatrix16;
    }
}

Action showMatrix(MatrixSize size)
{
    final switch (size)
    {
    case MatrixSize.s2:
        return Action.outMatrix2;
    case MatrixSize.s4:
        return Action.outMatrix4;
    case MatrixSize.s8:
        return Action.outMatrix8;
    case MatrixSize.s16:
        return Action.outMatrix16;
    }
}
