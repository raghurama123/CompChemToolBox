import pandas as pd
import numpy as np

def boltzmann_average(E, unit, prop, T):
  
    # https://en.wikipedia.org/wiki/Boltzmann_constant 
    if ( unit == 'eV' ):
        kB=8.617333262*10**-5 # eV/K
    elif ( unit == 'kcm' ):
        kB=1.987204259*10**-3 # kcal/mol/K
    elif ( unit == 'kjm' ):
        kB=3.166811563*10**-6 # hartree/K
    elif ( unit == 'hartree' ):
        kB=8.314462618*10**-3 # kJ/mol/K
    elif ( unit == 'cmi' ):
        kB=0.695034800        # cmi/K

    # Convert energy to Boltzmann factor
    boltzmann_factors = np.exp(-E / (kB * T))

    # Calculate weighted average of property
    ave_prop = np.sum(prop * boltzmann_factors) / np.sum(boltzmann_factors)

    return ave_prop

# Read CSV file
df = pd.read_csv('prop.csv')

# Extract energy and property 
E = df['Energy']
prop = df['Property']

# Define the unit of energies
unit='cmi'

# Define temperature values for averaging
Ts = [28, 77, 100, 300, 400, 500, 1000, 2000, 3000]  # Add more temperatures as needed

# Perform Boltzmann averaging for each temperature
for T in Ts:
    ave_prop = boltzmann_average(E, unit,prop, T)
    print(f'Temperature: {T} K, Boltzmann-Averaged Property: {ave_prop:.4f}')
print(f'Fast thermalization average is:                  {np.mean(prop):.4f}')

