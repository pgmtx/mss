module mss.core.component.memory;

import mss.core.matrix.matrix;
import mss.core.matrix.matrix_size;
import mss.core.matrix.block;
import mss.core.matrix.block_position;

interface Memory
{
    void storeMatrix(const string name, Matrix matrix);

    Matrix allocate(const string name, MatrixSize size);
    void free(const string name);

    Block loadBlock(const string name, BlockPosition position);
    void writeBlock(const string name, BlockPosition position, Block block);

    Matrix read(const string name);
    bool contains(const string name);
}
