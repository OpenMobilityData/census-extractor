# Census Extractor - OpenMobilityData Setup

Quick setup guide for publishing census-extractor to the OpenMobilityData organization.

---

## 🚀 Quick Setup (5 minutes)

### Step 1: Create Project Directory

```bash
cd ~/Documents/QGIS/Mobility
mkdir census-extractor
cd census-extractor
```

### Step 2: Copy Downloaded Files

```bash
# Copy all 11 files you downloaded to this directory
# (extract_census_data.sh, find_characteristic_ids.sh, show_extractions.sh,
#  Makefile, setup.sh, README.md, etc.)
```

### Step 3: Run Interactive Setup

```bash
chmod +x setup.sh
./setup.sh
```

This will:
- Configure your census data path
- Make scripts executable
- Add ~/bin to PATH (if needed)
- Install scripts globally
- Initialize git repository

### Step 4: Push to GitHub (OpenMobilityData)

**Using GitHub CLI (recommended):**

```bash
gh repo create OpenMobilityData/census-extractor \
  --public \
  --source=. \
  --description="Shell scripts to efficiently extract specific characteristics from Statistics Canada census data for QGIS analysis" \
  --push
```

**Or manually:**

1. Go to: https://github.com/organizations/OpenMobilityData/repositories/new
2. Repository name: `census-extractor`
3. Public repository
4. Create repository
5. Then:

```bash
git remote add origin https://github.com/OpenMobilityData/census-extractor.git
git branch -M main
git push -u origin main
```

### Step 5: Test Installation

```bash
# These commands should now work from anywhere:
extract_census_data
find_characteristic_ids "bicycle"
show_extractions
```

---

## 📋 What Gets Published

Your repository at `https://github.com/OpenMobilityData/census-extractor` will contain:

```
census-extractor/
├── README.md                       # Project overview
├── LICENSE                         # MIT License
├── Makefile                        # make install
├── .gitignore                      # Excludes CSV files
├── setup.sh                        # Interactive setup
├── extract_census_data.sh          # Main script
├── find_characteristic_ids.sh      # Search tool
├── show_extractions.sh             # Status viewer
├── CENSUS_EXTRACTION_GUIDE.md      # Detailed docs
├── QUICK_REFERENCE.txt             # Cheat sheet
└── GIT_SETUP_GUIDE.md              # This guide
```

**Note:** Census data files (CSVs) are NOT committed (excluded by .gitignore)

---

## 🎯 Repository Settings

**URL:** https://github.com/OpenMobilityData/census-extractor

**Topics to add (on GitHub):**
- census
- statistics-canada
- qgis
- gis
- data-processing
- shell-script
- spatial-analysis
- canada
- census-data
- geospatial
- open-data
- mobility

**Description:**
```
Shell scripts to efficiently extract specific characteristics from Statistics Canada census data for QGIS analysis. Pre-filter large CSVs into small, focused files for 10x faster loading.
```

---

## 👥 For Other Users to Install

Once published, others can install it like this:

```bash
# Clone the repository
git clone https://github.com/OpenMobilityData/census-extractor.git
cd census-extractor

# Run setup
./setup.sh

# Or just install directly
make install
```

Then edit the scripts to update `CENSUS_DIR` to their local path.

---

## 🔄 Updating the Repository

### After making changes:

```bash
cd ~/Documents/QGIS/Mobility/census-extractor

# Make changes to scripts
nano extract_census_data.sh

# Reinstall locally
make install

# Test
extract_census_data

# Commit and push
git add .
git commit -m "Add new characteristic extraction"
git push
```

---

## 📝 Adding to OpenMobilityData Website

If OpenMobilityData has a website or documentation:

**Short description:**
```
Census Extractor - Shell scripts to pre-filter Statistics Canada census 
data for efficient QGIS analysis. Extracts specific characteristics from 
350MB+ CSV files into focused 500KB files, providing 10x faster loading.
```

**Use case:**
```
Transportation planners and GIS analysts working with Canadian census data 
often need only a few characteristics but must load entire multi-hundred 
megabyte files. This toolkit pre-extracts only what's needed, dramatically 
improving QGIS performance.
```

---

## 🎓 Documentation Links

For users, direct them to:

1. **Quick Start:** https://github.com/OpenMobilityData/census-extractor/blob/main/README.md
2. **Installation:** Run `./setup.sh` or `make install`
3. **Full Guide:** CENSUS_EXTRACTION_GUIDE.md
4. **Command Reference:** QUICK_REFERENCE.txt

---

## 🐛 Issues and Contributions

**Enable Issues on GitHub:**
1. Go to repository Settings
2. Check "Issues" under Features
3. Users can report bugs or request features

**Contribution guidelines:**
- Fork the repository
- Create a feature branch
- Make changes
- Submit a pull request
- Include clear description and examples

---

## 📊 Project Stats to Track

Monitor these on GitHub:
- Stars (popularity)
- Forks (usage)
- Clones (downloads)
- Issues (user feedback)
- Pull requests (contributions)

---

## ✅ Checklist

Before publishing:
- [x] All files created
- [x] Scripts tested
- [x] Documentation complete
- [x] .gitignore configured
- [x] License added (MIT)
- [x] Makefile working
- [x] Setup script functional

After publishing:
- [ ] Repository created on GitHub
- [ ] All files pushed
- [ ] Topics/tags added
- [ ] Description set
- [ ] Issues enabled
- [ ] README looks good on GitHub
- [ ] Installation instructions tested

---

## 🎉 You're Ready!

Run these commands to publish:

```bash
cd ~/Documents/QGIS/Mobility/census-extractor
./setup.sh
gh repo create OpenMobilityData/census-extractor --public --source=. --push
```

Then visit:
**https://github.com/OpenMobilityData/census-extractor**

Your toolkit is now part of OpenMobilityData! 🚀
