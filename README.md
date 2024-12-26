# Design specification

Move the elevator either up or down to reach the requested floor. Once at the requested floor, open the door for at least 2 seconds. Ensure the door is never open while moving. 
Don’t change directions unless there are no higher requests when moving up or no lower requests when moving down. Assume that the elevator moves from one floor to another in 2 seconds. 
The controller should use the 50 MHz clock on DE0-CV board. Use a 1 sec clock enable to the timer for the elevator movement and the opening of the door. 
The inputs and outputs of the controller are shown in the figure below. Also, the controller can be broken into a Request Resolver that resolves various floor requests into single requested floor 
and a Unit Control that moves elevator to this requested floor. Design the controller to serve up to 10 floors (0 is the ground floor and 9 is the highest floor). Use SystemVerilog Parameters 
for the number of floors. The floor output should be connected to a seven segment display through a binary to SSD converter.

# Elevator controller block diagram and interface ports


