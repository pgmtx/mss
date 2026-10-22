module mss.core.weight.action;

import mss.core.matrix.acquisition_mode;

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

Action acquisition(AcquisitionMode mode, int size)
{
    // placeholder
    return Action.puAdd;
}

Action storeMatrix(int size)
{
    // placeholder
    return Action.puAdd;
}

Action showMatrix(int size)
{
    // placeholder
    return Action.puAdd;
}
