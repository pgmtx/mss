module mss.operations;

import mss.core.computer;
import mss.core.matrix;

Matrix add(Computer computer, const Matrix a, const Matrix b)
in (a.getSize() == b.getSize())
{
    Matrix result = new Matrix(a.getSize());
    foreach (position; a.getBlockPositions())
    {
        immutable blockSum = computer.add(a.getBlock(position), b.getBlock(position));
        result = result.withBlock(position, blockSum);
    }
    return result;
}

unittest
{
    import mss.session;
    import mss.impl : StandardComponentFactory;

    // dfmt off
    const matrix1 = Matrix.of([
        [42, -17, 8, 91],
        [-63, 25, -4, 70],
        [11, -88, 36, -29],
        [54, 3, -72, 19],
    ]);

    const matrix2 = Matrix.of([
        [-9, 67, -41, 22],
        [83, -15, 6, -94],
        [31, -58, 77, -2],
        [-36, 49, 14, -80],
    ]);

    const sum = Matrix.of([
        [33, 50, -33, 113],
        [20, 10, 2, -24],
        [42, -146, 113, -31],
        [18, 52, -58, -61],
    ]);
    // dfmt on

    auto computer = new Computer(ord1, new StandardComponentFactory());
    assert(add(computer, matrix1, matrix2) == sum);
}
