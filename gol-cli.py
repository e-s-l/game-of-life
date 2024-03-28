# gol-clir.py
# game of life
# in command line interface

import random
import sys
import os
import time

   ###board stuff:
#
ALIVE = '+'
DEAD = '-'


class GameOfLife():

    #constructor:
  #  def __init__(self):
   #     super().__init__()
        #

    ###
    def setUp(self):

        size = os.get_terminal_size()
        number_cols = (int)(size.columns)-1
        number_rows  = (int)(size.lines)-2

        #list comprehension
        population = [[random.randint(0, 1) for i in range(number_cols)] for j in range(number_rows)]

        return population

    ###
    def printBoard(self,population,generation):

        headerInfo = "Generation: {}".format(generation)
        print(headerInfo)

        output = ""
        for i in range(len(population)):
            for j in range(len(population[0])):
                if (population[i][j] == 1):
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
                time.sleep(1)
            ###
        except KeyboardInterrupt:
            print("\n:)\n")

    ###
    def newGeneration(self,population):

        #for living cells:
        #count number of living neighbours (noln)
        #if noln < 2 then die
        #if noln > 3 then die
        #if dead, if noln = 3 then revive.
        

        new_population = population
        
        return new_population


    ###
###


###

if __name__ == "__main__":

    #create game object:
    game = GameOfLife()
    #get first state:
    generation=0
    population=game.setUp()
    #start cranking:
    game.go(population, generation)