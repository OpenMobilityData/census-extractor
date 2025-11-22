# Census Data Extraction Guide

## Overview

This system extracts specific characteristics from large Statistics Canada census CSV files into small, focused files for efficient QGIS loading.

## Files

1. **extract_census_data.sh** - Main extraction script
2. **find_characteristic_ids.sh** - Helper to find characteristic IDs
3. This guide

## Quick Start

### 1. Make scripts executable

```bash
cd /Users/rhoge/Documents/QGIS/Mobility/data/census
chmod +x extract_census_data.sh find_characteristic_ids.sh
```

### 2. Run initial extraction

```bash
./extract_census_data.sh
```

This creates:
```
census/
├── 2016/extracted/
│   ├── population.csv
│   ├── households.csv
│   └── commuters_total.csv
└── 2021/extracted/
    ├── population.csv
    ├── households.csv
    └── commuters_total.csv
```

### 3. Find IDs for additional characteristics

```bash
# Find commuting by car (as driver)
./find_characteristic_ids.sh "car.*driver"

# Find public transit commuters
./find_characteristic_ids.sh "public transit"

# Find cyclists
./find_characteristic_ids.sh "bicycle"

# Find walkers
./find_characteristic_ids.sh "walked"

# Find work from home
./find_characteristic_ids.sh "work.*home"

# Find age groups
./find_characteristic_ids.sh "15 to 19"
./find_characteristic_ids.sh "60 to 64"
```

### 4. Add new extractions

Edit `extract_census_data.sh` and uncomment/update the relevant lines:

```bash
# Example: After finding that "Car as driver" is ID 2605 in 2021
extract_2021 "2605" "commuters_driving"
extract_2016 "1932" "commuters_driving"  # After finding 2016 ID
```

### 5. Re-run extraction

```bash
./extract_census_data.sh
```

### 6. Load in QGIS

```
Layer → Add Delimited Text Layer
Browse to: census/2021/extracted/commuters_driving.csv
No geometry
No filter needed!
```

## Census Structure Differences

### 2021 Census
- Field: `CHARACTERISTIC_ID` (column 2)
- Description field: `CHARACTERISTIC_NAME` (column 3)
- Example: ID "2603" = Total commuters

### 2016 Census
- Field: `Member ID: Profile of Dissemination Areas (2247)` (column 10)
- Description field: `DIM: Profile of Dissemination Areas (2247)` (column 9)
- Example: ID "1930" = Total commuters

## Common Characteristics to Extract

### Commuting Modes (Main mode of commuting)

**What to search for:**
```bash
./find_characteristic_ids.sh "Main mode of commuting"
```

This will show all sub-categories. Look for:
- Car, truck, van - as a driver
- Car, truck, van - as a passenger
- Public transit
- Walked
- Bicycle
- Other method

### Work Location

**What to search for:**
```bash
./find_characteristic_ids.sh "place of work"
```

Look for:
- Worked at home
- Worked outside Canada
- No fixed workplace address
- Usual place of work

### Age Groups

**What to search for:**
```bash
./find_characteristic_ids.sh "age"
```

Common age groups:
- 0 to 14 years
- 15 to 19 years
- 20 to 24 years
- 25 to 29 years
- ...
- 60 to 64 years
- 65 years and over

### Labour Force

**What to search for:**
```bash
./find_characteristic_ids.sh "labour force"
```

Look for:
- In the labour force
- Employed
- Unemployed
- Not in the labour force

### Education

**What to search for:**
```bash
./find_characteristic_ids.sh "education"
```

### Income

**What to search for:**
```bash
./find_characteristic_ids.sh "income"
```

## Tips

### 1. Use grep patterns for flexible searching

```bash
# Find anything with "car" or "vehicle"
./find_characteristic_ids.sh "car\|vehicle"

# Find age ranges
./find_characteristic_ids.sh "[0-9]+ to [0-9]+"
```

### 2. Check both years

The search script shows results from both 2016 and 2021. IDs are different between years!

### 3. Verify extractions

After extraction, check file sizes:
```bash
ls -lh census/2021/extracted/
```

Each file should be ~500 KB for Montreal/Laval DAs.

### 4. Filter to Montreal/Laval if needed

The extractions include ALL Quebec DAs. To filter to just Montreal/Laval:

**Option A: In the extraction script, add filtering:**
```bash
# After extracting, filter to Montreal/Laval
awk -F',' '$2 ~ /^2465|^2466/' input.csv > output.csv
```

**Option B: Filter in QGIS (current approach):**
Keep the filter on your DA boundaries layer.

### 5. Backup originals

Keep the original large CSV files - they're your source of truth:
```bash
# Never delete these:
census/2016/98-401-X2016044_Quebec_eng_CSV.csv
census/2021/98-401-X2021006_English_CSV_data_Quebec.csv
```

## Troubleshooting

### "No such file or directory"
Check paths in the script match your actual file locations.

### "No data rows found"
The characteristic ID might be wrong. Use `find_characteristic_ids.sh` to verify.

### Extracted file is empty (only header)
Either:
1. Wrong ID number
2. Wrong column being matched
3. File encoding issue

Try searching manually:
```bash
# Check what IDs actually exist
head -100 census/2021/98-401-X2021006_English_CSV_data_Quebec.csv | cut -d',' -f2 | sort -u
```

### Search finds too many results
Be more specific with your search term:
```bash
# Instead of:
./find_characteristic_ids.sh "age"

# Try:
./find_characteristic_ids.sh "^15 to 19"
```

## Performance Comparison

**Before (full CSVs with QGIS filters):**
- Project file: 50+ MB
- Load time: 30-60 seconds
- Memory usage: 2-4 GB
- Total data loaded: ~350 MB

**After (pre-extracted CSVs):**
- Project file: 5-10 MB
- Load time: 5-10 seconds
- Memory usage: 500 MB - 1 GB
- Total data loaded: ~3-5 MB

**~10x faster, ~5x less memory!**

## Adding New Characteristics

### Workflow:

1. **Identify what you need**
   - Example: "Number of people who bike to work"

2. **Search for it**
   ```bash
   ./find_characteristic_ids.sh "bicycle"
   ```

3. **Note the IDs**
   ```
   2021: ID 2609
   2016: ID 1936
   ```

4. **Add to extraction script**
   ```bash
   # Add to COMMUTING DATA section
   extract_2021 "2609" "commuters_cycling"
   extract_2016 "1936" "commuters_cycling"
   ```

5. **Run extraction**
   ```bash
   ./extract_census_data.sh
   ```

6. **Load in QGIS**
   ```
   Load census/2021/extracted/commuters_cycling.csv
   ```

7. **Join to DA boundaries as usual**

## Future Enhancements

### Combine related characteristics

Create calculated fields in a single CSV:
```bash
# Extract multiple, then combine
extract_2021 "2605" "temp_driver"
extract_2021 "2606" "temp_passenger"

# Sum them (requires more complex scripting)
# Or just load both and sum in QGIS Field Calculator
```

### Filter to Montreal/Laval during extraction

Add geographic filtering to reduce file sizes further:
```bash
# Only extract Montreal/Laval DAs
awk -F',' '$4 ~ /Montreal|Laval/ && $10 == "1930"' input.csv
```

### Automate QGIS project updates

Generate a QGIS Python script to:
1. Remove old filtered layers
2. Load all extracted CSVs
3. Set up joins
4. Apply styling

## Reference

### Key Census Variables

| Variable | 2021 ID | 2016 ID | Notes |
|----------|---------|---------|-------|
| Population | 1 | 1 | Total population |
| Households | 1414 | 1617 | Total private households |
| Total commuters | 2603 | 1930 | All modes combined |
| Car (driver) | ? | ? | Need to find |
| Public transit | ? | ? | Need to find |
| Bicycle | ? | ? | Need to find |
| Walked | ? | ? | Need to find |
| Work at home | ? | ? | Need to find |

Use `find_characteristic_ids.sh` to fill in the "?" values!

## Questions?

Common searches to try:
```bash
# Transportation
./find_characteristic_ids.sh "commut"
./find_characteristic_ids.sh "journey to work"
./find_characteristic_ids.sh "mode"

# Demographics
./find_characteristic_ids.sh "age"
./find_characteristic_ids.sh "sex"

# Labour
./find_characteristic_ids.sh "labour"
./find_characteristic_ids.sh "occupation"
./find_characteristic_ids.sh "industry"

# Housing
./find_characteristic_ids.sh "dwelling"
./find_characteristic_ids.sh "tenure"
```
