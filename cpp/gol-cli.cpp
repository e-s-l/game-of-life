/*
ANOTHER SILLY LITTLE GOL ON THE CLI
But we are getting better i think.
Here we have optional rulesets.
Next try & use ncurses for the display.
AND then look into using FFt and convolution maths...
*/


// for the wait functionality
#include <chrono>
#include <thread>
// for return statuses
#include <stdlib.h>
// for endlines (new line + flush)
#include <iostream>
#include <vector>
// for the find function
#include <algorithm>

class GameOfLife {

public:

	// a struct to define the ruleset (passed to the constructor)
	struct Ruleset {
		std::vector<int> survival;
		std::vector<int> birth;
	};

	// constructor
	GameOfLife(int end_gen, Ruleset rules = conway()) : generation(0), end(end_gen), k(0), rows(21), cols(80), ruleset(rules) {
        set_up();
	}

	// methods, public
	void run() {
		/* run the game */

		while (generation < end) {
			display();
			generate();
			std::this_thread::sleep_for(std::chrono::milliseconds(200));
		}
	}

	// static
	static Ruleset conway() {
		return Ruleset {{2,3}, {3}};
	}

private:

	// variables, private
	int generation, end, k, rows, cols;
	std::vector<std::vector<int>> population, next_gen;
	Ruleset ruleset;

	// methods, private
	void set_up() {
		/* set-up the population and initialise variables*/

		// initialise
		// random seed
		srand(time(nullptr));
		// counters
		generation = 0;
		k = 0;
		// arrays
		population.resize(rows, std::vector<int>(cols));
		next_gen.resize(rows, std::vector<int>(cols));

		// fill in the first population, randomly
		for (int i = 0; i < rows; ++i) {
			for (int j = 0; j < cols; ++j) {
				population[i][j] = rand() % 2;
			}
		}
	}

	void display() const {
		/* display the board */

		// status line
		std::cout << "generation: " << generation << std::endl;
		// print the population
		for (int i = 0; i < rows; ++i) {
			for (int j = 0; j < cols; ++j) {
				std::cout << (population[i][j] == 0 ? " " : "+");
			}
			std::cout << std::endl;
		}
	}

	void generate() {
		/* get the next generation given the population & a rule*/

		// resize & reinitialise (to 0s) the array
		next_gen.assign(rows, std::vector<int>(cols, 0));
		//
		for (int i = 0; i < rows; ++i) {
			for (int j = 0; j < cols; ++j) {
				int cmin = std::max(j - 1, 0);
				int cmax = std::min(cols - 1, j + 1);
				int rmin = std::max(i - 1, 0);
				int rmax = std::min(rows - 1, i + 1);

				int noln = 0;
				for (int r = rmin; r <= rmax; ++r) {
					for (int c = cmin; c <= cmax; ++c) {
						noln += population[r][c];
					}
				}
				noln -= population[i][j];
				if (!ruleset.survival.empty() && !ruleset.birth.empty()) {
					if (population[i][j] == 1) {
						if (std::find(ruleset.survival.begin(), ruleset.survival.end(), noln) == ruleset.survival.end()) {
							next_gen[i][j] = 0;
						} else {
							next_gen[i][j] = 1;
						}
					} else {
						if (std::find(ruleset.birth.begin(), ruleset.birth.end(), noln) != ruleset.birth.end()) {
							next_gen[i][j] = 1;
						}
					}
				}
			}
		}

		// check if static
		if (next_gen == population) {
			k++;
			if (k > 5) {
				std::cout << "Restarting..." << std::endl;
				set_up();
				generate();
			}
		}
		
		// re-load the new population
		population = next_gen;
		generation++;
	}
};

std::string to_lower(const std::string& s) {
	std::string lower_s = s;
	std::transform(lower_s.begin(), lower_s.end(), lower_s.begin(), [](unsigned char c) { return std::tolower(c); });
	return lower_s;
	}

bool is_number(const std::string& s) {
	return !s.empty() && std::all_of(s.begin(), s.end(), ::isdigit);
}

int main(int argc, char* argv[]) {

	// get optional end_gen input
	int end_gen = 1000;
	GameOfLife::Ruleset ruleset = GameOfLife::conway();

	for (int i = 1; i < argc; ++i) {
		std::string arg = argv[i];

		if (is_number(arg)) {
			end_gen = std::stoi(arg);
		} else {
			arg = to_lower(arg);
			if (arg == "highlife") {
				ruleset = GameOfLife::Ruleset{{2, 3}, {3, 6}};
			} else if (arg == "daynight") {
				ruleset = GameOfLife::Ruleset{{3, 4, 6}, {3, 4, 6}};
			} else if (arg == "replicator") {
				ruleset = GameOfLife::Ruleset{{2, 3}, {3}};
			} else if (arg == "walledcity") {
				ruleset = GameOfLife::Ruleset{{1, 2, 3}, {1}};
			} else if (arg == "coral") {
				ruleset = GameOfLife::Ruleset{{2, 3}, {1, 2}};
			} else {
				std::cout << "Dunno that one... " << arg << std::endl;
			}
		}
	}

	GameOfLife game(end_gen, ruleset);
	game.run();
	return EXIT_SUCCESS;
}


/*TODO
- when do ncurses version, add click to flip function
*/
