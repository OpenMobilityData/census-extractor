# Census Data File Structure Reference

## Actual File Locations

Based on your system, here are the correct file paths:

### 2021 Census Data

**CSV File:**
```
/Users/rhoge/Documents/QGIS/Mobility/data/census/2021/98-401-X2021006_English_CSV_data_Quebec.csv
```

**Shapefile (DA Boundaries):**
```
/Users/rhoge/Documents/QGIS/Mobility/data/census/2021/lda_000a21a_e.*
```

**Files:**
- lda_000a21a_e.shp (main file)
- lda_000a21a_e.dbf (attributes)
- lda_000a21a_e.shx (index)
- lda_000a21a_e.prj (projection)
- lda_000a21a_e.cpg (encoding)
- lda_000a21a_e.xml (metadata)
- lda_000a21a_e.qix (spatial index)

---

### 2016 Census Data

**CSV File:**
```
/Users/rhoge/Documents/QGIS/Mobility/data/census/2016/98-401-X2016044_QUEBEC_English_CSV_data.csv
```

**Note:** Filename is different from 2021:
- 2016: `98-401-X2016044_QUEBEC_English_CSV_data.csv` (QUEBEC in caps, no underscore before English)
- 2021: `98-401-X2021006_English_CSV_data_Quebec.csv` (Quebec at end, underscore before English)

**Shapefile (DA Boundaries):**
```
/Users/rhoge/Documents/QGIS/Mobility/data/census/2016/lda_000a16a_e.*
```

**Files:**
- lda_000a16a_e.shp (main file)
- lda_000a16a_e.dbf (attributes)
- lda_000a16a_e.shx (index)
- lda_000a16a_e.prj (projection)

**Note:** 2016 has fewer companion files than 2021 (no .cpg, .xml, .qix)

---

### Additional 2016 Files

**Documentation:**
- `98-401-X2016044_English_meta.txt` - Metadata description
- `README_meta.txt` - README for metadata
- `92-160-g2016002-eng.pdf` - Guide document
- `dissemination_area.html` - DA definitions

**Starting rows reference:**
- `Geo_starting_row_QUEBEC_CSV.csv` - Row index for geographic areas

---

## CSV Structure Differences

### 2021 Census CSV

**Key columns:**
- Column 1: `CENSUS_YEAR` = "2021"
- Column 2: `CHARACTERISTIC_ID` = numeric ID (e.g., "1", "1414", "2603")
- Column 3: `CHARACTERISTIC_NAME` = description
- Column 4: Geographic identifier fields...
- Column N: Data value

**Example row:**
```csv
2021,1,"Population, 2021",01,0,Canada,...,35151728
```

---

### 2016 Census CSV

**Key columns:**
- Column 1: `CENSUS_YEAR` = "2016"
- Column 9: `DIM: Profile of Dissemination Areas (2247)` = description
- Column 10: `Member ID: Profile of Dissemination Areas (2247)` = numeric ID
- Column 4: Geographic identifier fields...
- Column N: Data value

**Example row:**
```csv
2016,24660001,DA,Montreal,...,"Population, 2016",1,...,5575,...
```

**Critical difference:**
- 2021: CHARACTERISTIC_ID in column 2
- 2016: Member ID in column 10 (much later!)

---

## Script Configuration

All scripts now use these correct paths:

```bash
CENSUS_DIR="/Users/rhoge/Documents/QGIS/Mobility/data/census"
INPUT_2016="$CENSUS_DIR/2016/98-401-X2016044_QUEBEC_English_CSV_data.csv"
INPUT_2021="$CENSUS_DIR/2021/98-401-X2021006_English_CSV_data_Quebec.csv"
```

---

## Extraction Output Structure

After running `extract_census_data`, you'll have:

```
census/
├── 2016/
│   ├── 98-401-X2016044_QUEBEC_English_CSV_data.csv (original)
│   ├── lda_000a16a_e.* (DA boundaries)
│   └── extracted/
│       ├── population.csv
│       ├── households.csv
│       ├── commuters_total.csv
│       └── [additional extractions...]
│
└── 2021/
    ├── 98-401-X2021006_English_CSV_data_Quebec.csv (original)
    ├── lda_000a21a_e.* (DA boundaries)
    └── extracted/
        ├── population.csv
        ├── households.csv
        ├── commuters_total.csv
        └── [additional extractions...]
```

---

## Field Names for Joining in QGIS

### 2021 Census

**In CSV:**
- Geographic ID field: `DGUID` (e.g., "2021A00011234")

**In Shapefile (DA boundaries):**
- Geographic ID field: `DGUID`

**Join configuration:**
```
Join field: DGUID
Target field: DGUID
```

---

### 2016 Census

**In CSV:**
- Geographic ID field: `GEO_CODE (POR)` (e.g., "24660001")

**In Shapefile (DA boundaries):**
- Geographic ID field: `DAUID` (e.g., "24660001")

**Join configuration:**
```
Join field: GEO_CODE (POR)
Target field: DAUID
```

**Note:** Different field names between CSV and shapefile in 2016!

---

## Common Issues

### "File not found" Error

Check your actual filenames:
```bash
ls ~/Documents/QGIS/Mobility/data/census/2016/
ls ~/Documents/QGIS/Mobility/data/census/2021/
```

Compare with the `INPUT_2016` and `INPUT_2021` paths in the scripts.

### Different Province Data

These scripts are configured for **Quebec** data.

If you download other provinces, filenames will be different:
```
98-401-X2016044_ONTARIO_English_CSV_data.csv
98-401-X2016044_BRITISH-COLUMBIA_English_CSV_data.csv
etc.
```

Update `INPUT_2016` in the scripts accordingly.

---

## Reference: File Size Comparison

**Original files:**
- 2021 CSV: ~150 MB
- 2016 CSV: ~200 MB
- Total: ~350 MB

**After extraction (typical):**
- Each extracted CSV: ~500 KB
- 6 files (3 per year): ~3 MB
- **120x smaller!**

---

## Quick Verification

To verify your files are correct:

```bash
# Check 2021 structure
head -1 ~/Documents/QGIS/Mobility/data/census/2021/98-401-X2021006_English_CSV_data_Quebec.csv

# Should show: CENSUS_YEAR,DGUID,ALT_GEO_CODE,GEO_LEVEL,...

# Check 2016 structure  
head -1 ~/Documents/QGIS/Mobility/data/census/2016/98-401-X2016044_QUEBEC_English_CSV_data.csv

# Should show: CENSUS_YEAR,GEO_CODE (POR),GEO_LEVEL,...
```

If your headers match these, the scripts will work correctly!
