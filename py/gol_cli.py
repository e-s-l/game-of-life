#!/usr/bin/env python3

# gol-cli.py
# game of life
# in command line interface

import random
import sys
import os
import time
import numpy as np

###board stuff:
ALIVE = '+'
DEAD = '.'


class GameOfLife():

    ##################
    #constructor:
    ##################
    def __init__(self):

        #pass #for the moment, later initialise board game here
        #get first state:
        generation=0
        population=self.setUp()
        #start cranking:
        self.go(population, generation)

    #############################3
    #methods:
    ##############################
    def setUp(self):
        ##
        size = os.get_terminal_size()
        cols = (int)(size.columns)
        rows  = (int)(size.lines-4)

        #return population as np array
        return np.random.randint(2,size=(rows, cols))


    ###
    # Print the game board
    def printBoard(self,population,generation):

        ##
        headerInfo = "\n Generation: {} \n".format(generation)
        print(headerInfo)
        #
        output = ""
        for i in range(len(population)):
            for j in range(len(population[0])):
                if (population[i,j] == 1):
                     output += ALIVE 
                else: 
                    output += DEAD 
            output += "\n"
        print(output[:-1])

    ### 
    def go(self,population,generation):
        
        try:
            while(True):
                #print game:
                self.printBoard(population,generation)
                #calculate new game state:
                population = self.newGeneration(population)
                #increment counter:
                generation += 1
                # wait a (tenth of a) sec
                time.sleep(0.2)
            ###
        except KeyboardInterrupt:
            print("\n:)\n")

   
    ####
    def newGeneration(self, population):

        ###################################
        # ORIGINAL RULES
        #for living cells:
        #count number of living neighbours (noln)
        #if noln < 2 then die
        #if noln > 3 then die
        #if dead, if noln = 3 then revive.
        ##################################


        rows = len(population)
        cols = len(population[0])

        new_population = np.zeros((rows, cols), dtype=int)

        for i in range(rows):
            for j in range(cols):
                noln = 0 # number of living neighbors

                noln = np.sum(population[max(0, i - 1): min(rows, i + 2), max(0, j - 1): min(cols, j + 2)]) - population[i, j]

                if population[i,j] == 1:
                    if noln < 2 or noln > 3:
                        new_population[i,j] = 0
                    else:
                        new_population[i,j] = 1
                else:
                    if noln == 3:
                        new_population[i,j] = 1

        return new_population
###


###
if __name__ == "__main__":

    #create game object:
    game = GameOfLife()
   

#############################################
