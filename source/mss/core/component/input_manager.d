module mss.core.component.input_manager;

import mss.core.matrix.matrix;
import mss.core.matrix.matrix_size;
import mss.core.matrix.input_matrix;

interface InputManager
{
    string readLine(string prompt);
    int readInt(string prompt, int min, int max);
    Matrix readCsv(string path);
    Matrix enterMatrix(MatrixSize size);
    Matrix generateRandom(MatrixSize size);
    Matrix acquire(const InputMatrix input);
}
