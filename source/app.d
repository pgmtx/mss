import mss.console;

import mss.core : ComponentCategory;
import mss.execution;
import mss.impl : StandardComponentFactory;
import mss.session;

void main()
{
    auto factory = new StandardComponentFactory();
    auto input = factory.createInputManager(ord1.getModel(ComponentCategory.inputManager));
    auto output = factory.createOutputController(ord1.getModel(ComponentCategory.outputController));

    TestPlan[] plans;
    RunResult[] results;

    output.showMessage("=== MSS ===\n");

    bool quit = false;
    while (!quit)
    {
        output.showMessage("----------------\n");
        output.showMessage("1. Creer un plan\n");
        output.showMessage("2. Lister les plans\n");
        output.showMessage("3. Executer un plan\n");
        output.showMessage("4. Comparer les resultats d'un plan\n");
        output.showMessage("0. Quitter\n");

        const choice = input.readInt("Choix : ", 0, 4);
        switch (choice)
        {
        case 0:
            quit = true;
            return;
        case 1:
            createPlan(input, output, plans);
            break;
        case 2:
            listPlans(output, plans);
            break;
        case 3:
            executePlan(input, output, factory, plans, results);
            break;
        case 4:
            compareResults(input, output, results);
            break;
        default:
            break;
        }
    }
}
