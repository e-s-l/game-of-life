# gol-tkinter.py
# game of life
# with tkinter 'gui'

import tkinter as tk
import time
import numpy as np


class GameOfLife():

    ##################
    #constructor:
    ##################
    def __init__(self, master):
        self.master = master
        ###board stuff:
        self.CELL_SIZE = 6
        self.BOARD_WIDTH=600    
        self.BOARD_HEIGHT=600
        self.ALIVE_COLOR = '#00FF00'
        self.DEAD_COLOR = '#000000'

        #get first state:
        self.generation=0
        self.population=self.setUp()
        ####

        self.master.title("Conway's Game of Life")
        self.master.configure(background="#000000")
        self.score_label = tk.Label(self.master, text="GENERATION: {}".format(self.generation), bg="#000000", fg="#00FF00",pady=8,padx=2, font=('consolas', 18))
        self.score_label.pack()
        #
        self.canvas = tk.Canvas(self.master, bg=self.DEAD_COLOR, height=self.BOARD_HEIGHT, width=self.BOARD_WIDTH, highlightbackground="black")
        self.canvas.pack(expand=True)
        
        self.updateBoard()
        #start cranking:
        self.master.after(0, self.go)

        #increment generation
    #   generation+=1

    #############################
    #methods:
    #############################
    def setUp(self):
        #initialise a randomly seeded grid.
        
        cols = self.BOARD_WIDTH // self.CELL_SIZE
        rows  = self.BOARD_HEIGHT // self.CELL_SIZE

        return np.random.randint(2,size=(rows, cols))


    def updateBoard(self):
        #present the grid/population as a board using tkinter canvas

        self.canvas.delete('cells')
        for i in range(len(self.population)):
            for j in range(len(self.population[0])):
                if self.population[i][j] == 1:
                    x0 = j * self.CELL_SIZE
                    y0 = i * self.CELL_SIZE
                    x1 = x0 + self.CELL_SIZE
                    y1 = y0 + self.CELL_SIZE
                    self.canvas.create_rectangle(x0, y0, x1, y1, fill=self.ALIVE_COLOR, tags='cells')
                #  self.master.title("Generation: {}".format(generation))
                self.score_label.config(text="GENERATION: {}".format(self.generation))

    ### 
    def go(self):
        #the main runner

        self.updateBoard()
        self.population = self.newGeneration(self.population)
        self.generation += 1
        self.master.after(10, self.go)

   
    ####
    def newGeneration(self, population):
        #get the new population based off the old following the class conway rule

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

               # for x in range(max(0, i - 1), min(rows, i + 2)):
               #     for y in range(max(0, j - 1), min(cols, j + 2)):
               #         if (x, y) != (i, j) and population[x,y] == 1:
               #             noln += 1

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


if __name__ == "__main__":
    root = tk.Tk()
    #create game object:
    game = GameOfLife(root)
    #start tkinter mainloop:
    root.mainloop()
