all: findmax

findmax: findmax.cpp
	mpicxx -O3 findmax.cpp -o findmax

clean:
	rm -f findmax
