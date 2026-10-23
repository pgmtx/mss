module mss.core.matrix.input_matrix;

import mss.core.matrix.matrix;
import mss.core.matrix.acquisition_mode;

class InputMatrix
{
    InputMatrix withValues(Matrix matrix) const pure nothrow
    {
        // placeholder
        return new InputMatrix;
    }

    AcquisitionMode getMode() const pure nothrow
    {
        return _mode;
    }

private:
    string _name;
    Matrix _matrix;
    AcquisitionMode _mode;
    string _source;
}
