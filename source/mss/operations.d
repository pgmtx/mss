module mss.operations;

import mss.core.computer;
import mss.core.matrix;

const(Matrix) add(Computer computer, const string firstName,
        const string secondName, const string resultName)
{
    const first = computer.readMatrix(firstName);
    const second = computer.readMatrix(secondName);
    assert(first.getSize() == second.getSize());

    computer.allocate(resultName, first.getSize());
    foreach (position; first.getBlockPositions())
    {
        immutable firstBlock = computer.loadBlock(firstName, position);
        immutable secondBlock = computer.loadBlock(secondName, position);
        immutable blockSum = computer.add(firstBlock, secondBlock);
        computer.writeBlock(resultName, position, blockSum);
    }

    return computer.readMatrix(resultName);
}

const(Matrix) substract(Computer computer, const string firstName,
        const string secondName, const string resultName)
{
    const first = computer.readMatrix(firstName);
    const second = computer.readMatrix(secondName);
    assert(first.getSize() == second.getSize());

    computer.allocate(resultName, first.getSize());
    foreach (position; first.getBlockPositions())
    {
        immutable firstBlock = computer.loadBlock(firstName, position);
        immutable secondBlock = computer.loadBlock(secondName, position);
        immutable blockDifference = computer.substract(firstBlock, secondBlock);
        computer.writeBlock(resultName, position, blockDifference);
    }

    return computer.readMatrix(resultName);
}

const(Matrix) multiply(Computer computer, const string firstName,
        const string secondName, const string resultName)
{
    import mss.core.matrix : getBlockCount;

    const first = computer.readMatrix(firstName);
    const second = computer.readMatrix(secondName);
    immutable size = first.getSize();
    assert(second.getSize() == size);

    computer.allocate(resultName, size);
    foreach (position; first.getBlockPositions())
    {
        Block sum = Block(0, 0, 0, 0);
        foreach (k; 0 .. getBlockCount(size))
        {
            immutable left = computer.loadBlock(firstName, BlockPosition(position.row, k));
            immutable right = computer.loadBlock(secondName, BlockPosition(k, position.column));
            immutable product = computer.multiply(left, right);
            sum = computer.add(sum, product);
        }

        computer.writeBlock(resultName, position, sum);
    }
    return computer.readMatrix(resultName);
}

long sum(Computer computer, const string matrixName, const string resultName)
{
    long total = 0;
    const matrix = computer.readMatrix(matrixName);

    foreach (position; matrix.getBlockPositions())
    {
        immutable block = computer.loadBlock(matrixName, position);
        immutable blockResult = computer.sum(block);
        total = computer.add(Block(total, 0, 0, 0), blockResult).topLeft;
    }

    return total;
}

const(Matrix) rotate(Computer computer, const string matrixName, const string resultName)
{
    import mss.core.matrix : getBlocksPerSide;

    const matrix = computer.readMatrix(matrixName);
    immutable side = matrix.getRowsCount();

    if (matrixName != resultName)
    {
        computer.allocate(resultName, matrix.getSize());

        foreach (position; matrix.getBlockPositions())
        {
            immutable block = computer.loadBlock(matrixName, position);
            computer.writeBlock(resultName, position, block);
        }
    }

    immutable blocksPerSide = getBlocksPerSide(matrix.getSize());
    foreach (layer; 0 .. blocksPerSide)
    {
        CellLocation[] crown;

        // Haut, de gauche à droite
        foreach (column; layer .. side - layer)
        {
            crown ~= toCellLocation(layer, column);
        }

        // Droite, de haut en bas, sans le coin déjà ajouté
        foreach (row; layer + 1 .. side - layer)
        {
            crown ~= toCellLocation(row, side - layer - 1);
        }

        // Bas, de droite à gauche, sans le coin déjà ajouté
        if (side - layer - 1 != layer)
        {
            foreach_reverse (column; layer .. side - layer - 1)
            {
                crown ~= toCellLocation(side - layer - 1, column);
            }
        }

        // Gauche, du bas vers le haut, sans les coins déjà ajoutés.
        if (side - layer - 1 != layer)
        {
            foreach_reverse (row; layer + 1 .. side - layer - 1)
            {
                crown ~= toCellLocation(row, layer);
            }
        }

        // Échange horaire : la case courante reçoit la précédente
        foreach_reverse (i; 1 .. crown.length)
        {
            immutable first = crown[i];
            immutable second = crown[i - 1];

            if (first.position == second.position)
            {
                immutable block = computer.loadBlock(resultName, first.position);
                immutable exchanged = computer.swap(block, first.cell, second.cell);
                computer.writeBlock(resultName, first.position, exchanged);
            }
            else
            {
                immutable firstBlock = computer.loadBlock(resultName, first.position);
                immutable secondBlock = computer.loadBlock(resultName, second.position);
                immutable pair = computer.swap(firstBlock, first.cell, secondBlock, second.cell);
                computer.writeBlock(resultName, first.position, pair.first);
                computer.writeBlock(resultName, second.position, pair.second);
            }
        }
    }

    return computer.readMatrix(resultName);
}

unittest
{
    import mss.impl : StandardComponentFactory;
    import mss.session : ord1;

    auto computer = new Computer(ord1, new StandardComponentFactory());

    const matrix = Matrix.of([
        [1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]
    ]);
    computer.acquire([
        new InputMatrix("A", matrix, AcquisitionMode.manual, "console"),
    ]);

    const rotated = rotate(computer, "A", "B");
    const expected = Matrix.of([
        [5, 1, 2, 3], [9, 10, 6, 4], [13, 11, 7, 8], [14, 15, 16, 12]
    ]);
    assert(rotated == expected);
}

private immutable struct CellLocation
{
    BlockPosition position;
    BlockCell cell;
}

private CellLocation toCellLocation(size_t row, size_t column) pure
{
    BlockCell cell;
    if (row % 2 == 0)
    {
        cell = (column % 2 == 0) ? BlockCell.topLeft : BlockCell.topRight;
    }
    else
    {
        cell = (column % 2 == 0) ? BlockCell.bottomLeft : BlockCell.bottomRight;
    }
    return CellLocation(BlockPosition(row / 2, column / 2), cell);
}
