module mss.impl.standard_memory;

import mss.core.component : Memory;
import mss.core.matrix : Block, BlockPosition, Matrix, MatrixSize;
import mss.core.error : MatrixNotFoundException;
import std.exception : enforce;

class StandardMemory : Memory
{
    void storeMatrix(const string name, Matrix matrix)
    {
        _matrices[name] = matrix;
    }

    Matrix allocate(const string name, MatrixSize size)
    {
        _matrices[name] = new Matrix(size);
        return _matrices[name];
    }

    void free(const string name)
    {
        _matrices.remove(name);
    }

    Block loadBlock(const string name, BlockPosition position)
    {
        enforce!MatrixNotFoundException(contains(name), name);
        return _matrices[name].getBlock(position);
    }

    void writeBlock(const string name, BlockPosition position, Block block)
    {
        enforce!MatrixNotFoundException(contains(name), name);
        _matrices[name] = _matrices[name].withBlock(position, block);
    }

    Matrix read(const string name)
    {
        return _matrices[name];
    }

    bool contains(const string name)
    {
        Matrix* m = name in _matrices;
        return m != null;
    }

    private Matrix[string] _matrices;
}
