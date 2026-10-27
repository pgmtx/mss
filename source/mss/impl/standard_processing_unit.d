module mss.impl.standard_processing_unit;

import mss.core.matrix : Block, BlockCell, BlockPair;

class StandardProcessingUnit
{
    Block add(Block a, Block b)
    {
        return Block(0, 0, 0, 0);
    }

    Block substract(Block a, Block b)
    {
        return Block(0, 0, 0, 0);
    }

    Block multiply(Block a, Block b)
    {
        return Block(0, 0, 0, 0);
    }

    Block swap(Block block, BlockCell cell1, BlockCell cell2)
    {
        return block.withCell(cell1, block.get(cell2)).withCell(cell2, block.get(cell1));
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
        return BlockPair(block1.withCell(cell1, block2.get(cell2)),
                block2.withCell(cell2, block1.get(cell1)));
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
        immutable s = block.get(BlockCell.topLeft) + block.get(
                BlockCell.topRight) + block.get(BlockCell.bottomLeft) + block.get(
                BlockCell.bottomRight);
        return Block(s, 0, 0, 0);
    }
}
