#!/usr/bin/python3.6
# -*- coding: utf-8 -*-

#Pheromone Matrix, in a separated module since it will be called by each child process and update in parallel

class PheroMatrix:

    def __init__(self, dim, rho):
        self.rho = rho      # Pheromon evaporation coefficient 
        self.matrix = []    # n_vertex x n_vertex Pheromon Weigths matrix 
        
	# construct the matrix with initial const value 1
        for i in range(dim):
            self.matrix.append([])
            for j in range(dim):
                self.matrix[i].append(1)
        #print(len(self.matrix),len(self.matrix[1]),len(self.matrix[2])  ) #n_vertex x n_vertex
        	
    # return the matrix element
    def get_phero_matrix_elem(self, i, j):
        return self.matrix[i][j]

    # pheromon evaporation
    def phero_evap(self):
        for i in range(len(self.matrix)):
            for j in range(len(self.matrix[0])):
                self.matrix[int(i)][int(j)] *= self.rho
    
    # pheromon produce_phero
    def produce_phero(self, i, j, phero_increment):
        self.matrix[i][j] += phero_increment
    
