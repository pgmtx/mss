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
    import mss.core.matrix : getBlocksPerSide;

    const first = computer.readMatrix(firstName);
    const second = computer.readMatrix(secondName);
    immutable size = first.getSize();
    assert(second.getSize() == size);

    computer.allocate(resultName, size);
    foreach (position; first.getBlockPositions())
    {
        Block sum = Block(0, 0, 0, 0);
        foreach (k; 0 .. getBlocksPerSide(size))
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

unittest
{
    import mss.impl : StandardComponentFactory;
    import mss.session : ord1;

    auto computer = new Computer(ord1, new StandardComponentFactory());

    // dfmt off
    const matrix1 = Matrix.of([
        [3, -1, 4, 2, 0, 5, -2, 1, 6, -3, 2, 4, -5, 1, 3, -2],
        [-2, 5, 1, -4, 3, 0, 6, -1, 2, 4, -3, 1, 5, -2, 0, 3],
        [1, 3, -5, 2, 4, -1, 0, 6, -2, 5, 1, -3, 2, 4, -1, 0],
        [4, 0, 2, -3, 1, 6, -4, 5, 0, -2, 3, 1, -1, 2, 5, -3],
        [-1, 2, 6, 0, -5, 3, 1, -2, 4, 0, 5, -3, 2, -4, 1, 6],
        [5, -3, 0, 1, 2, -4, 3, 6, -1, 2, 0, 4, -2, 5, -3, 1],
        [2, 4, -1, 5, -3, 0, 6, 2, 1, -5, 3, -2, 4, 0, -1, 5],
        [0, -2, 3, 6, 1, 4, -5, 2, -3, 1, 5, 0, 6, -1, 2, -4],
        [-4, 1, 5, -2, 3, 6, 0, -1, 4, 2, -5, 3, 1, 0, 6, -3],
        [6, 2, -3, 0, 5, -1, 4, 3, -2, 1, 0, -4, 2, 5, -1, 3],
        [1, -5, 2, 4, -1, 3, 0, 6, 5, -2, 4, 1, -3, 2, 0, 6],
        [-3, 6, 1, -2, 4, 0, 5, -1, 3, 2, -4, 6, 0, -5, 1, 4],
        [2, 0, -4, 3, 6, -2, 1, 5, -1, 4, 3, -5, 2, 6, 0, -3],
        [5, -1, 3, 0, -2, 4, 6, -3, 1, 5, -4, 2, 0, 3, -5, 1],
        [-2, 3, 0, 5, 1, -4, 2, 6, -3, 0, 4, 1, 5, -2, 3, -1],
        [4, 1, -2, 6, 0, 3, -1, 5, 2, -4, 6, 0, -3, 1, 5, -2],
    ]);

    const matrix2 = Matrix.of([
        [1, 4, -2, 3, 5, 0, -1, 6, 2, -3, 4, 1, 0, -5, 2, 3],
        [-3, 2, 5, 0, -1, 4, 6, -2, 1, 3, 0, -4, 5, 2, -1, 6],
        [4, -1, 0, 6, 2, -3, 5, 1, -4, 2, 3, 0, 6, -2, 1, 5],
        [2, 5, -3, 1, 0, 6, -4, 3, 5, -1, 2, 4, -2, 0, 6, -3],
        [0, -2, 4, 5, -3, 1, 2, -5, 6, 3, -1, 0, 4, 2, -3, 1],
        [6, 3, 1, -4, 2, 0, 5, -1, 3, 4, -2, 6, 1, -3, 0, 5],
        [-1, 0, 6, 2, 4, -5, 3, 1, 0, 2, 5, -3, 4, 6, -2, 1],
        [5, -3, 2, 4, 1, 6, 0, -2, 3, 5, -4, 1, 2, 0, 6, -1],
        [3, 1, -5, 0, 6, 2, -3, 4, 1, -2, 0, 5, -4, 3, 6, 2],
        [-2, 6, 3, 1, -4, 5, 2, 0, 6, -1, 4, 3, 0, -5, 1, 2],
        [4, 0, 1, -3, 5, 2, 6, -4, 0, 3, 1, -2, 5, 6, -1, 4],
        [1, 5, -4, 2, 3, -1, 0, 6, -2, 4, 5, 1, -3, 2, 0, 6],
        [-5, 2, 6, 3, 0, 4, -1, 5, 2, -3, 6, 0, 1, 4, -2, 3],
        [3, -4, 0, 5, 1, 2, 6, -3, 4, 0, -2, 5, 3, 1, 6, -1],
        [2, 6, -1, 4, -3, 0, 5, 2, 1, -4, 3, 6, -2, 0, 5, 1],
        [0, 3, 5, -2, 6, 1, -4, 4, 2, 5, -3, 0, 6, -1, 3, 2],
    ]);

    const expected = Matrix.of([
        [133, 34, -118, 20, 77, -11, 44, 31, -10, 21, -3, 96, -32, -16, 89, 60],
        [-76, 36, 127, 33, 1, -4, 32, 29, 24, 30, 61, -38, 64, 45, -53, 80],
        [-15, -9, 85, 41, -45, 121, 26, -64, 127, 20, -26, 11, 46, 3, 37, -24],
        [109, 4, -36, 38, 17, 19, 102, -27, 15, 22, -23, 74, 11, -33, 52, 61],
        [33, 52, 35, -53, 97, -5, 24, 49, -40, 25, 21, -3, 71, 18, 17, 85],
        [35, -23, -3, 87, 50, 24, -14, 17, 48, 40, 13, 6, 28, -6, 61, -13],
        [1, 20, 70, -10, 107, 34, -15, 53, 17, 33, 19, -34, 73, 83, 38, 24],
        [49, 46, -9, 26, -33, 84, 41, -4, 45, -13, 44, 58, 0, -7, 18, 28],
        [38, 46, -11, 59, -45, -20, 82, 13, 8, 0, 35, 94, -24, -15, 19, 72],
        [-16, -20, 104, 63, 22, 46, 27, -24, 103, 16, -6, -9, 90, 8, 21, -4],
        [137, 7, -47, 3, 128, 38, -28, 33, 35, 68, -50, 83, 26, 5, 132, 8],
        [-49, 67, 68, 18, 12, -22, 5, 49, -1, 68, 47, -35, 31, 41, -40, 92],
        [8, -37, 62, 72, -45, 107, 46, -86, 135, -14, -12, 30, 42, 24, 46, -49],
        [1, 42, 19, 21, 63, -39, 10, 70, 24, 9, 67, 27, 22, -53, 1, 53],
        [-14, 26, 65, 57, -22, 85, 23, -3, 34, 21, 50, -32, 41, 78, 20, 8],
        [115, 36, -63, 10, 54, 65, 44, -8, 48, 13, -18, 71, -10, 24, 106, 10],
    ]);
    // dfmt on

    computer.acquire([
        new InputMatrix("A", matrix1, AcquisitionMode.manual, "console"),
        new InputMatrix("B", matrix2, AcquisitionMode.manual, "console"),
    ]);

    const product = multiply(computer, "A", "B", "C");
    assert(product == expected);
}

long sum(Computer computer, const string matrixName, const string resultName)
{
    const matrix = computer.readMatrix(matrixName);
    long total = 0;

    foreach (position; matrix.getBlockPositions())
    {
        immutable block = computer.loadBlock(matrixName, position);
        immutable blockResult = computer.sum(block);
        total = computer.add(Block(total, 0, 0, 0), blockResult).topLeft;
    }

    computer.showScalar(resultName, total);
    return total;
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

    const total = sum(computer, "A", "B");
    enum expected = 136;
    assert(total == expected);
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
