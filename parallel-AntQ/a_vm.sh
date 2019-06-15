#!/bin/bash
# just a sh helper script, for subsequential multiple runs
#echo "Bash version ${BASH_VERSION}..."
#Correct syntax: {} <test> <n_city> <n_generations> <alpha> <beta> <rho>'.

for i in {0..9} #set n_repeat here
  do 
     #time mpirun --hostfile hostfile -n 2 python3 main.py test/pr76 76 30 1 3 0.5 $i
     ##time mpirun -n 2 python3 main.py test/a280 100 30 1 3 0.5 $i #bad smth
     #time mpirun -n 2 python3 main.py test/ch130 130 30 1 3 0.5 $i
     time mpirun -n 4 python3 main.py test/berlin52 52 1000 1 3 0.5 $i
     echo "time mpirun -n 4 python3 main.py test/berlin52 52 500 1 3 0.5 $i"
     #time mpirun -n 2 python3 main.py test/d198 198 30 1 3 0.5 $i
  
  
  #echo "\n\n****pr76****\n\n"
  #echo "\n\n****ch130****\n\n"
  echo "\n\n****berlin52****\n\n"
  #echo "\n\n****d198****\n\n"
 done
 
 
 #best distance found = 7576.249348880802
 #best path found = [18, 44, 31, 48, 0, 21, 30, 17, 2, 16, 20, 1, 6, 41, 29, 22, 19, 49, 28, 15, 45, 43, 33, 34, 35, 38, 39, 37, 36, 47, 23, 4, 14, 5, 3, 24, 11, 27, 26, 25, 46, 12, 13, 51, 10, 50, 32, 42, 9, 8, 7, 40, 18]

#real	0m10,381s
#user	0m19,858s
#sys	0m0,988s
#\n\n****berlin52 52 ants 100 it****\n\n

