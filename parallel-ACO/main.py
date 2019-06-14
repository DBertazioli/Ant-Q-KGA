#!/usr/bin/python3
# -*- coding: utf-8 -*-

from StructuredGraph import Graph
from SharedMatrices import PheroMatrix
from AntColonySystem import Ant
from PlotHelper import plot, plot2
from pprint import pprint

import sys

#a nice introduction to MPI shared-memory env: https://princetonuniversity.github.io/PUbootcamp/sessions/parallel-programming/Intro_PP_bootcamp_2018.pdf
from mpi4py import MPI

if __name__ == "__main__":
	if len(sys.argv) < 7:
		print('Correct syntax: {} <test> <n_ant> <n_generations> <alpha> <beta> <rho>'.format(sys.argv[0]))
		sys.exit(1)

	#init a common environment for enabling parallelism through generations
	common_world = MPI.COMM_WORLD
	
	n_cores = common_world.Get_size() 	#basically n_cores available, specified in the mpirun exec options (-n <n_cores>) 
								#or in the hostfile file options(--hostfile <myhostfile>) in case of multiple nodes and multiple cores
								
	rank = common_world.Get_rank() 		#rank of the current process (rank == 0 --> master, rank >0 child)
    #print(sys.argv[2], n_cores)

	ant_number_per_core = int(int(sys.argv[2]) / n_cores) #ant_number_per_core for each core (here's the parallelism in action)
	n_generations = int(sys.argv[3])
	alpha = float(sys.argv[4])
	beta = float(sys.argv[5])
	rho = float(sys.argv[6])

	myGraph = Graph (ant_number_per_core, n_generations, alpha, beta, rho)

	vertex_positions = myGraph.load_city_list(sys.argv[1], int_data=False)
	print('Process Rank: {}'.format(rank))
	my_sol = myGraph.solve()
	myGraph.upd_all()
	main_sol = common_world.gather(my_sol, root=0)
	if rank == 0:
		main_sol.sort()
		print("best distance found =", main_sol[0][0])
		print("best path found =", main_sol[0][1])
		plot(vertex_positions, main_sol[0][1], int(sys.argv[7]))
		plot2(vertex_positions, myGraph.phero_matrix.matrix, int(sys.argv[7]))

