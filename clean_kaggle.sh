#!/bin/bash

# -------------------------------
# clean_kaggle.sh
# Clean Kaggle .ipynb or .py files
# -------------------------------

if [ $# -lt 1 ]; then
    echo "Usage: $0 <file.ipynb | file.py>"
    exit 1
fi

INPUT_FILE="$1"
EXT="${INPUT_FILE##*.}"

# Handle .ipynb
if [ "$EXT" == "ipynb" ]; then
    # Get the directory part (e.g., Downloads)
    DIRNAME=$(dirname "$INPUT_FILE")
    
    # Get just the filename (e.g., scientific-image-forgery-detection-dinov2-2-2)
    FILENAME=$(basename "$INPUT_FILE" .ipynb)

    # OUTPUT_BASE ONLY contains the filename part, NO directory.
    OUTPUT_BASE="${FILENAME}_clean"
    
    # We rely on jupyter nbconvert to put the output file in DIRNAME/

    echo "[+] Converting notebook to Python..."
    # Crucially, we pass the FILENAME part (OUTPUT_BASE) to jupyter
    # The tool automatically puts it in the correct directory (Downloads/)
    jupyter nbconvert --to script "$INPUT_FILE" --output "$OUTPUT_BASE"

    # FILE_TO_CLEAN must be the full path for the sed commands
    FILE_TO_CLEAN="${DIRNAME}/${OUTPUT_BASE}.py"

# ... rest of the script ...

# Handle .py
elif [ "$EXT" == "py" ]; then
    BASENAME=$(basename "$INPUT_FILE" .py)
    OUTPUT_FILE="${BASENAME}_clean"

    echo "[+] Copying Python file..."
    cp "$INPUT_FILE" "$OUTPUT_FILE"
    FILE_TO_CLEAN="$OUTPUT_FILE".py

else
    echo "Error: Only .ipynb or .py files supported."
    exit 1
fi

echo "[+] Cleaning Kaggle-specific code..."

# Remove Kaggle and notebook-specific artifacts
sed -i '
/^# In\[/ d;                  # Jupyter cell markers
/^get_ipython/ d;            # Jupyter magic calls
/^!/ d;                      # Shell commands like !pip install
/^%%/ d;                     # Magic commands
/kaggle\/input/ d;           # Kaggle dataset paths
/\%matplotlib/ d;            # magic plotting
' "$FILE_TO_CLEAN"

# Remove trailing whitespace
sed -i 's/[ \t]*$//' "$FILE_TO_CLEAN"

# Remove excessive blank lines
sed -i '/^$/N;/^\n$/D' "$FILE_TO_CLEAN"

echo "[+] Clean file generated: $FILE_TO_CLEAN"