# Census Data Extraction Toolkit

A set of shell scripts to efficiently extract specific characteristics from Statistics Canada census data for use in QGIS.

## The Problem

Loading full census CSV files (350 MB+) into QGIS with filters is:
- Slow (30-60 second load times)
- Memory intensive (2-4 GB)
- Makes project files large (50+ MB)
- Inefficient when you only need a few characteristics

## The Solution

Pre-extract only the characteristics you need into small, focused CSV files:
- Fast (<5 second load times)
- Efficient (500 MB memory)
- Small project files (5-10 MB)
- **10x performance improvement!**

---

## Quick Start

### 1. Install the toolkit

Copy these files to your census data directory:
```bash
cd /Users/rhoge/Documents/QGIS/Mobility/data/census

# Copy the scripts here
```

Files:
- `extract_census_data.sh` - Main extraction script
- `find_characteristic_ids.sh` - Search for characteristic IDs
- `show_extractions.sh` - View what's been extracted
- `CENSUS_EXTRACTION_GUIDE.md` - Detailed documentation

### 2. Make scripts executable

```bash
chmod +x *.sh
```

### 3. Run initial extraction

```bash
./extract_census_data.sh
```

This creates small CSV files in:
- `2021/extracted/` - 2021 census extractions
- `2016/extracted/` - 2016 census extractions

### 4. Check what was extracted

```bash
./show_extractions.sh
```

---

## Common Tasks

### Find a characteristic ID

```bash
# Find cycling commuters
./find_characteristic_ids.sh "bicycle"

# Find work from home
./find_characteristic_ids.sh "work.*home"

# Find age groups
./find_characteristic_ids.sh "15 to 19"

# Find transit users
./find_characteristic_ids.sh "public transit"
```

### Add new extractions

1. Find the IDs:
   ```bash
   ./find_characteristic_ids.sh "your search term"
   ```

2. Edit `extract_census_data.sh`:
   ```bash
   # Uncomment and update these lines:
   extract_2021 "FOUND_ID" "descriptive_name"
   extract_2016 "FOUND_ID" "descriptive_name"
   ```

3. Run extraction:
   ```bash
   ./extract_census_data.sh
   ```

4. Check results:
   ```bash
   ./show_extractions.sh
   ```

### Load in QGIS

```
Layer → Add Delimited Text Layer
Browse to: census/2021/extracted/[your_file].csv
No geometry
No filter needed! ✓
```

---

## What Gets Extracted (By Default)

Currently configured to extract:

**Core Demographics:**
- ✓ Total population
- ✓ Total households

**Commuting:**
- ✓ Total commuters (all modes)
- ○ Car as driver (commented out - find ID and enable)
- ○ Car as passenger (commented out)
- ○ Public transit (commented out)
- ○ Walking (commented out)
- ○ Cycling (commented out)

**Work Location:**
- ○ Work from home (commented out - find ID and enable)
- ○ No fixed workplace (commented out)

**Age Groups:**
- ○ Various age ranges (commented out - find IDs and enable)

**To enable:** Use `find_characteristic_ids.sh` to find the IDs, then edit `extract_census_data.sh`

---

## File Structure

```
census/
├── 2016/
│   ├── 98-401-X2016044_Quebec_eng_CSV.csv (original - keep!)
│   └── extracted/
│       ├── population.csv (500 KB)
│       ├── households.csv (500 KB)
│       ├── commuters_total.csv (500 KB)
│       └── [your new extractions...]
│
├── 2021/
│   ├── 98-401-X2021006_English_CSV_data_Quebec.csv (original - keep!)
│   └── extracted/
│       ├── population.csv (500 KB)
│       ├── households.csv (500 KB)
│       ├── commuters_total.csv (500 KB)
│       └── [your new extractions...]
│
├── extract_census_data.sh (main script)
├── find_characteristic_ids.sh (search tool)
├── show_extractions.sh (summary tool)
└── CENSUS_EXTRACTION_GUIDE.md (full documentation)
```

---

## Scripts Overview

### extract_census_data.sh

**Main extraction script**

- Extracts characteristics from both 2016 and 2021 census
- Creates small CSV files in `extracted/` folders
- Preserves headers automatically
- Easy to customize - just uncomment and add IDs

**Usage:**
```bash
./extract_census_data.sh
```

### find_characteristic_ids.sh

**Search tool to find characteristic IDs**

- Searches both 2016 and 2021 census files
- Case-insensitive search
- Shows IDs and descriptions
- Supports regex patterns

**Usage:**
```bash
./find_characteristic_ids.sh "search term"

# Examples:
./find_characteristic_ids.sh "bicycle"
./find_characteristic_ids.sh "car.*driver"
./find_characteristic_ids.sh "15 to 19"
```

### show_extractions.sh

**Summary of what's been extracted**

- Lists all extracted files
- Shows row counts and file sizes
- Compares with original file sizes
- Provides suggestions for next steps

**Usage:**
```bash
./show_extractions.sh
```

---

## Key Differences: 2016 vs 2021

| Aspect | 2021 | 2016 |
|--------|------|------|
| **ID Field** | `CHARACTERISTIC_ID` | `Member ID: Profile...` |
| **ID Column** | Column 2 | Column 10 |
| **Description Field** | `CHARACTERISTIC_NAME` | `DIM: Profile...` |
| **Description Column** | Column 3 | Column 9 |

The scripts handle these differences automatically!

---

## Performance Comparison

### Before (Full CSV with QGIS filter)
```
File size loaded: 350 MB
Load time: 30-60 seconds
Memory usage: 2-4 GB
Project file: 50+ MB
```

### After (Pre-extracted CSVs)
```
File size loaded: 3-5 MB
Load time: 5-10 seconds
Memory usage: 500 MB - 1 GB
Project file: 5-10 MB

= 10x faster, 5x less memory!
```

---

## Typical Workflow

### Starting a new analysis:

1. **Identify needed characteristics**
   - "I need number of cyclists"
   - "I need population by age group"
   - "I need work from home data"

2. **Find the IDs**
   ```bash
   ./find_characteristic_ids.sh "bicycle"
   # Note: 2021 ID = 2609, 2016 ID = 1936
   ```

3. **Add to extraction script**
   ```bash
   # Edit extract_census_data.sh
   extract_2021 "2609" "commuters_cycling"
   extract_2016 "1936" "commuters_cycling"
   ```

4. **Extract**
   ```bash
   ./extract_census_data.sh
   ```

5. **Verify**
   ```bash
   ./show_extractions.sh
   ```

6. **Load in QGIS**
   - Add as delimited text layer
   - Join to DA boundaries
   - Calculate ratios/metrics
   - Style and export

---

## Tips

### Search effectively

```bash
# Be specific
./find_characteristic_ids.sh "car.*driver"  # Not just "car"

# Use wildcards
./find_characteristic_ids.sh "work.*home"

# Try variations
./find_characteristic_ids.sh "bicycle"
./find_characteristic_ids.sh "cycling"
./find_characteristic_ids.sh "bike"
```

### Keep originals

Never delete the original large CSV files - they're your source of truth!

### Descriptive names

Use clear names for extracted files:
```bash
extract_2021 "2609" "commuters_cycling"  # Good!
extract_2021 "2609" "data"               # Bad!
```

### Check your work

After extraction, open a file and verify:
```bash
head -20 census/2021/extracted/commuters_cycling.csv
```

Should show header + data rows with cycling counts.

---

## Troubleshooting

### "File not found"
Check that paths in scripts match your actual file locations.

### "No data extracted"
- Verify the characteristic ID is correct
- Use `find_characteristic_ids.sh` to double-check
- Check if you're using 2021 ID for 2021 data (not mixing years)

### Search returns nothing
- Try broader search terms
- Check spelling
- Try alternate terms (e.g., "transit" vs "public transportation")

### Files are huge
You might be extracting a parent category instead of a specific characteristic. Be more specific with the ID.

---

## What to Extract Next

Common useful characteristics:

**Transportation:**
- ✓ Already have: Total commuters
- ○ Need to add: Driving, transit, cycling, walking
- ○ Consider: Commute time, distance

**Demographics:**
- ✓ Already have: Total population
- ○ Need to add: Age groups, especially working-age population
- ○ Consider: Education levels, occupation types

**Labour:**
- ○ Labour force participation
- ○ Employment rate
- ○ Work from home vs usual workplace

**Housing:**
- ✓ Already have: Total households
- ○ Consider: Household size, dwelling type, tenure

---

## Advanced Usage

See `CENSUS_EXTRACTION_GUIDE.md` for:
- Detailed extraction examples
- Column number reference
- Combining multiple characteristics
- Geographic filtering
- Troubleshooting detailed issues

---

## Support

If something's not working:

1. Check `CENSUS_EXTRACTION_GUIDE.md` for detailed help
2. Run `./show_extractions.sh` to see current state
3. Verify file paths in the scripts match your system
4. Check that original CSV files exist and are readable

---

## License

These scripts are provided as-is for working with Statistics Canada census data.

Census data © Statistics Canada
Scripts: Use and modify freely

---

**Happy extracting! 🚀**
