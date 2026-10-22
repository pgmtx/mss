module mss.core.component.memory;

import mss.core.matrix.matrix;
import mss.core.matrix.matrix_size;
import mss.core.matrix.block;
import mss.core.matrix.block_position;

interface Memory
{
    void storeMatrix(string name, Matrix matrix);

    Matrix allocate(string name, MatrixSize size);
    void free(string name);

    Block loadBlock(string name, BlockPosition position);
    void writeBlock(string name, BlockPosition position, Block block);

    Matrix read(string name);
    bool contains(string name);
}
