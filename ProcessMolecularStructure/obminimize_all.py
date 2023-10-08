import os
import sys
import argparse

parser = argparse.ArgumentParser(description='Some versions of obabel (with --minimize) or obminimize show weird behaviour when working with multiple XYZs collected in a single file. Sometimes the output format is pdb with fewer significant figures. This python code offers a solution. It takes as input an XYZ file containing atomic coordinates of multiple molecules and optimizes each tightly using obabel. The default options are set as \'--ff UFF --sd --c 1e-6 --n 10000\'. Feel free to experiment.')

parser.add_argument('Nmol', type=int, help='Number of molecules')
parser.add_argument('XYZinit', type=str, help='Name of the XYZ file with initial coordinates')
parser.add_argument('XYZfina', type=str, help='Name of the XYZ file with final coordinates')

args = parser.parse_args()

Nmol=args.Nmol
XYZinit=args.XYZinit
XYZfina=args.XYZfina

filedir = os.getcwd()

os.system(f'rm {XYZfina}')

geom_file = open(XYZinit, 'r')

for imol in range(Nmol):

    line = geom_file.readline().strip()

    if line:

        Nat = int(line)
        title = geom_file.readline().strip()
        print(Nat, title)

        inputfile= open('geom.xyz', 'w')

        inputfile.write(f'{Nat}\n')
        inputfile.write(f'{title}\n')

        for iat in range(1, Nat + 1):
            line = geom_file.readline().split()
            sym=line[0]
            R=[float(line[1]), float(line[2]), float(line[3])]
            inputfile.write(f'{sym}   {R[0]:15.8f}   {R[1]:15.8f}   {R[2]:15.8f}\n')

        inputfile.close()

        os.system(f'obabel geom.xyz -oxyz -O geom_tmp.xyz --minimize --ff UFF --sd --c 1e-6 --n 10000')

        os.system(f'cat geom_tmp.xyz >> {XYZfina}')
        os.system(f'rm geom.xyz geom_tmp.xyz')

geom_file.close()
