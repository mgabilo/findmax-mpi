# findmax-mpi

The program findmax-mpi takes in a number of processors *p* and an
input size *n*, and

* each processor generates *p/n* random numbers

* each processor finds the maximum among these

* the processors communicate to find the maximum among all processors


The processors communicate in stages, or "levels". At level 0, each
processor has found its local maximum. Each processor is assigned a
number from 0 to *p-1*, called the rank, denoted *r*. A processor of
rank *r* that is in an even-numbered position on the current level *l*
expects to receive the maximum from processor with rank *r + 2^l*. A
processor of rank *r* that is in an odd-numbered position on the
current level *l* expects to send its maximum to the processor with
rank *r - 2^l*. Processors in even-numbered positions on that level
become parents on the next level. Processors in odd-numbered positions
on that level send their local maximum to their parent and become idle
after that. See the image below for an illustration of this idea with
*p = 16*.

![alt text](https://github.com/mgabilo/findmax-mpi/blob/master/tree.png "findmax-mpi execution for 16 processors")

There are *O(log p)* levels since the above forms a complete binary
tree. Each level takes place in parallel, but the processors must
synchronize at each level.

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
