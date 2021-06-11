INFORMATION REGARDING THE CUSTOM COMPUTER CODE (MATHEMATICAL ALGORITHMS) USED IN UBEDA ET AL.


 1. System Requirements
************************

Mathematical algorithms require core Matlab, version R2019a or higher. No special-purpose toolboxes are required. System requirements are described in detail by the manufacturer at https://www.mathworks.com/support/requirements/matlab-system-requirements.html which includes information for Windows, Mac, and Linux users, respectively.

Algorithms were tested on Matlab, version R2019a. All hardware used was typical to a standard desktop or laptop computer.


 2. Installation Guide
***********************

A Matlab license can be purchased from the manufacturer at https://www.mathworks.com/store/ but academic institutions often have site licenses available to faculty and students free of charge.  

Core Matlab can be installed following manufacturer's instructions at https://www.mathworks.com/help/install/index.html. Installation time will vary depending on hardware used and operating system.

For algorithms used by Ubeda et al., the user should download the following files and save them to their working directory:

(i) 	TwohostOnepopODE.m 

	This function returns the right-hand side of one-population version of the dynamic model described in Section S.1 of the Supplement (see page 5, lines 51-52 of the Supplement for an explanation of the one-population model). The output of the function is passed to Matlab's built-in differential-equations solver, "ode45." The function allows one to ultimately identify the equilibrium around which the invasion analysis in Section S.2 of the Supplement is based.

	All input required is captured by comments in the script itself.

(ii) 	event_function1pop.m

	This function is called by Matlab's built-in differential-equations solver, "ode45." The call is made in the course of solving the one-population version of the dynamic model described in Section S.1 of the Supplement (see page 5, lines 51-52 of the Supplement for an explanation of the one-population model). Specifically, the event function is used by ode45 to determine when the numerical solution to the one-population version of equations S.1 has become sufficiently close to equilibrium levels.

	All input required is captured by comments in the script itself.

(iii) 	TwohostOnepopESS.m

	This function carries out the evolutionary analysis described in Section S.2 of the Supplement. It returns the predicted endpoint of the evolutionary trajectory of the disease-induced mortality rate(s) alpha, subject to constraints on plasticity (or lack thereof, depending on the scenario of interest). The alpha values returned are called, "ES virulence" for short.

	All input required is captured by comments in the script itself.

(iv) 	TwohostTwopopODE.m

	The counterpart to (i) for the general case of two subpopulations described in equation S.1 of the Supplement. 	All input required is captured by comments in the script itself.

(v)	event_function2pop.m

 	The counterpart to (i) for the general case of two subpopulations described in equation S.1 of the Supplement. 	All input required is captured by comments in the script itself.

(vi)	TwohostTwopopESS.m

	The counterpart to (i) for the general case of two subpopulations described in equation S.1 of the Supplement. 	All input required is captured by comments in the script itself.


 3. Demo
*********

The file supmaterialplots.m is demo that creates figures found in the Supplement. Make sure supmaterialplots.m is saved to the same directory in which you find the six files described in previous section. To run the demo open the supmaterialsplots.m file and click the green "Run" arrow found in the top menu bar of the Editor window. Alternatively, navigate to the working directory type "supmaterialplots" at the Matlab prompt that appears in the Command Window. Note that you may be prompted by Matlab to add your working directory to its search path; if this happens, choose the "Add to path" option.

The Demo takes 470.5 sec (about 8 min) to run on a laptop equipped with an Intel Core i7-7600U CPU and 16GB RAM.


 4. Instructions for Use
*************************

Figures in the main text containing numerical results can be reproduced using the data supplied along with the Python scripts provided. The Python scripts rely on the numpy, matplotlib, pandas libraries. These libraries come, by default, when one downloads and installs the Python 3.x version of the Anaconda data science toolkit (available for free at anaconda.org). In order to produce figures, the Python script and corresponding data file must be found in the same working directory.

The data used in **FIGURE 4** can be found in Fig_4_Sept_13_2019.csv. The file header contains information about model settings used. Column headings make reference to the full constrained model ("FC" prefix) and the origin-specific model ("HO" prefix). In the former case, pathogens are constrained to use a single alpha strategy regardless of host encountered (the "benchmark" referred to in the main text). In the latter case, pathogens can condition alpha on the sex of the host from which their current infection orginated. Column headings with the "aij" suffix refer to alpha_ij where i,j = 1,2 (1=female and 2=male). Column headings with the "bijk" suffix refer to beta_ijk where i,j,k = 1,2. The relevant Python script is Fig_4_Sept_13_2019.py and it can be run by opening the file in an IDE (e.g. the Spyder IDE that comes with Anaconda) and pressing the green triangle button on the menu bar (alternatively, press Function Key 5).

The data used in **FIGURE 5** can be found in Fig_5_Sept_17a_2019.csv and Fig_5_Sept_21a_2019.csv. The file headers contain information about model settings used. Column headings make reference to the full constrained model ("FC" prefix) and the origin-specific model ("HO" prefix). In the former case, pathogens are constrained to use a single alpha strategy regardless of host encountered (the "benchmark" referred to in the main text). In the latter case, pathogens can condition alpha on the sex of the host from which their current infection orginated. Column headings with the "aij" suffix refer to alpha_ij where i,j = 1,2 (1=female and 2=male). Column headings with the "bijk" suffix refer to beta_ijk where i,j,k = 1,2. The relevant Python script is Fig_5_Sept_17a_21a_2019.py and it can be run by opening the file in an IDE (e.g. the Spyder IDE that comes with Anaconda) and pressing the green triangle button on the menu bar (alternatively, press Function Key 5).

The data used in **FIGURE 6** can be found in Fig_6_Nov_14_2019.csv and Fig_6_Nov_15_2019.csv. The file headers contain information about model settings used. Column headings make reference to the full constrained model ("FC" prefix) and the origin-specific model ("FP" prefix). In the former case, pathogens are constrained to use a single alpha strategy regardless of host encountered (the "benchmark" referred to in the main text). In the latter case, pathogens can condition alpha on both the sex of the host from which their current infection orginated and the sex of their current host---in that sense, pathogens are "fully plastic." Column headings with the "aij" suffix refer to alpha_ij where i,j = 1,2 (1=female and 2=male). Column headings with the "bijk" suffix refer to beta_ijk where i,j,k = 1,2. The relevant Python script is Fig_6_Nov_14_2019.py and it can be run by opening the file in an IDE (e.g. the Spyder IDE that comes with Anaconda) and pressing the green triangle button on the menu bar (alternatively, press Function Key 5).

The data used in **FIGURE 7** can be found in Fig_7_Nov_28a_2019.csv and Fig_7_Nov_28b_2019.csv. The file headers contain information about model settings used. Column headings make reference to the full constrained model ("FC" prefix) and the origin-specific model ("FP" prefix). In the former case, pathogens are constrained to use a single alpha strategy regardless of host encountered (the "benchmark" referred to in the main text). In the latter case, pathogens can condition alpha on both the sex of the host from which their current infection orginated and the sex of their current host---in that sense, pathogens are "fully plastic." Column headings with the "aij" suffix refer to alpha_ij where i,j = 1,2 (1=female and 2=male). Column headings with the "bijk" suffix refer to beta_ijk where i,j,k = 1,2. The relevant Python script is Fig_7_Nov_28_2019.py and it can be run by opening the file in an IDE (e.g. the Spyder IDE that comes with Anaconda) and pressing the green triangle button on the menu bar (alternatively, press Function Key 5).


