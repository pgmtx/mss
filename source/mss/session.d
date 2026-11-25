module mss.session;

import mss.core;

const ComponentModel ut1, ut2, ut3;
const ComponentModel mem1, mem2, mem3;
const ComponentModel ent1, ent2, ent3;
const ComponentModel sor1, sor2, sor3;

const ComputerModel ord1, ord2, ord3;

private ComponentModel createComponentModel(const string name,
        ComponentCategory category, const int[Action] weights)
{
    const weightTable = new WeightTable(category, weights);
    return new ComponentModel(name, weightTable, true);
}

// S'exécute avant main.
// C'est le seul cas où on peut retarder l'initialisation d'une variable const.
shared static this()
{
    ut1 = createComponentModel("UT1", ComponentCategory.processingUnit, [
        Action.puAdd: 3,
        Action.puSubstract: 3,
        Action.puMultiply: 6,
        Action.puSwap: 2,
        Action.puSum: 3,
    ]);

    ut2 = createComponentModel("UT2", ComponentCategory.processingUnit, [
        Action.puAdd: 5,
        Action.puSubstract: 5,
        Action.puMultiply: 3,
        Action.puSwap: 3,
        Action.puSum: 4,
    ]);

    ut3 = createComponentModel("UT3", ComponentCategory.processingUnit, [
        Action.puAdd: 1,
        Action.puSubstract: 1,
        Action.puMultiply: 8,
        Action.puSwap: 2,
        Action.puSum: 2,
    ]);

    mem1 = createComponentModel("MEM1", ComponentCategory.memory, [
        Action.memLoadBlock: 2,
        Action.memWriteBlock: 2,
        Action.memStoreMatrix2: 1,
        Action.memStoreMatrix4: 2,
        Action.memStoreMatrix8: 4,
        Action.memStoreMatrix16: 8,
    ]);

    mem2 = createComponentModel("MEM2", ComponentCategory.memory, [
        Action.memLoadBlock: 1,
        Action.memWriteBlock: 3,
        Action.memStoreMatrix2: 1,
        Action.memStoreMatrix4: 2,
        Action.memStoreMatrix8: 3,
        Action.memStoreMatrix16: 5,
    ]);

    mem3 = createComponentModel("MEM3", ComponentCategory.memory, [
        Action.memLoadBlock: 3,
        Action.memWriteBlock: 1,
        Action.memStoreMatrix2: 2,
        Action.memStoreMatrix4: 3,
        Action.memStoreMatrix8: 5,
        Action.memStoreMatrix16: 7,
    ]);

    ent1 = createComponentModel("ENT1", ComponentCategory.inputManager, [
        Action.inManualCsv2: 1,
        Action.inManualCsv4: 2,
        Action.inManualCsv8: 4,
        Action.inManualCsv16: 8,
        Action.inRandom2: 2,
        Action.inRandom4: 3,
        Action.inRandom8: 5,
        Action.inRandom16: 9,
    ]);

    ent2 = createComponentModel("ENT2", ComponentCategory.inputManager, [
        Action.inManualCsv2: 2,
        Action.inManualCsv4: 3,
        Action.inManualCsv8: 5,
        Action.inManualCsv16: 7,
        Action.inRandom2: 1,
        Action.inRandom4: 2,
        Action.inRandom8: 4,
        Action.inRandom16: 6,
    ]);

    ent3 = createComponentModel("ENT3", ComponentCategory.inputManager, [
        Action.inManualCsv2: 1,
        Action.inManualCsv4: 2,
        Action.inManualCsv8: 3,
        Action.inManualCsv16: 6,
        Action.inRandom2: 2,
        Action.inRandom4: 3,
        Action.inRandom8: 4,
        Action.inRandom16: 7,
    ]);

    sor1 = createComponentModel("SOR1", ComponentCategory.outputController, [
        Action.outTraceStep: 1,
        Action.outMatrix2: 1,
        Action.outMatrix4: 2,
        Action.outMatrix8: 4,
        Action.outMatrix16: 8,
        Action.outScalar: 1,
    ]);

    sor2 = createComponentModel("SOR2", ComponentCategory.outputController, [
        Action.outTraceStep: 2,
        Action.outMatrix2: 1,
        Action.outMatrix4: 1,
        Action.outMatrix8: 2,
        Action.outMatrix16: 4,
        Action.outScalar: 1,
    ]);

    sor3 = createComponentModel("SOR3", ComponentCategory.outputController, [
        Action.outTraceStep: 3,
        Action.outMatrix2: 1,
        Action.outMatrix4: 2,
        Action.outMatrix8: 3,
        Action.outMatrix16: 5,
        Action.outScalar: 1,
    ]);

    ord1 = new ComputerModel("ORD1", ut1, mem1, ent1, sor1, true);
    ord2 = new ComputerModel("ORD2", ut2, mem1, ent1, sor1, true);
    ord3 = new ComputerModel("ORD3", ut3, mem1, ent1, sor1, true);
}
