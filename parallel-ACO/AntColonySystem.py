#!/usr/bin/python3
# -*- coding: utf-8 -*-

from SharedMatrices import PheroMatrix
from numpy.random import choice

class Ant:
    
    # Ant constructor
    def __init__(self, graph):
        self.graph = graph
        self.already_visited = []
        self.curr_path = []
        for i in range(graph.n_vertex):
            self.already_visited.append(False)

    # Create a closed curr_path
    def make_path(self, start=0):
        c = [start]
        self.already_visited[start] = True
        for i in range(self.graph.n_vertex - 1):
            c.append(self.find_next(c[-1]))
        c.append(start)
        self.curr_path = c
        return c

    # Choose next vertex
    def find_next(self, vertex):
        neighbors = self.graph.all_neighb(vertex)
        possibles = self.remove_already_visited(neighbors)
        next_step_probabilities = self.next_step_probabilities(vertex, possibles)
        chosen_vertex = choice(possibles, 1, p=next_step_probabilities)[0]

        self.already_visited[chosen_vertex] = True
        return chosen_vertex
    
    # Remove already visited locations
    def remove_already_visited(self, neighbors):
        return [x for x in neighbors if not self.already_visited[x]]

    # Calculate probability for a neighbors
    def next_step_probabilities(self, vertex, neighb_vertices):
        phero_dict = {}
        phero_sum = 0
        for n_vertex in neighb_vertices:
            phero_quantity = self.compute_phero_intensity(vertex, n_vertex)
            phero_dict[n_vertex] = phero_quantity
            phero_sum += phero_quantity

        next_step_probs = []
        for n_vertex in neighb_vertices:
            next_step_probs.append(phero_dict[n_vertex] / phero_sum)

        return next_step_probs

    # Calculate the pheromone weight in the probability construction
    def compute_phero_intensity(self, v1, v2):
        phero_quantity = self.graph.phero_matrix.get_phero_matrix_elem(v1, v2)
        (_, one_step_dist) = self.graph.get_matrix_element(v1, v2)
        #if self.graph.rank==0:
        #    print(one_step_dist)
        return ((phero_quantity**self.graph.alpha) * (1/one_step_dist ** self.graph.beta))
