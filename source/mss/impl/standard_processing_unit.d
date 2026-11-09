module mss.impl.standard_processing_unit;

import mss.core.component : ProcessingUnit;
import mss.core.error : OverflowException;
import mss.core.matrix : Block, BlockCell, BlockPair;
import core.checkedint : adds, subs, muls;

version (unittest)
{
    import std.exception : assertThrown;
}

class StandardProcessingUnit : ProcessingUnit
{
    Block add(Block a, Block b)
    {
        // dfmt off
        return Block(
            _checkedAdd(a.topLeft, b.topLeft),
            _checkedAdd(a.topRight, b.topRight),
            _checkedAdd(a.bottomLeft, b.bottomLeft),
            _checkedAdd(a.bottomRight, b.bottomRight)
        );
        // dfmt on
    }

    unittest
    {
        auto pu = new StandardProcessingUnit;
        immutable a = Block(-19, 80, -45, 23);
        immutable b = Block(20, 41, 66, -14);
        immutable c = Block(1, 121, 21, 9);
        assert(pu.add(a, b) == c);
        assertThrown!OverflowException(pu.add(Block(long.max, 2, 3, 7), Block(1, 2, 3, 4)));
    }

    Block substract(Block a, Block b)
    {
        // dfmt off
        return Block(
            _checkedSub(a.topLeft, b.topLeft),
            _checkedSub(a.topRight, b.topRight),
            _checkedSub(a.bottomLeft, b.bottomLeft),
            _checkedSub(a.bottomRight, b.bottomRight)
        );
        // dfmt on
    }

    unittest
    {
        auto pu = new StandardProcessingUnit;
        immutable a = Block(48, 98, -39, 70);
        immutable b = Block(74, 79, 25, -62);
        immutable c = Block(-26, 19, -64, 132);
        assert(pu.substract(a, b) == c);
        assertThrown!OverflowException(pu.substract(Block(long.min, 2, 3, 7), Block(1, 2, 3, 4)));
    }

    Block multiply(Block a, Block b)
    {
        // dfmt off
        return Block(
            _checkedMulAdd(a.topLeft, b.topLeft, a.topRight, b.bottomLeft),
            _checkedMulAdd(a.topLeft, b.topRight, a.topRight, b.bottomRight),
            _checkedMulAdd(a.bottomLeft, b.topLeft, a.bottomRight, b.bottomLeft),
            _checkedMulAdd(a.bottomLeft, b.topRight, a.bottomRight, b.bottomRight)
        );
        // dfmt on
    }

    unittest
    {
        auto pu = new StandardProcessingUnit;
        immutable a = Block(25, -68, -38, -4);
        immutable b = Block(-9, 22, 18, -16);
        immutable c = Block(-1449, 1638, 270, -772);
        assert(pu.multiply(a, b) == c);
        assertThrown!OverflowException(pu.multiply(Block(long.max, 2, 3, 7), Block(2, 2, 3, 4)));
    }

    Block swap(Block block, BlockCell cell1, BlockCell cell2)
    {
        // dfmt off
        return block.withCell(cell1, block.get(cell2))
                    .withCell(cell2, block.get(cell1));
        // dfmt on
    }

    unittest
    {
        auto pu = new StandardProcessingUnit;
        auto base = Block(38, 74, 68, 9);
        assert(pu.swap(base, BlockCell.topLeft, BlockCell.topRight) == Block(74, 38, 68, 9));
        assert(pu.swap(base, BlockCell.topRight, BlockCell.bottomLeft) == Block(38, 68, 74, 9));
    }

    BlockPair swap(Block block1, BlockCell cell1, Block block2, BlockCell cell2)
    {
        // dfmt off
        return BlockPair(
            block1.withCell(cell1, block2.get(cell2)),
            block2.withCell(cell2, block1.get(cell1))
        );
        // dfmt on
    }

    unittest
    {
        auto pu = new StandardProcessingUnit;
        auto block1 = Block(35, 44, 82, 27);
        auto block2 = Block(93, 37, 3, 86);

        immutable swapResult = pu.swap(block1, BlockCell.topLeft, block2, BlockCell.topLeft);
        assert(swapResult.first == Block(93, 44, 82, 27));
        assert(swapResult.second == Block(35, 37, 3, 86));

        immutable swapResult2 = pu.swap(block1, BlockCell.bottomLeft, block2, BlockCell.topRight);
        assert(swapResult2.first == Block(35, 44, 37, 27));
        assert(swapResult2.second == Block(93, 82, 3, 86));
    }

    Block sum(Block block)
    {
        import std.traits : EnumMembers;

        long cellSum = 0;
        foreach (cell; EnumMembers!BlockCell)
        {
            cellSum = _checkedAdd(cellSum, block.get(cell));
        }
        return Block(cellSum, 0, 0, 0);
    }

    unittest
    {
        auto pu = new StandardProcessingUnit;
        immutable block = Block(-82, -56, 57, -15);
        assert(pu.sum(block) == Block(-96, 0, 0, 0));
        immutable block2 = Block(long.max / 2, long.max / 2, 1, 2);
        assertThrown!OverflowException(pu.sum(block2));
    }

private:
    long _checkedMulAdd(long a, long b, long c, long d)
    {
        return _checkedAdd(_checkedMul(a, b), _checkedMul(c, d));
    }

    long _checkedAdd(long a, long b)
    {
        return _checkedOp!(adds)(a, b);
    }

    long _checkedSub(long a, long b)
    {
        return _checkedOp!(subs)(a, b);
    }

    long _checkedMul(long a, long b)
    {
        return _checkedOp!(muls)(a, b);
    }

    long _checkedOp(alias func)(long a, long b)
    {
        bool overflow;
        immutable result = func(a, b, overflow);
        if (overflow)
        {
            throw OverflowException.badComputation();
        }
        return result;
    }
}
