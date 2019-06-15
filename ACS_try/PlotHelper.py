#!/usr/bin/python3
# -*- coding: utf-8 -*-

import math
import operator
import matplotlib.pyplot as plt
import numpy as np


def plot(points, path: list, num):
    x = []
    y = []
    for point in points:
        x.append(point[0])
        y.append(point[1])
    
    y = list(map(operator.sub, [max(y) for i in range(len(points))], y))
    plt.plot(x, y, 'co')

    for _ in range(1, len(path)):
        i = path[_ - 1]
        j = path[_]

        plt.arrow(x[i], y[i], x[j] - x[i], y[j] - y[i], color='r', length_includes_head=True)

    plt.xlim(0, max(x) * 1.1)

    plt.ylim(0, max(y) * 1.1) 
    plt.savefig('figs/best_{}.png'.format(num))

def plot2(points, matrix, num):
    colors = np.divide(matrix, np.amax(matrix))
    x = []
    y = []
    for point in points:
        x.append(point[0])
        y.append(point[1])

    y = list(map(operator.sub, [max(y) for i in range(len(points))], y))
    plt.plot(x, y, 'co')

    for i in range(len(points)):
        for j in range(i, len(points)):
            if i != j:
                a = (1 - colors[i][j])
                if a < 0.8:
                    f = int(a * 0xff)
                    c = '#ff{f:02x}{f:02x}'.format(f=f)

                    plt.arrow(x[i], y[i], x[j] - x[i], y[j] - y[i], color=c, length_includes_head=True)

    plt.xlim(0, max(x) * 1.1)
    plt.ylim(0, max(y) * 1.1)
    plt.savefig('figs/popular_{}.png'.format(num))
