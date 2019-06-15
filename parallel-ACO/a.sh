#!/bin/bash
# just a sh helper script, for subsequential multiple runs
#echo "Bash version ${BASH_VERSION}..."

for i in {0..0} #set n_repeat here
  do 
     #time mpirun --hostfile hostfile -n 2 python3 main.py test/pr76 100 30 1 3 0.5 $i
     ##time mpirun -n 2 python3 main.py test/a280 100 30 1 3 0.5 $i #bad smth
     #time mpirun -n 2 python3 main.py test/ch130 100 30 1 3 0.5 $i
     time mpirun -n 2 python3 main.py test/berlin52 100 30 1 3 0.5 $i
     #time mpirun -n 2 python3 main.py test/d198 10 30 1 3 0.5 $i
  
  
  #echo "\n\n****pr76****\n\n"
  #echo "\n\n****ch130****\n\n"
  echo "\n\n****berlin52****\n\n"
  #echo "\n\n****d198****\n\n"
 done
