module mss.core.component.processing_unit;

import mss.core.component.component;
import mss.core.matrix : Block, BlockCell, BlockPair;

interface ProcessingUnit : Component
{
    Block add(Block a, Block b) const;
    Block substract(Block a, Block b) const;
    Block multiply(Block a, Block b) const;
    Block swap(Block block, BlockCell cell1, BlockCell cell2) const;
    BlockPair swap(Block block1, BlockCell cell1, Block block2, BlockCell cell2) const;
    Block sum(Block block) const;
}
