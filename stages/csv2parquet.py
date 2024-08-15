import pandas as pd
import sys
import pyarrow as pyarrow
import fastparquet as fastparquet

InFileName = sys.argv[1]
OutFileName = sys.argv[2]

print(f"csv2parquet: Converting file {InFileName}")
df = pd.read_csv(InFileName, sep='\t')
df.to_parquet(OutFileName)
