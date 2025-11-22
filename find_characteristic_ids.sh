#!/bin/bash

################################################################################
# Census Characteristic ID Finder
# Helper script to search for characteristic names and their IDs
################################################################################

CENSUS_DIR="/Users/rhoge/Documents/QGIS/Mobility/data/census"
INPUT_2021="$CENSUS_DIR/2021/98-401-X2021006_English_CSV_data_Quebec.csv"
INPUT_2016="$CENSUS_DIR/2016/98-401-X2016044_Quebec_eng_CSV.csv"

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

################################################################################
# Search 2021 census
################################################################################
search_2021() {
    local search_term="$1"
    
    echo -e "${BLUE}=== Searching 2021 Census for: '$search_term' ===${NC}"
    echo ""
    
    # Search in CHARACTERISTIC_NAME column (column 3)
    # Show CHARACTERISTIC_ID (column 2) and CHARACTERISTIC_NAME (column 3)
    
    awk -F',' -v search="$search_term" 'BEGIN{IGNORECASE=1} 
        NR==1 {next}  # Skip header
        $3 ~ search {
            # Extract CHARACTERISTIC_ID (column 2) and CHARACTERISTIC_NAME (column 3)
            gsub(/"/, "", $2)  # Remove quotes
            gsub(/"/, "", $3)
            printf "ID: %s\n  → %s\n\n", $2, $3
        }' "$INPUT_2021" | head -20
    
    echo ""
}

################################################################################
# Search 2016 census
################################################################################
search_2016() {
    local search_term="$1"
    
    echo -e "${YELLOW}=== Searching 2016 Census for: '$search_term' ===${NC}"
    echo ""
    
    # Search in DIM column (column 9)
    # Show Member ID (column 10) and description (column 9)
    
    awk -F',' -v search="$search_term" 'BEGIN{IGNORECASE=1} 
        NR==1 {next}  # Skip header
        $9 ~ search {
            # Extract Member ID (column 10) and description (column 9)
            gsub(/"/, "", $10)  # Remove quotes
            gsub(/"/, "", $9)
            printf "Member ID: %s\n  → %s\n\n", $10, $9
        }' "$INPUT_2016" | head -20
    
    echo ""
}

################################################################################
# Main
################################################################################

if [ $# -eq 0 ]; then
    echo "Usage: $0 <search term>"
    echo ""
    echo "Examples:"
    echo "  $0 'car.*driver'        # Find car as driver"
    echo "  $0 'public transit'     # Find public transit"
    echo "  $0 'bicycle'            # Find cycling"
    echo "  $0 'walked'             # Find walking"
    echo "  $0 'work.*home'         # Find work from home"
    echo "  $0 '15 to 19'           # Find age group"
    echo "  $0 'mode of commuting'  # Find all commuting modes"
    echo ""
    exit 1
fi

search_term="$1"

# Check if files exist
if [ ! -f "$INPUT_2021" ]; then
    echo "Error: 2021 census file not found: $INPUT_2021"
    exit 1
fi

if [ ! -f "$INPUT_2016" ]; then
    echo "Error: 2016 census file not found: $INPUT_2016"
    exit 1
fi

# Perform searches
search_2021 "$search_term"
search_2016 "$search_term"

echo -e "${GREEN}=== Search Complete ===${NC}"
echo ""
echo "To extract a characteristic, copy its ID and add to extract_census_data.sh"
echo "Example:"
echo "  extract_2021 \"1234\" \"commuters_driving\""
echo "  extract_2016 \"5678\" \"commuters_driving\""
