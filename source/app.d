import mss.core;
import mss.execution;
import mss.impl : StandardComponentFactory;
import mss.session;
import std.format : format;

void main()
{
    auto factory = new StandardComponentFactory();
    auto input = factory.createInputManager(ord1.getModel(ComponentCategory.inputManager));
    auto output = factory.createOutputController(ord1.getModel(ComponentCategory.outputController));

    TestPlan[] plans;
    RunResult[] results;

    bool quit = false;
    while (!quit)
    {
        output.showMessage("=== MSS ===\n");
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

void createPlan(InputManager input, OutputController output, ref TestPlan[] plans)
{
    const name = input.readLine("Nom du plan : ");
    if (name.length == 0)
    {
        output.showMessage("Le nom ne peut pas etre vide.\n");
        return;
    }

    auto plan = new TestPlan(name);

    try
    {
        bool addAnotherMatrix = true;
        while (addAnotherMatrix)
        {
            const matrixName = input.readLine("Nom de la matrice : ");
            output.showMessage("\nMode : 1. Manuel  2. CSV  3. Aleatoire\n");
            const modeChoice = input.readInt("Choix : ", 1, 3);

            Matrix matrix;
            AcquisitionMode mode;
            string source;

            if (modeChoice == 2)
            {
                mode = AcquisitionMode.csv;
                source = input.readLine("Chemin du fichier CSV : ");
                matrix = input.readCsv(source);
            }
            else
            {
                output.showMessage("\nTaille : 1. 2x2  2. 4x4  3. 8x8  4. 16x16\n");
                const sizeChoice = input.readInt("Choix : ", 1, 4);

                MatrixSize size;
                switch (sizeChoice)
                {
                case 1:
                    size = MatrixSize.s2;
                    break;
                case 2:
                    size = MatrixSize.s4;
                    break;
                case 3:
                    size = MatrixSize.s8;
                    break;
                default:
                    size = MatrixSize.s16;
                    break;
                }

                if (modeChoice == 1)
                {
                    mode = AcquisitionMode.manual;
                    source = "console";
                    matrix = input.enterMatrix(size);
                }
                else
                {
                    mode = AcquisitionMode.random;
                    source = "aleatoire";
                    matrix = input.generateRandom(size);
                }
            }

            plan.addInput(new InputMatrix(matrixName, matrix, mode, source));
            addAnotherMatrix = input.readInt("Ajouter une autre matrice ? 1. Oui  0. Non : ",
                    0, 1) == 1;
        }

        bool addAnotherStep = true;
        int position = 1;

        while (addAnotherStep)
        {
            output.showMessage("\nOperation : 1. Addition  2. Soustraction  3. Multiplication\n"
                    ~ "            4. Rotation  5. Somme\n");
            const operationChoice = input.readInt("Choix : ", 1, 5);

            OperationType operation;
            switch (operationChoice)
            {
            case 1:
                operation = OperationType.addition;
                break;
            case 2:
                operation = OperationType.substraction;
                break;
            case 3:
                operation = OperationType.multiplication;
                break;
            case 4:
                operation = OperationType.rotation;
                break;
            default:
                operation = OperationType.sum;
                break;
            }

            string[] inputNames;
            const arity = getArity(operation);
            if (arity == 1)
            {
                inputNames ~= input.readLine("Nom de l'entree : ");
            }
            else
            {
                inputNames ~= input.readLine("Nom de la premiere entree : ");
                inputNames ~= input.readLine("Nom de la deuxieme entree : ");
            }

            const resultName = input.readLine("Nom du resultat : ");
            plan.addStep(new PlanStep(position, operation, inputNames, resultName));
            ++position;

            addAnotherStep = input.readInt("Ajouter une autre etape ? 1. Oui  0. Non : ", 0, 1) == 1;
        }

        PlanValidator.validate(plan);
    }
    catch (MssException e)
    {
        output.showError(e);
        output.showMessage("\nPlan non ajoute.\n");
        return;
    }

    plans ~= plan;
    output.showMessage("Plan cree.\n");
}

void executePlan(InputManager input, OutputController output,
        StandardComponentFactory factory, TestPlan[] plans, ref RunResult[] results)
{
    if (plans.length == 0)
    {
        output.showMessage("Aucun plan a executer.\n");
        return;
    }

    listPlans(output, plans);
    const planIndex = input.readInt("Plan a executer : ", 1, cast(int) plans.length) - 1;

    output.showMessage("Ordinateur : 1. ORD1  2. ORD2  3. ORD3\n");
    const modelChoice = input.readInt("Choix : ", 1, 3);
    const model = selectModel(modelChoice);

    try
    {
        auto result = PlanRunner.run(plans[planIndex], model, factory);
        results ~= result;

        output.showMessage("Execution terminee : " ~ statusName(result.getStatus()) ~ "\n");
        output.showMessage(format("Cout total : %d\n", result.getLog().getTotal()));
        output.showMessage(format("Derniere etape terminee : %d\n", result.getLastCompletedStep()));
    }
    catch (MssException e)
    {
        output.showError(e);
    }
}

void listPlans(OutputController output, const TestPlan[] plans)
{
    if (plans.length == 0)
    {
        output.showMessage("Aucun plan.\n");
        return;
    }

    foreach (i, plan; plans)
    {
        // dfmt off
        output.showMessage(format(
            "%d. %s | revision %d\n", i+1, plan.getName(), plan.getRevision())
        );
        // dfmt on
    }
}

const(ComputerModel) selectModel(int modelChoice)
{
    switch (modelChoice)
    {
    case 1:
        return ord1;
    case 2:
        return ord2;
    default:
        return ord3;
    }
}

void compareResults(InputManager input, OutputController output, RunResult[] results)
{
    if (results.length == 0)
    {
        output.showMessage("Aucun resultat a comparer\n");
        return;
    }

    output.showMessage("Executions enregistrees :\n");
    foreach (i, result; results)
    {
        // dfmt off
        output.showMessage(format(
            "%d. %s revision %d | %s | cout %d\n",
            i+1,
            result.getPlanName(),
            result.getPlanRevision(),
            statusName(result.getStatus()),
            result.getLog().getTotal(),
        ));
        // dfmt on
    }

    // dfmt off
    const selected = input.readInt(
        "Selectionne une executation pour choisir le plan",
        1, cast(int)results.length - 1,
    );
    // dfmt on

    const reference = results[selected];
    RunResult[] comparable;

    foreach (result; results)
    {
        if (result.getPlanName() == reference.getPlanName()
                && result.getPlanRevision() == reference.getPlanRevision())
        {
            comparable ~= result;
        }
    }

    auto comparison = Comparison(comparable);
    const ranking = comparison.ranking();

    output.showMessage("Classement par cout croissant :\n");
    // dfmt off
    foreach (i, result; ranking)
    {
        output.showMessage(format(
            "%d. cout %d | %s\n",
            i+1, result.getLog().getTotal, statusName(result.getStatus())
        ));
    }

    foreach (group; comparison.ties())
    {
        output.showMessage(format(
            "Egalite entre %d executions, cout %d\n",
            group.length,
            group[0].getLog().getTotal(),
        ));
    }
    // dfmt on
}

string statusName(RunStatus status)
{
    final switch (status)
    {
    case RunStatus.done:
        return "terminee";
    case RunStatus.nonCompliant:
        return "non conforme";
    case RunStatus.incomplete:
        return "incomplete";
    }
}
