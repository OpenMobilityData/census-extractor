#!/bin/bash

################################################################################
# Census Extraction Summary
# Shows what's been extracted and basic statistics
################################################################################

CENSUS_DIR="/Users/rhoge/Documents/QGIS/Mobility/data/census"
OUTPUT_2016="$CENSUS_DIR/2016/extracted"
OUTPUT_2021="$CENSUS_DIR/2021/extracted"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Census Extraction Summary ===${NC}"
echo ""

################################################################################
# 2021 Extractions
################################################################################

echo -e "${GREEN}2021 Census Extractions:${NC}"
echo ""

if [ -d "$OUTPUT_2021" ] && [ "$(ls -A $OUTPUT_2021 2>/dev/null)" ]; then
    printf "%-30s %10s %15s\n" "File" "Rows" "Size"
    printf "%-30s %10s %15s\n" "----" "----" "----"
    
    for file in "$OUTPUT_2021"/*.csv; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            rows=$(($(wc -l < "$file") - 1))  # Subtract header
            size=$(ls -lh "$file" | awk '{print $5}')
            printf "%-30s %10s %15s\n" "$filename" "$rows" "$size"
        fi
    done
else
    echo "  No extracted files yet"
fi

echo ""

################################################################################
# 2016 Extractions
################################################################################

echo -e "${YELLOW}2016 Census Extractions:${NC}"
echo ""

if [ -d "$OUTPUT_2016" ] && [ "$(ls -A $OUTPUT_2016 2>/dev/null)" ]; then
    printf "%-30s %10s %15s\n" "File" "Rows" "Size"
    printf "%-30s %10s %15s\n" "----" "----" "----"
    
    for file in "$OUTPUT_2016"/*.csv; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            rows=$(($(wc -l < "$file") - 1))  # Subtract header
            size=$(ls -lh "$file" | awk '{print $5}')
            printf "%-30s %10s %15s\n" "$filename" "$rows" "$size"
        fi
    done
else
    echo "  No extracted files yet"
fi

echo ""

################################################################################
# Totals
################################################################################

total_2021=$(find "$OUTPUT_2021" -name "*.csv" 2>/dev/null | wc -l)
total_2016=$(find "$OUTPUT_2016" -name "*.csv" 2>/dev/null | wc -l)
total=$((total_2021 + total_2016))

echo -e "${BLUE}Total Extractions:${NC}"
echo "  2021: $total_2021 files"
echo "  2016: $total_2016 files"
echo "  Total: $total files"
echo ""

################################################################################
# Disk space
################################################################################

if [ $total -gt 0 ]; then
    total_size_2021=$(du -sh "$OUTPUT_2021" 2>/dev/null | cut -f1)
    total_size_2016=$(du -sh "$OUTPUT_2016" 2>/dev/null | cut -f1)
    
    echo -e "${BLUE}Disk Usage:${NC}"
    echo "  2021 extracted: $total_size_2021"
    echo "  2016 extracted: $total_size_2016"
    echo ""
fi

################################################################################
# Comparison with original files
################################################################################

if [ -f "$CENSUS_DIR/2021/98-401-X2021006_English_CSV_data_Quebec.csv" ]; then
    original_2021=$(ls -lh "$CENSUS_DIR/2021/98-401-X2021006_English_CSV_data_Quebec.csv" | awk '{print $5}')
    echo -e "${BLUE}Original Files:${NC}"
    echo "  2021 census: $original_2021"
fi

if [ -f "$CENSUS_DIR/2016/98-401-X2016044_Quebec_eng_CSV.csv" ]; then
    original_2016=$(ls -lh "$CENSUS_DIR/2016/98-401-X2016044_Quebec_eng_CSV.csv" | awk '{print $5}')
    echo "  2016 census: $original_2016"
fi

echo ""

################################################################################
# Suggestions
################################################################################

if [ $total -eq 0 ]; then
    echo -e "${YELLOW}No extractions yet!${NC}"
    echo ""
    echo "To get started:"
    echo "  1. Run: ./extract_census_data.sh"
    echo "  2. Find more characteristics: ./find_characteristic_ids.sh 'search term'"
    echo "  3. Add them to extract_census_data.sh"
    echo "  4. Run extraction again"
elif [ $total -lt 10 ]; then
    echo -e "${GREEN}Good start!${NC}"
    echo ""
    echo "To add more extractions:"
    echo "  1. Search: ./find_characteristic_ids.sh 'bicycle'"
    echo "  2. Edit extract_census_data.sh"
    echo "  3. Uncomment and update the relevant lines"
    echo "  4. Run: ./extract_census_data.sh"
else
    echo -e "${GREEN}You have a comprehensive extraction!${NC}"
    echo ""
    echo "These files are ready to load in QGIS:"
    echo "  Layer → Add Delimited Text Layer"
    echo "  Browse to: $OUTPUT_2021"
    echo "  No filtering needed!"
fi

echo ""
