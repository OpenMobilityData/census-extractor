#!/bin/bash

################################################################################
# Census Data Extraction Script
# Extracts specific characteristics from Statistics Canada census CSVs
# Creates small, focused CSV files for efficient QGIS loading
################################################################################

set -e  # Exit on error

# Configuration
CENSUS_DIR="/Users/rhoge/Documents/QGIS/Mobility/data/census"
INPUT_2016="$CENSUS_DIR/2016/98-401-X2016044_Quebec_eng_CSV.csv"
INPUT_2021="$CENSUS_DIR/2021/98-401-X2021006_English_CSV_data_Quebec.csv"
OUTPUT_2016="$CENSUS_DIR/2016/extracted"
OUTPUT_2021="$CENSUS_DIR/2021/extracted"

# Create output directories
mkdir -p "$OUTPUT_2016"
mkdir -p "$OUTPUT_2021"

################################################################################
# Helper function to extract from 2021 census (uses CHARACTERISTIC_ID)
################################################################################
extract_2021() {
    local char_id="$1"
    local output_name="$2"
    local output_file="$OUTPUT_2021/${output_name}.csv"
    
    echo "Extracting 2021: $output_name (CHARACTERISTIC_ID=$char_id)..."
    
    # Write header
    head -1 "$INPUT_2021" > "$output_file"
    
    # Extract matching rows
    # Use awk for precise column matching (CHARACTERISTIC_ID is column 2)
    awk -F',' -v id="$char_id" '$2 == id' "$INPUT_2021" >> "$output_file"
    
    local count=$(wc -l < "$output_file")
    echo "  → Created $output_file ($((count-1)) data rows)"
}

################################################################################
# Helper function to extract from 2016 census (uses Member ID)
################################################################################
extract_2016() {
    local member_id="$1"
    local output_name="$2"
    local output_file="$OUTPUT_2016/${output_name}.csv"
    
    echo "Extracting 2016: $output_name (Member ID=$member_id)..."
    
    # Write header
    head -1 "$INPUT_2016" > "$output_file"
    
    # Extract matching rows
    # Member ID is column 10 in 2016 census
    awk -F',' -v id="$member_id" '$10 == id' "$INPUT_2016" >> "$output_file"
    
    local count=$(wc -l < "$output_file")
    echo "  → Created $output_file ($((count-1)) data rows)"
}

################################################################################
# CORE DEMOGRAPHIC DATA
################################################################################

echo "=== Extracting Core Demographics ==="

# Population
extract_2021 "1" "population"
extract_2016 "1" "population"

# Total private households
extract_2021 "1414" "households"
extract_2016 "1617" "households"

################################################################################
# COMMUTING DATA - MAIN MODE
################################################################################

echo ""
echo "=== Extracting Commuting Data ==="

# Total commuters (all modes)
extract_2021 "2603" "commuters_total"
extract_2016 "1930" "commuters_total"

# Car, truck, van as driver
# 2021: Need to find the exact CHARACTERISTIC_ID
# Look in the census for: "Car, truck, van - as a driver"
# extract_2021 "XXXX" "commuters_driving"
# extract_2016 "XXXX" "commuters_driving"

# Car, truck, van as passenger
# extract_2021 "XXXX" "commuters_passenger"
# extract_2016 "XXXX" "commuters_passenger"

# Public transit
# extract_2021 "XXXX" "commuters_transit"
# extract_2016 "XXXX" "commuters_transit"

# Walked
# extract_2021 "XXXX" "commuters_walking"
# extract_2016 "XXXX" "commuters_walking"

# Bicycle
# extract_2021 "XXXX" "commuters_cycling"
# extract_2016 "XXXX" "commuters_cycling"

# Other method
# extract_2021 "XXXX" "commuters_other"
# extract_2016 "XXXX" "commuters_other"

################################################################################
# WORK LOCATION DATA
################################################################################

echo ""
echo "=== Extracting Work Location Data ==="

# Worked at home
# 2021: Need to find CHARACTERISTIC_ID for "Worked at home"
# This is part of "Place of work status" variable
# extract_2021 "XXXX" "workers_at_home"
# extract_2016 "XXXX" "workers_at_home"

# No fixed workplace address
# extract_2021 "XXXX" "workers_no_fixed_workplace"
# extract_2016 "XXXX" "workers_no_fixed_workplace"

# Usual place of work
# extract_2021 "XXXX" "workers_usual_place"
# extract_2016 "XXXX" "workers_usual_place"

################################################################################
# AGE GROUPS
################################################################################

echo ""
echo "=== Extracting Age Group Data ==="

# Total population 15 years and over
# extract_2021 "XXXX" "population_15plus"
# extract_2016 "XXXX" "population_15plus"

# 15 to 19 years
# extract_2021 "XXXX" "population_15to19"
# extract_2016 "XXXX" "population_15to19"

# 20 to 24 years
# extract_2021 "XXXX" "population_20to24"
# extract_2016 "XXXX" "population_20to24"

# 60 to 64 years
# extract_2021 "XXXX" "population_60to64"
# extract_2016 "XXXX" "population_60to64"

# 65 years and over
# extract_2021 "XXXX" "population_65plus"
# extract_2016 "XXXX" "population_65plus"

################################################################################
# SUMMARY
################################################################################

echo ""
echo "=== Extraction Complete ==="
echo ""
echo "2021 extracted files in: $OUTPUT_2021"
ls -lh "$OUTPUT_2021"/*.csv 2>/dev/null || echo "  (no files yet)"
echo ""
echo "2016 extracted files in: $OUTPUT_2016"
ls -lh "$OUTPUT_2016"/*.csv 2>/dev/null || echo "  (no files yet)"
echo ""
echo "Total extracted files: $(find "$OUTPUT_2016" "$OUTPUT_2021" -name "*.csv" 2>/dev/null | wc -l)"
echo ""
echo "Next steps:"
echo "1. Find CHARACTERISTIC_IDs for additional metrics (see FINDING_IDS.md)"
echo "2. Uncomment and update the relevant extraction lines above"
echo "3. Re-run this script"
echo "4. Load the extracted CSVs in QGIS (no filtering needed!)"
