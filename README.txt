This is the readme for the models associated with the paper:

Smith P, Arias R, Sonti S, Odgerel Z, Santa-Maria I, McCabe BD, Tsaneva-Atanasova K, 
Louis ED, Hodge JJL, Clark LN (2018) A Drosophila Model of Essential Tremor. Sci Rep


LNVmodel models the activity of a Drosophila LNV neuron
Necessary files: LNVmodel	(main code)
		 MODEL.mat	(model parameters)

		 

To run the code on Matlab:

Call the function:
LNVmodel(ZT, kv2choice);

where ZT is the time of day  i.e. ZT0 is lights-on, ZT12 is lights-off 
(in a 12hr light/12hr dark cycle), ZT6 is mid-day etc.

where kv2choice is the choice of kv2 models: 
	1 is native kv2
	2 is native kv2 with human wild-type kv9 also expressed
	3 is native kv2 with human mutant kv9 (c379E) also expressed



To return outputs use:
[vrec, I1, I2, I3, I4] = LNVmodel(ZT, kv2choice);

Where vrec is the membrane voltage of the modelled neuron
      I1 is the modelled current of the Shaker (Kv1) channel
      I2 is the modelled current of the Shab (Kv2) channel
      I1 is the modelled current of the Shaw (Kv3) channel
      I1 is the modelled current of the Shal (Kv4) channel



To create different figures:

The default output is a graph of the membrane voltage of the 
modelled neuron (vrec) along with a graph of the currents of each of the 
four channels Shaker (I1), Shab (I2), Shaw (I3), and Shal (I4). 

To reproduce figure 6 of the paper run the model with ZT=0 (morning) 
and kv2choice=1 =2 or =3 for the different genotypes, changing subplots and x-axis 
as required. Here plot(t,vrec,'k') plots the membrane voltage as seen in figure 6.

To change figures go to the 'Creating figures' subsection towards the end 
of the script (Line 223).





To reproduce figure 5:

CostFun1 compares the model parameters with electrophyiological data.
Necessary files: CostFun1			(main code)
		 MODEL.mat			(model parameters)
		 KV2.mat			(Kv2 data)
		 KCNS2 WT.mat			(Wild-type Kv9 data)
		 KCNS2 c379E.mat		(Mutant Kv9 data)

To run the code on Matlab:

Open MODEL.mat

Call the function:
CostFun1(Pars) 

Where Pars is the channel being modelled. (KV2, KV9W, or KV9M)
	For KV2 use load 'KV2.mat' (line 9)
	For KV9W use load 'KCNS2 WT.mat' (line 10)
	For KV9M use load 'KCNS2 MU.mat' (line 11)
	Use % to inactivate the other two of these three lines
		
The CostFun1 code can show how any parameters fit to electrophysiological data.
Simply alter the parameters given in (Pars) to simulate channel activity.





To fit electrophysiological data to Hodgkin-Huxley equations by the
optimised algorithm:

Necessary files: particleswarm.m		(main code)
		 mockna.mat			(dummy sodium channel data)
						(replace with your data)

To run the code on Matlab:

Call the function:
particleswarm(parts)

Where parts is the number of particles being simulated (1000 was used in the paper).

This code loads the data set with load('mockna.mat'); (line 16).
The data set uses T as the time course (in ms), IK as the current, and V as 
the voltage before (-133mV) and during the voltage pulse.

The number of particles is specified when calling the function.
The number of iterations is specified by iters (line 21) (between 30 and 50 
were used in the paper).

The code generates a number of particles within the upper (line 9) and lower
(line 10) bounds specified. Each particle has 13 parameters used in the 
Hodgkin-Huxley equations. Each particle is evaluated to determine how closely
it matches the physiological data given (lines 46-63). The best solution is
determined (lines 65-71). All other particles are moved towards the best
particle and re-evaluated for the fit (lines 75-124). This cycle repeats
over the number of iterations (line 21).

To return outputs use:
[finalsolns, globals, solns1, solns2, solns3, solns4, solns5] = particleswarm(parts)

Where 	finalsolns is the final generation of particles after the last iteration
	globals is the fit of each final particle
	solns1 is the first generation of particles
	solns2 is the second generation of particles
	solns3 is the third generation of particles
	solns4 is the fourth generation of particles
	solns5 is the fifth generation of particles

As the code runs the iteration number is displayed.
At the end of the run the best solution is displayed as well as a plot of
the fit of the best particle in each iteration (lines 156-159). 
Elapsed time given by tic (line 3) and toc (line 161).