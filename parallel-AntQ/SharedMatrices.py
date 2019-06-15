#!/usr/bin/python3.6
# -*- coding: utf-8 -*-

#Pheromone Matrix, in a separated module since it will be called by each child process and update in parallel

class PheroMatrix:

    def __init__(self, dim, rho, AQ0):
        self.rho = rho      # Pheromon evaporation coefficient
        self.gamma = 1
        self.alpha = 0.5
        self.matrix = []    # n_vertex x n_vertex Pheromon Weigths matrix 
        self.AQ0 = AQ0
        
	# construct the matrix with initial const value 1
        for i in range(dim):
            self.matrix.append([])
            for j in range(dim):
                self.matrix[i].append(self.AQ0)
        	
    # return the matrix element
    def get_phero_matrix_elem(self, i, j):
        return self.matrix[i][j]
        
    # pheromon produce_phero
    def produce_phero(self, i, j, phero_increment):
        self.matrix[i][j] =(1-self.alpha)*self.matrix[i][j]+ self.alpha*self.gamma*phero_increment
        
    def delay_rew_phero(self, i, j, phero_increment):
        self.matrix[i][j] += self.alpha*phero_increment
    
    """ #integrated into "produce_phero"
    # pheromon evaporation
    def phero_evap(self):
        for i in range(len(self.matrix)):
            for j in range(len(self.matrix[0])):
                #self.matrix[int(i)][int(j)] *= self.rho
                self.matrix[int(i)][int(j)] *= (1-self.alpha)
    """    

