# Setting Up census-extractor with Git and GitHub

## Step-by-Step Setup Guide

### Prerequisites

- Git installed on your system
- GitHub account
- GitHub CLI (`gh`) installed (optional but recommended)

---

## Part 1: Create Local Repository

### Step 1: Create project directory

```bash
cd ~/Documents/QGIS/Mobility
mkdir census-extractor
cd census-extractor
```

### Step 2: Copy all project files

Copy these files to the census-extractor directory:
- extract_census_data.sh
- find_characteristic_ids.sh
- show_extractions.sh
- Makefile
- README.md
- CENSUS_EXTRACTION_GUIDE.md
- QUICK_REFERENCE.txt
- .gitignore
- LICENSE

```bash
# From your downloads/outputs folder:
cp /path/to/downloaded/files/* ~/Documents/QGIS/Mobility/census-extractor/
```

### Step 3: Initialize git repository

```bash
cd ~/Documents/QGIS/Mobility/census-extractor

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Census extraction toolkit

- Shell scripts for extracting census characteristics
- Makefile for easy installation
- Comprehensive documentation
- Quick reference guide"
```

---

## Part 2: Create GitHub Repository

### Option A: Using GitHub CLI (Recommended)

**Install GitHub CLI if needed:**
```bash
# On macOS with Homebrew
brew install gh

# Authenticate (one-time setup)
gh auth login
```

**Create and push repository:**
```bash
cd ~/Documents/QGIS/Mobility/census-extractor

# Create GitHub repo and push
gh repo create census-extractor \
  --public \
  --source=. \
  --description="Shell scripts to efficiently extract specific characteristics from Statistics Canada census data for QGIS analysis" \
  --push
```

**Done!** Your repo is now on GitHub.

### Option B: Using GitHub Web Interface

**1. Create repository on GitHub:**
- Go to https://github.com/new
- Repository name: `census-extractor`
- Description: "Shell scripts to efficiently extract specific characteristics from Statistics Canada census data for QGIS analysis"
- Public repository
- Don't initialize with README (you already have one)
- Click "Create repository"

**2. Connect local repo to GitHub:**

GitHub will show you commands. Use these:

```bash
cd ~/Documents/QGIS/Mobility/census-extractor

# Add GitHub as remote
git remote add origin https://github.com/YOUR_USERNAME/census-extractor.git

# Push to GitHub
git branch -M main
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

---

## Part 3: Install the Scripts

### Step 1: Install to ~/bin/

```bash
cd ~/Documents/QGIS/Mobility/census-extractor

# Install scripts
make install
```

This installs:
- `extract_census_data` → ~/bin/
- `find_characteristic_ids` → ~/bin/
- `show_extractions` → ~/bin/

(Note: .sh extension removed for cleaner command names)

### Step 2: Ensure ~/bin is in your PATH

**Check if ~/bin is in PATH:**
```bash
echo $PATH | grep "$HOME/bin"
```

**If not in PATH, add it:**

For Zsh (macOS default):
```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

For Bash:
```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Step 3: Test installation

```bash
# Test that commands are available
which extract_census_data
which find_characteristic_ids
which show_extractions

# Run a command
extract_census_data --help  # or just run it
```

---

## Part 4: Configure Census Data Paths

### Step 1: Update script paths

The scripts have hardcoded paths. Update them for your system:

```bash
cd ~/Documents/QGIS/Mobility/census-extractor

# Edit the scripts to update paths
# Change this line in each script:
#   CENSUS_DIR="/Users/rhoge/Documents/QGIS/Mobility/data/census"
# To your actual path

# Use sed for quick update (backup first!)
cp extract_census_data.sh extract_census_data.sh.bak

sed -i '' 's|/Users/rhoge/Documents/QGIS/Mobility/data/census|YOUR_ACTUAL_PATH|g' \
  extract_census_data.sh \
  find_characteristic_ids.sh \
  show_extractions.sh
```

Or just edit manually with your preferred text editor.

### Step 2: Commit the path changes

```bash
git add extract_census_data.sh find_characteristic_ids.sh show_extractions.sh
git commit -m "Update census data paths for local environment"
```

**Note:** Consider making paths configurable via environment variables for better portability.

### Step 3: Reinstall with updated paths

```bash
make install
```

---

## Part 5: First Extraction

### Step 1: Run extraction

```bash
cd ~/Documents/QGIS/Mobility/data/census

# Or from anywhere:
extract_census_data
```

### Step 2: Check results

```bash
show_extractions
```

You should see:
- 2021/extracted/population.csv
- 2021/extracted/households.csv
- 2021/extracted/commuters_total.csv
- Same for 2016

---

## Part 6: Future Updates

### Adding new extractions

```bash
# Find characteristic IDs
find_characteristic_ids "bicycle"

# Edit the extraction script
cd ~/Documents/QGIS/Mobility/census-extractor
nano extract_census_data.sh  # or your preferred editor

# Add new extraction lines
# extract_2021 "2609" "commuters_cycling"
# extract_2016 "1936" "commuters_cycling"

# Reinstall
make install

# Run extraction
extract_census_data

# Commit changes
git add extract_census_data.sh
git commit -m "Add bicycle commuter extraction"
git push
```

### Keeping GitHub updated

```bash
cd ~/Documents/QGIS/Mobility/census-extractor

# After making changes
git add .
git commit -m "Description of changes"
git push
```

---

## Repository Structure

Your final repository structure:

```
census-extractor/
├── .git/                           # Git internals
├── .gitignore                      # Ignore census data files
├── LICENSE                         # MIT License
├── Makefile                        # Installation automation
├── README.md                       # Quick start guide
├── CENSUS_EXTRACTION_GUIDE.md      # Detailed documentation
├── QUICK_REFERENCE.txt             # Command cheat sheet
├── extract_census_data.sh          # Main extraction script
├── find_characteristic_ids.sh      # ID search tool
└── show_extractions.sh             # Status viewer
```

---

## Useful Git Commands

### See what's changed
```bash
git status
git diff
```

### Create a new feature
```bash
git checkout -b feature/new-extraction
# Make changes
git add .
git commit -m "Add new extraction"
git push -u origin feature/new-extraction
```

### Update from GitHub
```bash
git pull
```

### View history
```bash
git log --oneline
```

---

## Making it Better

### Environment Variable Support

Consider adding to scripts:
```bash
# Allow override via environment variable
CENSUS_DIR="${CENSUS_DIR:-/Users/rhoge/Documents/QGIS/Mobility/data/census}"
```

Then users can:
```bash
export CENSUS_DIR="/custom/path"
extract_census_data
```

### Add to Makefile

```makefile
# In Makefile, add:
configure:
	@echo "Setting up configuration..."
	@read -p "Enter census data directory: " dir; \
	sed -i '' "s|CENSUS_DIR=.*|CENSUS_DIR=\"$$dir\"|" extract_census_data.sh
```

---

## Troubleshooting

### "Permission denied" when running scripts
```bash
chmod +x *.sh
make install
```

### "Command not found" after installation
```bash
# Check PATH
echo $PATH

# Ensure ~/bin is included
export PATH="$HOME/bin:$PATH"

# Or reinstall
make install
```

### Git push fails with authentication error
```bash
# Use SSH instead of HTTPS
git remote set-url origin git@github.com:YOUR_USERNAME/census-extractor.git

# Or authenticate with gh
gh auth login
```

### Paths don't match your system
Edit the scripts and update `CENSUS_DIR` variable, then:
```bash
make install
```

---

## Next Steps

1. ✅ Create local repository
2. ✅ Push to GitHub
3. ✅ Install scripts with `make install`
4. ✅ Update paths in scripts
5. ✅ Run first extraction
6. 🎯 Find more characteristic IDs
7. 🎯 Add more extractions
8. 🎯 Load in QGIS
9. 🎯 Create amazing maps!

---

**Your census extraction toolkit is now properly version controlled and ready to use!** 🚀
