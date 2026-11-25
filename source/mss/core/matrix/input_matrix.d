module mss.core.matrix.input_matrix;

import mss.core.matrix.matrix;
import mss.core.matrix.acquisition_mode;
import mss.core.matrix.matrix_size;
import mss.core.matrix.block : Block;
import mss.core.matrix.block_position : BlockPosition;

const class InputMatrix
{
    this(const string name, Matrix matrix, AcquisitionMode mode, const string source)
    {
        _name = name;
        _matrix = matrix;
        _mode = mode;
        _source = source;
    }

    InputMatrix withValues(Matrix matrix) const
    {
        return new InputMatrix(_name, matrix, _mode, _source);
    }

    string getName() const pure nothrow
    {
        return _name;
    }

    AcquisitionMode getMode() const pure nothrow
    {
        return _mode;
    }

    MatrixSize getSize() const pure nothrow
    {
        return _matrix.getSize();
    }

    string getSource() const pure nothrow
    {
        return _source;
    }

    Matrix getMatrix() const
    {
        return _matrix.copy();
    }

private:
    string _name;
    Matrix _matrix;
    AcquisitionMode _mode;
    string _source;
}

unittest
{
    const original = new InputMatrix("A", Matrix.of([[1, 2], [3, 4]]),
            AcquisitionMode.csv, "input.csv");
    const replacement = original.withValues(Matrix.of([[5, 6], [7, 8]]));

    assert(original.getName() == "A");
    assert(original.getMode() == AcquisitionMode.csv);
    assert(original.getSize() == MatrixSize.s2);
    assert(original.getSource() == "input.csv");
    assert(original.getMatrix().getBlock(BlockPosition(0, 0)) == Block(1, 2, 3, 4));
    assert(replacement.getMatrix().getBlock(BlockPosition(0, 0)) == Block(5, 6, 7, 8));
}
