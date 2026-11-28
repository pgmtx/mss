module mss.impl.standard_memory;

import mss.core.component : Memory;
import mss.core.matrix : Block, BlockPosition, Matrix, MatrixSize;
import mss.core.error : MatrixNotFoundException;
import mss.core.weight : ComponentModel;
import std.exception : enforce;

class StandardMemory : Memory
{
    this(ComponentModel model)
    {
        _model = model;
    }

    override void storeMatrix(const string name, Matrix matrix)
    {
        _matrices[name] = matrix;
    }

    override Matrix allocate(const string name, MatrixSize size)
    {
        _matrices[name] = new Matrix(size);
        return _matrices[name];
    }

    override void free(const string name)
    {
        _matrices.remove(name);
    }

    override Block loadBlock(const string name, BlockPosition position) const
    {
        enforce(contains(name), new MatrixNotFoundException(name));
        return _matrices[name].getBlock(position);
    }

    override void writeBlock(const string name, BlockPosition position, Block block)
    {
        enforce(contains(name), new MatrixNotFoundException(name));
        _matrices[name] = _matrices[name].withBlock(position, block);
    }

    override const(Matrix) read(const string name) const
    {
        enforce(contains(name), new MatrixNotFoundException(name));
        return _matrices[name];
    }

    override bool contains(const string name) const
    {
        const Matrix* m = name in _matrices;
        return m != null;
    }

    override ComponentModel getModel() const
    {
        return _model;
    }

    // En D, les dictionnaires s'écrivent type_valeur[type_cle].
    private Matrix[string] _matrices;
    private ComponentModel _model;
}
