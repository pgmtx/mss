module mss.core.component.processing_unit;

import mss.core.matrix.block;
import mss.core.matrix.block_cell;

interface ProcessingUnit
{
    Block add(Block a, Block b);
    Block substract(Block a, Block b);
    Block multiply(Block a, Block b);
    Block swap(Block block, BlockCell cell1, BlockCell cell2);
    Block swap(Block block1, BlockCell cell1, Block block2, BlockCell cell2);
    Block sum(Block block);
}
