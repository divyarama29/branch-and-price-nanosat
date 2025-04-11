Cubesat Scheduling Project

Author: Divya Ramachandran
Contact: dramach6@asu.edu

The code has been developed in Python Jupyter notebook using VS Studio Code editor.
Jupyter Notebook - 'Project Part 2_1230317116.ipynb'

1. Installations :
Python: https://www.python.org/downloads/
VS Code: https://code.visualstudio.com/
Jupyter Notebook: https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter

2. Adding Environment Variable(if required)
Add the path to the 'python.exe' on your system to the system environment variables on your computer

Note: You can also open the Jupyter notebook on Google Colab: https://colab.research.google.com/

3. Installing dependencies
The following python packages are required for running the code:
-skyfield
-pulp 
-matplotlib 
-pandas 
-numpy

Install the python dependencies using: !pip install skyfield pulp matplotlib pandas numpy
or just run the first code block in the jupyter notebook

*********************************************************************************************************************************************

4.Running the Code(important)
TLE Data: The code assumes that TLE data for satellites is stored in a file named TLE.txt in the same folder as the jupyter notebook.
The TLE file should contain the data in below format:

1U
1 44885U 19093G   25071.89662337  .00013778  00000-0  12071-2 0  9999
2 44885  97.8175 159.4112 0011643 142.4687 217.7349 14.96742709283474

**********************************************************************************************************************************************
5. Running the Code:
After completing all the requirements till step 4, *Run all the code blocks in the Jupyter Notebook sequentially*.

6.Results
The program will output the following:

-Optimization Status: Whether the optimization was successful or not.
-Objective Value: The total priority sum for scheduled tasks.
-Computation Time: The time it took to solve the optimization problem.
-Scheduled Tasks: A table showing the task IDs and the time slots in which they are scheduled.
-Task Scheduling Plot: A graph of task execution over time

**********************************************************************************************************************************************

7. Additional Details:
Optimization:
The Satellite_optimization() function is the core of the scheduling process. It solves the optimization problem using PuLP.

Example usage for calling the function and plotting the results:
Instance 1 - 1U CubeSat:

start_time = datetime(2025, 1, 1, 0, 0, 0)
Satellite_optimization(satellite_data_1U, satellites[0], start_time)

-satellite_data_1U - Defined as a dictionary in the code
-satellites[0] - read from the TLE.txt file and is stored in satellites(List)

**********************************************************************************************************************************************
8. If using mac, install all the dependencies required for installing skyfield and PuLP libraries
PuLP module may give errors when trying to use the default optimizer. The Optimizer name may be required to be specified explicitly.
1.

from pulp import PULP_CBC_CMD

model.solve(PULP_CBC_CMD(path="/opt/homebrew/bin/cbc"))

2. 

from pulp import PULP_CBC_CMD

model.solve(PULP_CBC_CMD())














