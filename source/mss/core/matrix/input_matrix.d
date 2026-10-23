module mss.core.matrix.input_matrix;

import mss.core.matrix.matrix;
import mss.core.matrix.acquisition_mode;

class InputMatrix
{
    InputMatrix withValues(Matrix matrix) pure nothrow
    {
        // placeholder
        return new InputMatrix;
    }

private:
    string _name;
    Matrix _matrix;
    AcquisitionMode _mode;
    string _source;
}
