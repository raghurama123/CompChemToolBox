Let us create XYZ coordinates of 5 molecules starting from SMILES.

CREATE THE SMILES FILE WITH THE CONTENT SHOWN AS BELOW
------------------------------------------------------
(base) Raghunathans-MacBook-Pro:example raghurama$ cat mols.smi 
C
N
O
F
CC

CONVERT SMILES TO XYZ USING OBABEL
----------------------------------
(base) Raghunathans-MacBook-Pro:example raghurama$ obabel -oxyz mols.smi > mols_obabel.xyz --gen3d
5 molecules converted

OPTIMIZE THE COORDINATES WITH TIGHT SETTINGS
--------------------------------------------
(base) Raghunathans-MacBook-Pro:example raghurama$ python3 ../obminimize_all.py 5 mols_obabel.xyz mols_UFF_tight.xyz

HELP
----
SOME DETAILS OF THE CODE 'obminimize_all.py' ARE DISPLAYED USING THE '--help' OPTION AS SHOWN BELOW. 

(base) Raghunathans-MacBook-Pro:example raghurama$ python3 ../obminimize_all.py --help
