module mss.core.matrix.block_pair;

import mss.core.matrix.block;
import std.typecons : Tuple;

alias BlockPair = Tuple!(Block, "first", Block, "second");
