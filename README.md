# findmax-mpi

This is a parallel program using MPI to find the max of set of
numbers. This was just an academic exercise; MPI already has a
function to do this called MPI_Reduce.


The program findmax-mpi takes in a number of processors *p* and an
input size *n*, and

* each processor generates *p/n* random numbers

* each processor finds the maximum among these

* the processors communicate to find the maximum among all processors


The processors communicate in stages, or "levels". At level 0, each
processor has found its local maximum. Each processor is assigned a
number from 0 to *p-1*, called the rank, denoted *r*. A processor of
rank *r* that is in an even-numbered position on the current level *l*
expects to receive the local maximum of processor with rank *r + 2^l*
(conversely, a processor of rank *r* that is in an odd-numbered
position on the current level *l* expects to send its local maximum to
the processor with rank *r - 2^l*).

The processor in the even-numbered position with rank *r* now has its
own local maximum (say *MAX1*) as well as the local maximum of
processor with rank *r + 2^l* (say *MAX2*).  This same processor,
which is on level *l*, will then become a parent on level *l+1* and
will update its maximum to be the maximum of *MAX1* and *MAX2*.  This
goes for all processors on even-numbered positions on level *l*.  The
processors in the odd-numbered positions will become idle from then on
(starting at level *l+1*).  See the image below for an illustration of
this idea with *p = 16*.

Note that for the even- and odd-numbered positions, the positions
start at 0 and are distinct from the rank. For example, on level 1,
the node with rank 0 is in an even-numbered position (0), while the
node with rank 2 is in an odd-numbered position (1).



![alt text](https://github.com/mgabilo/findmax-mpi/blob/master/tree.png "findmax-mpi execution for 16 processors")

There are *O(log p)* levels since the above forms a complete binary
tree. Each level takes place in parallel, but the processors must
synchronize at each level.

## Algorithm walk-through

In the image above, the program begins at level 0 with 16 parallel
processors, labeled rank 0 through rank 15. Each processor has
generated its local maximum, e.g., the maximum of rank (processor) 2
is 232.

In level 0, each processor in an even-numbered position receives the
local maximum of the processor directly to its right (rank *r + 2^l*
where *r* is the rank of the processor in the even-numbered position).
For example, the even-numbered position processor with rank 0 (with
local maximum 32) receives the local maximum of processor with rank 1
(43), which lies directly to its right on that level.  The processor
with rank 1 will become idle. This same even-numbered position
processor (rank 0) then becomes a parent at level 1 and updates its
maximum to be 43 (max of 32 and 43).  The same process happens in
parallel between ranks 2 and 3; ranks 3 and 4; and so on.

Once all of the pairs in level 0 are finished communicating, the above
process begins again at level 1.  For example, in level 1, the
processor with rank 4 is in an even-numbered position (position 2,
since positions start from 0) -- local maximum 2.  That means it will
receive the local maximum of the odd-numbered position processor
directly to its right, processor with rank 6 -- local maximum 91.  The
even-numbered position processor with rank 4 will store the new
maximum the two local maximums in the level 2 (91).  Processor with
rank 6 will become idle.

This process continues until the global maximum is propagated upwards
to level 4 (232).

## Running the program

Install an MPI implementation; for example on Ubuntu 16.04 you can run
the following.

```
sudo apt-get install mpich libmpich-dev
```

To compile the program type "make" which compiles the program with
"mpicxx".

To run the program use "mpirun". For example, the following commands
runs the program with 8 processors.

```
mpirun -np 8 ./findmax
```


## Evaluation

I tested the program on this quad-core processor: Intel(R) Core(TM) i5-3470 CPU @ 3.20GHz

The execution time in seconds, speedup and efficiency for 1, 2, 4, 8,
and 16 processors is show below. The execution times were averaged over 100 runs.


| Processors                | 2       |  4      |  8       | 16      |  1       |
| ------------------------- | ------- | ------- | -------- | ------- | -------- |
| Time (seconds)            | 0.12772 | 0.12674	| 0.20825  | 0.41154 | 0.23520  |
| Speedup                   | 1.84    | 1.86    | 1.13     | 0.57    | 1        |
| Efficiency                | 92.08%  | 46.39%  | 14.12%   | 3.57%   | 100%     |

The speedup is calculated as ( (execution time for sequential program)
/ (execution time for parallel program) ). For example the speedup for
4 processors is calculated as 0.23520 / 0.12674.

The maximum speedup was achieved for 4 processors as expected.  The
upper-level for speedup should be 2.0 for 2 processors, 4.0 for 4
processors, etc., but this doesn't happen because of parts of the
program that cannot be parallelized and communication overhead.  While
the speedup for 2 processors is nearly 2 (at 1.84), the speedup for 4
processors is not close to 4 (only 1.86).  This idea is called
efficiency and is calculated as the following percentage:
((*speedup(p)* / *p*) * 100), where *p* is the number of processors
and *speedup(p)* is the speedup for *p* processors.  For example, the
efficiency for 2 processors was 1.84 / 2 * 100 or 92.08%.  The highest
efficiency for a parallel program was achieved by 2 processors.


## License

This project is licensed under the MIT License (see the [LICENSE](LICENSE) file for details).

## Authors

* **Michael Gabilondo** - [mgabilo](https://github.com/mgabilo)
