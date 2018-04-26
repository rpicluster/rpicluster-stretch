CONWAY'S GAME OF LIFE
#================================================================#
BACKGROUND 
	Game of Life is a cellular automaton formulated by the British 
mathematician, John Orton Conway in 1970. This game does not 
require any players. The user just sets up the initial 
configuration and leaves the game to evolve on its own.
 	Life is one of the simplest examples of what is called 
"emergent complexity" or "self-organizing systems." This subject 
area has captured the attention of scientists and mathematicians 
in diverse fields. It is the study of how elaborate patterns and 
behaviors can emerge from very simple rules.
#================================================================#
EXAMPLE OF PATTERNS
	There are many patterns discovered over the years. Still 
Live are simple static patterns, such as blocks, beehives, loaves 
and boats. Oscillator is pattern is a superset of still lives. 
They cycle in between shapes and never die, such as blinkers, 
toads, beacons and pulsars. Other pattern type is the Spaceships. 
They are called that because these patterns translate themselves 
across the world (board), such as gliders and lightweight 
spaceships. There are many other pattern types. Some of them are 
Methuselahs, Guns, Puffers and Rakes. 

#================================================================#
RULES OF GAME OF LIFE
The game revolves around 4 simple rules:

1.	Any living cell with less than “LOWER_THRESH” 
(deafult: 2) live neighbors dies, as if it was caused 
by under-population.

2.	Any living cell with more than “UPPER_THRESH” 
(default: 3) live neighbors dies, as of it was caused by 
over-population (overcrowding).

3.	Any living cell with neighbors in between 
“LOWER_THRESH” and “UPPER_THRESH” lives on to 
the next generation.

4.	Any dead cell with “SPAW_THRESH” (default: 3) 
alive neighbors, will became alive too, as if 
it was by reproduction.

#================================================================#
COMMAND LINE OPTIONS
-h|--help             This help page.
-c|--columns number   Number of columns in grid. Default: 105
-r|--rows number     	 Number of rows in grid. Default: 105
-g|--gens number      	Number of generations to run. Default: 1000
-i|--input filename Input file. See README for format. Default: none.
-o|--output filename  Output file. Default: none.
-t[N]|--throttle[=N]  Throttle display to Ngenerations/second.Default:100
-x|--display          Use a graphical display.
--no-display          Do not use a graphical display. 

#================================================================#
OUTPUT
	When utilizing X11 the output should resemble the picture 
on the right. There are examples of patterns in the program's 
folder, such as the Oscillators, Gosper Glider Gun and etc. 
To visualize the examples use the "-i" option (input file). 
If the output file option is used, a file will be created with the 
X and Y coordinates of the cells that are alive at the last 
generation simulated.

#================================================================#
FILES
#===Defaults.h===#
This file contains the definition of all the variables, 
used in the program:

Important default variables are:
int DEFAULT_THROTTLE - Number of Generations that 
will be displayed per second.

int DEFAULT_SIZE - The size of rows and columns.

int DEFAULT_GENS - Number of Generations that will be simulated.

double INIT_PROB - Probability in which a cell will be 
initialized live or dead.

bool DEFAULT_DISP - If it is true X11 will be used to 
display the output.


Variables used to define the game's rules:

int UPPER_TRESH - If a cell has neighbors less than this 
variable's number then the cell dies, as of overpopulation.

int LOWER_TRESH - If a cell has neighbors more than this 
variable's number then the cell dies, as of isolation

int SPAWN_TRESH - If a dead cell has neighbors equals to this 
variable's number then the cell comes alive.
 
#===Life.h===#
int init(struct life_t * life, int * c, char *** v);
-	Initializes all the variables and if using X11 it 
creates the window.

void eval_rules (struct life_t * life);
-	Evaluates the rules of Game of Life for each cell; 
Counts neighbors and update current state accordingly.
  
void copy_bounds (struct life_t * life);
-	Copies neighbors of the current 
cell(sides, top bottom) 

void update_grid (struct life_t * life);
-	Updates cells with the new value gotten with eval_rules()    

void throttle (struct life_t * life);
-	Slows down the simulation to make is easier to 
watch the display.    

void allocate_grids (struct life_t * life);
-	Reserves (allocates) memory for a 2D array of integers

void init_grids (struct life_t * life);
-	Initialize cells based on input file, otherwise 
all cells are DEAD.   

void write_grid (struct life_t * life);
-	Dumps the current state of life.grid to life.out file. 
Only outputs the coordinates od cells that are NOT DEAD.    

void free_grids (struct life_t * life);
-	Used by cleanup() function - Frees all the memory 
that was reserved(allocated) by the allocate_grid() function.

double rand_double ();
-	Generates a double between 0 and 1.
   
void randomize_grid (struct life_t * life, double prob);
-	Used to initialize the grid with a probability 
that the cell will start dead or alive.

void cleanup (struct life_t * life);
-	Contains instructions to prepare process 
for a clean termination.

void parse_args (struct life_t * life, int argc, char ** argv);
-	Make command lines useful. For example, change 
size of the grid, or information (-h)

void usage ();
-	Contains the command line options text.

#===Life.c===#
	Initializes Life object which contains all the variables 
used in this program. This file also has a loop that runs through 
N-Generations. The loop contains all the instructions 
(function calls) to run one generation of the simulation.

#===Makefile===#
	Contain instructions to compile the Game of Life 
automatically, using all the necessary files, flag and etc.

#===XLife.h===#
	Contains all the necessary functions to create a X11 
window that display the right number of rows and columns 
based on the information that is set on the other Life files.

#===Input Files(*.in)===#
	This type of file contains X and Y coordinates 
for all the cells alive. The first two numbers of the file 
are the dimensions of the world in which the simulation will 
occur. They can be used as inputs for the Game of Life. 
