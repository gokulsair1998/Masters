////Hardware implementation on Local Machine////

-install Dev C++ or any platform which supports c program compilation
-place the algorithm between gettimeofday(&start, NULL); and gettimeofday(&stop, NULL);
 to calculate the time elapsed to execute the algorithm (refer amdryzen5_compiler.c)
-the code in this project is run on AMD Ryzen-5 an internal clock of 3Ghz, 
 8 GB DDR4 RAM, and the Dev C++ software was installed to an SSD (does not make huge difference 
 if a HDD is used)
-code 'amdryzen5_compiler.c' is run and the time taken is recorded and tabulated 
 for comparison with On-Chip ARM and FPGA.