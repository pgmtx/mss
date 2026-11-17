import mss.core;
import mss.impl : StandardComponentFactory;

void main()
{
    const computer1 = createComputer1();
    const computer2 = createComputer2();
    const computer3 = createComputer3();
}

Computer createComputer1()
{
    const puTable = new WeightTable(ComponentCategory.processingUnit, [
        Action.puAdd: 3,
        Action.puSubstract: 3,
        Action.puMultiply: 6,
        Action.puSwap: 2,
        Action.puSum: 3,
    ]);

    const pu = new ComponentModel("UT1", puTable, true);

    const memTable = new WeightTable(ComponentCategory.memory, [
        Action.memLoadBlock: 2,
        Action.memWriteBlock: 2,
        Action.memStoreMatrix2: 1,
        Action.memStoreMatrix4: 2,
        Action.memStoreMatrix8: 4,
        Action.memStoreMatrix16: 8,
    ]);

    const mem = new ComponentModel("MEM1", memTable, true);

    const inTable = new WeightTable(ComponentCategory.inputManager, [
        Action.inManualCsv2: 1,
        Action.inManualCsv4: 2,
        Action.inManualCsv8: 4,
        Action.inManualCsv16: 8,
        Action.inRandom2: 2,
        Action.inRandom4: 3,
        Action.inRandom8: 5,
        Action.inRandom16: 9,
    ]);

    const inp = new ComponentModel("ENT1", inTable, true);

    const outTable = new WeightTable(ComponentCategory.outputController, [
        Action.outTraceStep: 1,
        Action.outMatrix2: 1,
        Action.outMatrix4: 2,
        Action.outMatrix8: 4,
        Action.outMatrix16: 8,
        Action.outScalar: 1,
    ]);

    const outp = new ComponentModel("SOR1", outTable, true);

    const computerModel = new ComputerModel("ORD1", pu, mem, inp, outp, true);
    return new Computer(computerModel, new StandardComponentFactory());
}

Computer createComputer2()
{
    const puTable = new WeightTable(ComponentCategory.processingUnit, [
        Action.puAdd: 5,
        Action.puSubstract: 5,
        Action.puMultiply: 3,
        Action.puSwap: 3,
        Action.puSum: 4,
    ]);

    const pu = new ComponentModel("UT2", puTable, true);

    const memTable = new WeightTable(ComponentCategory.memory, [
        Action.memLoadBlock: 1,
        Action.memWriteBlock: 3,
        Action.memStoreMatrix2: 1,
        Action.memStoreMatrix4: 2,
        Action.memStoreMatrix8: 3,
        Action.memStoreMatrix16: 5,
    ]);

    const mem = new ComponentModel("MEM2", memTable, true);

    const inTable = new WeightTable(ComponentCategory.inputManager, [
        Action.inManualCsv2: 2,
        Action.inManualCsv4: 3,
        Action.inManualCsv8: 5,
        Action.inManualCsv16: 7,
        Action.inRandom2: 1,
        Action.inRandom4: 2,
        Action.inRandom8: 4,
        Action.inRandom16: 6,
    ]);

    const inp = new ComponentModel("ENT2", inTable, true);

    const outTable = new WeightTable(ComponentCategory.outputController, [
        Action.outTraceStep: 2,
        Action.outMatrix2: 1,
        Action.outMatrix4: 1,
        Action.outMatrix8: 2,
        Action.outMatrix16: 4,
        Action.outScalar: 1,
    ]);

    const outp = new ComponentModel("SOR2", outTable, true);

    const computerModel = new ComputerModel("ORD2", pu, mem, inp, outp, true);
    return new Computer(computerModel, new StandardComponentFactory());
}

Computer createComputer3()
{
    const puTable = new WeightTable(ComponentCategory.processingUnit, [
        Action.puAdd: 1,
        Action.puSubstract: 1,
        Action.puMultiply: 8,
        Action.puSwap: 2,
        Action.puSum: 2,
    ]);

    const pu = new ComponentModel("UT3", puTable, true);

    const memTable = new WeightTable(ComponentCategory.memory, [
        Action.memLoadBlock: 3,
        Action.memWriteBlock: 1,
        Action.memStoreMatrix2: 2,
        Action.memStoreMatrix4: 3,
        Action.memStoreMatrix8: 5,
        Action.memStoreMatrix16: 7,
    ]);

    const mem = new ComponentModel("MEM3", memTable, true);

    const inTable = new WeightTable(ComponentCategory.inputManager, [
        Action.inManualCsv2: 1,
        Action.inManualCsv4: 2,
        Action.inManualCsv8: 3,
        Action.inManualCsv16: 6,
        Action.inRandom2: 2,
        Action.inRandom4: 3,
        Action.inRandom8: 4,
        Action.inRandom16: 7,
    ]);

    const inp = new ComponentModel("ENT3", inTable, true);

    const outTable = new WeightTable(ComponentCategory.outputController, [
        Action.outTraceStep: 3,
        Action.outMatrix2: 1,
        Action.outMatrix4: 2,
        Action.outMatrix8: 3,
        Action.outMatrix16: 5,
        Action.outScalar: 1,
    ]);

    const outp = new ComponentModel("SOR3", outTable, true);

    const computerModel = new ComputerModel("ORD3", pu, mem, inp, outp, true);
    return new Computer(computerModel, new StandardComponentFactory());
}
