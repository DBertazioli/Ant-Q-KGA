#!/usr/bin/python3
# -*- coding: utf-8 -*-

import math
import pprint
import re

from SharedMatrices import PheroMatrix
from AntColonySystem import Ant

#a nice introduction to MPI shared-memory env: https://princetonuniversity.github.io/PUbootcamp/sessions/parallel-programming/Intro_PP_bootcamp_2018.pdf
from mpi4py import MPI 

class Graph:
    
    #constructor
    def __init__(self, num_ants, generations, alpha, beta, rho):
        
        # Initialize a MPI environment and rank method for child/parent processes
        self.common_world = MPI.COMM_WORLD
        self.rank = self.common_world.Get_rank()

        #print("hello")
        self.alpha = alpha      # pheromon weight
        self.beta = beta        # euclid_dist weight
        self.rho = rho          # evaporation coeff
        self.dist_matrix = []    # support matrix
        self.num_ants = num_ants
        self.generations = generations

    #read data creating the pheromone matrix
    def load_city_list(self, file_path, int_data=False):
    
        #int data are easier to parse and manage like int numb, a bit better memory access/perf
        self.dist_matrix = []
        vertex_list = []
        coord_list = []
        with open(file_path) as f:
            for line in f.readlines():
                #line=line.replace("  "," ")
                #line=line.replace("   "," ")
                #line=re.sub(' +', ' ', line) #depending on the tsp format might be useful
                vertex = line.split(' ')
                #vertex_list.append(dict(index=int(vertex[0]), x=int(float(vertex[1])), y=int(float(vertex[2])))) 
                vertex_list.append(dict(index=int(vertex[0]), x=float(vertex[1]), y=float(vertex[2])))
                #vertex_list.append(dict(index=int(vertex[0]), x=int(vertex[1]), y=int(vertex[2]))) #int data
                #coord_list.append((int(float(vertex[1])), int(float(vertex[2]))))
                coord_list.append((float(vertex[1]), float(vertex[2])))
                #coord_list.append((int(vertex[1]), int(vertex[2])))
       
        #if self.rank==0:        
        #    pprint.pprint(vertex_list)
       
        n_vertex = len(vertex_list)
        self.n_vertex = len(vertex_list)
        self.phero_matrix = PheroMatrix(self.n_vertex, self.rho)
       
        for i in range(n_vertex):
            row = []
            for j in range(n_vertex):
                if(i != j):
                    row.append((1, self.euclid_dist(vertex_list[i], vertex_list[j])))
                else:
                    row.append((0, 0))
            self.dist_matrix.append(row)
        #print("#################################")
        #print("#################################")
        #print(self.dist_matrix)
        return coord_list

       
    # return a matrix element
    def get_matrix_element(self, v1, v2):
        return self.dist_matrix[v1][v2]
        
    # get the lenght of the closed curr_path
    def compute_path_len(self, path):
        total = 0
        for i in range(len(path) - 1):
            total += self.get_matrix_element(path[i], path[i+1])[1]
        return total

    # calculate euclid_dist between vertex
    def euclid_dist(self, vertex_1: dict, vertex_2: dict):
    #def euclid_dist(self, vertex_1, vertex_2):
        return math.sqrt((vertex_1['x'] - vertex_2['x']) ** 2 + (vertex_1['y'] - vertex_2['y']) ** 2)

    
    # solver, generate a solution
    def solve(self):
        
        best_dist = None
        best_path = []

        # the parallelism is obtained through generations
        # for each generation, a "mean" pheromon matrix is obtained 
        for generation in range(self.generations):
            ant_colony = [Ant(self) for i in range(self.num_ants)]
            for one_ant in ant_colony:
                curr_path = one_ant.make_path()
                curr_dist = self.compute_path_len(curr_path)
		
		#update curr_dist and best sol                
                if(best_dist == None):
                    best_dist = curr_dist
                    best_path = curr_path
                elif(best_dist > curr_dist):
                    best_dist = curr_dist
                    best_path = curr_path
            
	    # for each process, the mean pheromon matrix is updated (into the in-shared-memory general matrix) 
            self.phero_matrix_upd(ant_colony)
            if generation % 5 == 0:
                self.upd_all()
            # print('Rank: {:1d} - end of generation {:3d}'.format(self.rank, generation))

        # return better curr_dist and sol
        return (best_dist, best_path)
                
    #Updates the pheromone matrix taking into account the number of ants that passed through 
    #and also the evaporation of the pheromone
    def phero_matrix_upd(self, ant_colony):
        self.phero_matrix.phero_evap()
        for one_ant in ant_colony:
            for k in range(1, len(one_ant.curr_path)):
                i = one_ant.curr_path[k - 1]
                j = one_ant.curr_path[k]
                self.phero_matrix.produce_phero(i, j, 1)
    
    # Gathering the values ​​to the parent  (master, rank 0) process
    def upd_all(self):
        # print('Rank {} before the bcast: {}'.format(self.rank, self.phero_matrix.matrix[0]))

        # Parent process takes all values ​​from other processes
        pm2 = self.common_world.gather(self.phero_matrix.matrix, root=0)
        
        # calculating a "mean" matrix for the pheromon update
        if(self.rank == 0):
            # print('upd_all')
            for m in pm2[1:]:
                for i in range(self.n_vertex):
                    for j in range(self.n_vertex):
                        self.phero_matrix.matrix[i][j] += m[i][j]
        
            for i in range(self.n_vertex):
                    for j in range(self.n_vertex):
                        self.phero_matrix.matrix[i][j] /= self.common_world.Get_size()

        # sends the data to all other processes in the MPI env
        self.phero_matrix.matrix = self.common_world.bcast(self.phero_matrix.matrix, root=0)
        # print('Rank {} end of bcast: {}'.format(self.rank, self.phero_matrix.matrix[0]))

    
    
    #return vertex list (not containing the current vertex) for a fully connected graph
    def all_neighb(self, vertex_id):
        n = list(range(len(self.dist_matrix)))
        n.remove(vertex_id)
        #print(" all vertex_id: ", vertex_id, "len n: ", len(n), "\n",n, "\n ##############\n")
        return n
    #"""
        
        
    """ ##FOR NOT FULLY CONNECTED GRAPHS##
    # Output wires for directed graph
    def outbound_neighb(self, vertex_id):
        n = []
        for j in range(self.n_vertex):
            if self.dist_matrix[vertex_id][j][0] > 0:
                n.append(j)
        #print(" outbound vertex_id: ", vertex_id, "len n: ", len(n), "\n",n, "\n ##############\n")
        return n

    # Input neighbors for directed graph
    def inbound_neighb(self, vertex_id):
        n = []
        for i in range(self.n_vertex):
            if self.dist_matrix[i][vertex_id][0] > 0:
                n.append(i)
        #print(" inbound vertex_id: ", vertex_id, "len n: ", len(n), "\n",n, "\n ##############\n")
        return n

    # list the neighbors of a selected vertex_id (possible choices)
    def all_neighb(self, vertex_id):
        n = self.inbound_neighb(vertex_id) + self.outbound_neighb(vertex_id)
        #print(" all vertex_id: ", vertex_id, "len n: ", len(list(set(n))), "\n",list(set(n)), "\n ##############\n")
        return list(set(n)) 
    """

