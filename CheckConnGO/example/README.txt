The proram CheckConnGO.f90 compares file-1 (SDF file, presumably generated from SMILES using obabel) and file-2 (XYZ generated using DFT optimization) and does statistics about preservation of bond connectvities during geometry optimization. 


We applied this code for our paper 

Troubleshooting Unstable Molecules in Chemical Space 
Salini Senthil, Sabyasachi Chakraborty, Raghunathan Ramakrishnan
Chemical Science, 2021
https://pubs.rsc.org/en/content/articlelanding/2021/SC/D0SC05591C

SAMPLE RUN:
-----------
(base) Raghunathans-MacBook-Pro:example raghurama$ ../CheckConnGO.x geom_UFF.sdf geom_DFT_S0.xyz geom_DFT_S0.sdf | tee summary.txt

GENERATES THE FOLLOWING OUTPUT: 
-------------------------------
We see that the covalent bond lengths are similar in file-1 and file-2, implying that no re-arrangement has happened during DFT geometry relaxation. The last line states 'ConnGO PASS [MPAD < 5, MaxAD < 0.2 Angstrom]' summarizing that the covalent bonds encoded in the SDF file (file-1) are preserved in file-2 (only the connectivities, the DFT level bond lengths may slightly differ than in file-1). If file-2 has a rearranged structure (many examples are given in our Chemical Science paper referred above), then the code will print 'ConnGO FAIL ...'. ConnGO is an acronym for connectivity preserving geometry optimization. A new SDF file with connectivities from file-1 and coordinates from file-2 will be created with the name file-3 (in this example, geom_DFT_S0.sdf)

The output is piped to summary.txt using '| tee summary.txt'


== connectivities
                     File-1                  File-2                Deviation
  1  3  1  C - C     1.4680                  1.4806                 -0.0126
  2  1  2  O = C     1.2210                  1.2042                  0.0168
  3  4  2  C = C     1.3357                  1.3301                  0.0056
  4  5  1  C - C     1.4945                  1.5040                 -0.0095
  4  8  1  C - H     1.0832                  1.0839                 -0.0007
  5 10  1  C - H     1.0949                  1.0930                  0.0020
  6  1  1  C - C     1.5006                  1.5265                 -0.0260
  6  5  1  C - C     1.5248                  1.5314                 -0.0066
  6 12  1  C - H     1.0925                  1.0904                  0.0021
  7  3  1  H - C     1.0760                  1.0809                 -0.0049
  9  5  1  H - C     1.0946                  1.0929                  0.0016
 11  6  1  H - C     1.0940                  1.0907                  0.0033

== bond lengths in file-1 in descending order, # ultralong bonds =    0
    1.5248    1.5006    1.4945    1.4680    1.3357    1.2210    1.0949    1.0946    1.0940    1.0925    1.0832    1.0760

== bond lengths in file-2 in descending order, # ultralong bonds =    0
    1.5314    1.5265    1.5040    1.4806    1.3301    1.2042    1.0930    1.0929    1.0907    1.0904    1.0839    1.0809

** Geometries in file-1 and file-2 seem alright, no broken structures detected **

== Mean square deviation of bond lengths from file-1 and file-2
 MSD  =     0.0105 Ang

== Maximum absolute deviation in bond lengths from file-1 and file-2
 MaxAD=     0.0260 Ang

== Mean percentage absolute deviation in bond lengths from file-1 and file-2
 MPAD =     0.5674

== Outcome of the Connectivity preserving Geometry Optimization
** ConnGO PASS [MPAD < 5, MaxAD < 0.2 Angstrom] **
