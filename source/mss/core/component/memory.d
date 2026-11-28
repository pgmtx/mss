module mss.core.component.memory;

import mss.core.component.component;
import mss.core.matrix : Block, BlockPosition, Matrix, MatrixSize;

interface Memory : Component
{
    void storeMatrix(const string name, Matrix matrix);

    Matrix allocate(const string name, MatrixSize size);
    void free(const string name);

    Block loadBlock(const string name, BlockPosition position) const;
    void writeBlock(const string name, BlockPosition position, Block block);

    const(Matrix) read(const string name) const;
    bool contains(const string name) const;
}
