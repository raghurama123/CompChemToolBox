# CompChemToolBox
The repository collects shortcodes for various miscellaneous #compchem tasks. Some details for each code are as follows.

## Boltzmann Average
If you have a CSV file with two columns (1. Energies in some unit, 2. Some property), then the example code in the folder [BoltzmannAveraging](https://github.com/raghurama123/CompChemToolBox/tree/main/BoltzmannAveraging) can help you find a Boltzmann average. You can select the energy unit and temperatures by editing the following lines
        
```
unit='cmi'  # 'eV', 'kcm' (for kcal/mol), 'kjm' (kJ/mol), 'hartree', 'cmi' (for cm^-1)

Ts = [28, 77, 100, 300, 400, 500, 1000, 2000, 3000]  
```

## OBMINIMIZE
Some versions of `obminimize` cannot handle multiple XYZs in a file, resulting in unwanted effects. Please take a look at the following thread for some discussions on these. 
https://www.mail-archive.com/search?l=openbabel-discuss@lists.sourceforge.net&q=subject:%22%5C%5BOpen+Babel%5C%5D+obminimize%22&o=newest&f=1

The code [Fix4Obminimize/obminimize_all.py](https://github.com/raghurama123/CompChemToolBox/tree/main/Fix4Obminimize) gives a remedy. More details are collected in the [README file](https://github.com/raghurama123/CompChemToolBox/blob/main/Fix4Obminimize/example)

## CHECKCONNGO

The program [CheckConnGO.f90](https://github.com/raghurama123/CompChemToolBox/tree/main/CheckConnGO) compares file-1 (SDF file, presumably generated from SMILES using obabel) and file-2 (XYZ generated using DFT optimization) and does statistics about preservation of bond connectivities during geometry optimization. 


We applied such diagnostics to identify QM9 molecules that have underdone re-arrangement during geometry optimization for our paper: 

```
  Troubleshooting Unstable Molecules in Chemical Space 
  Salini Senthil, Sabyasachi Chakraborty, Raghunathan Ramakrishnan
  Chemical Science, 2021
  https://pubs.rsc.org/en/content/articlelanding/2021/SC/D0SC05591C
```

See the [README file](https://github.com/raghurama123/CompChemToolBox/blob/main/CheckConnGO/example) for more details.


