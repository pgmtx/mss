module mss.core.component.input_manager;

import mss.core.component.component;
import mss.core.matrix : InputMatrix, Matrix, MatrixSize;

interface InputManager : Component
{
    string readLine(const string prompt);
    int readInt(const string prompt, int min, int max);
    Matrix readCsv(const string path);
    Matrix enterMatrix(MatrixSize size);
    Matrix generateRandom(MatrixSize size);
    Matrix acquire(InputMatrix input);
}
