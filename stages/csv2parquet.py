import pandas as pd
import sys
import os

InFileName = sys.argv[1]
OutFileName = sys.argv[2]

print(f"csv2parquet: Converting file {InFileName}")
file_size = os.path.getsize(InFileName)

if file_size >= 1_000_000_000:
    print(f"csv2parquet: File size is {file_size} bytes and should be read in chunks")
    os.makedirs(OutFileName, exist_ok=True)
    chunk_size = 10_000_000
    try:
        with pd.read_csv(InFileName, dtype='str', sep='\t', chunksize=chunk_size) as reader:
            for i, chunk in enumerate(reader):
                filename = os.path.join(OutFileName, f"{i}.parquet")
                print(f"csv2parquet: Writing chunk {i} to {filename}")
                chunk.to_parquet(filename)
    except Exception as e:
        print(f"Error processing file: {e}")
else:
    print(f"csv2parquet: File size is {file_size} bytes and can be read in one go")
    try:
        df = pd.read_csv(InFileName, dtype='str', sep='\t')
        df.to_parquet(OutFileName)
    except Exception as e:
        print(f"Error processing file: {e}")
