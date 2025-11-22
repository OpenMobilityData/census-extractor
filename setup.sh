#!/bin/bash

################################################################################
# Census Extractor - Quick Setup Script
# Automates initial setup and configuration
################################################################################

set -e  # Exit on error

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         Census Extractor - Quick Setup                      ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

################################################################################
# Step 1: Verify we're in the right directory
################################################################################

if [ ! -f "Makefile" ] || [ ! -f "extract_census_data.sh" ]; then
    echo -e "${RED}Error: Please run this script from the census-extractor directory${NC}"
    echo "  Expected files: Makefile, extract_census_data.sh"
    exit 1
fi

echo -e "${GREEN}✓${NC} Found project files"
echo ""

################################################################################
# Step 2: Configure census data path
################################################################################

echo -e "${BLUE}Step 1: Configure Census Data Path${NC}"
echo ""
echo "Current default path:"
echo "  /Users/rhoge/Documents/QGIS/Mobility/data/census"
echo ""
read -p "Enter your census data directory (or press Enter to use default): " census_dir

if [ -z "$census_dir" ]; then
    census_dir="/Users/rhoge/Documents/QGIS/Mobility/data/census"
fi

# Expand ~ if present
census_dir="${census_dir/#\~/$HOME}"

echo ""
echo "Will use: $census_dir"
echo ""

# Check if directory exists
if [ ! -d "$census_dir" ]; then
    echo -e "${YELLOW}Warning: Directory does not exist yet${NC}"
    read -p "Create it now? (y/n): " create_dir
    if [ "$create_dir" = "y" ]; then
        mkdir -p "$census_dir"
        echo -e "${GREEN}✓${NC} Created directory"
    fi
fi

# Update paths in scripts
echo "Updating paths in scripts..."
for script in extract_census_data.sh find_characteristic_ids.sh show_extractions.sh; do
    if [ -f "$script" ]; then
        # Create backup
        cp "$script" "${script}.bak"
        
        # Update path
        sed -i.tmp "s|CENSUS_DIR=.*|CENSUS_DIR=\"$census_dir\"|" "$script"
        rm -f "${script}.tmp"
        
        echo -e "${GREEN}✓${NC} Updated $script"
    fi
done

echo ""

################################################################################
# Step 3: Make scripts executable
################################################################################

echo -e "${BLUE}Step 2: Make Scripts Executable${NC}"
echo ""

chmod +x extract_census_data.sh find_characteristic_ids.sh show_extractions.sh
echo -e "${GREEN}✓${NC} Scripts are now executable"
echo ""

################################################################################
# Step 4: Check PATH
################################################################################

echo -e "${BLUE}Step 3: Check PATH Configuration${NC}"
echo ""

if echo "$PATH" | grep -q "$HOME/bin"; then
    echo -e "${GREEN}✓${NC} ~/bin is in your PATH"
else
    echo -e "${YELLOW}⚠${NC}  ~/bin is NOT in your PATH"
    echo ""
    echo "To add it, add this line to your shell config:"
    echo ""
    
    if [ -f "$HOME/.zshrc" ]; then
        echo "  echo 'export PATH=\"\$HOME/bin:\$PATH\"' >> ~/.zshrc"
        echo "  source ~/.zshrc"
        echo ""
        read -p "Add to ~/.zshrc now? (y/n): " add_path
        if [ "$add_path" = "y" ]; then
            echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
            export PATH="$HOME/bin:$PATH"
            echo -e "${GREEN}✓${NC} Added to ~/.zshrc"
            echo "  Run: source ~/.zshrc"
        fi
    elif [ -f "$HOME/.bashrc" ]; then
        echo "  echo 'export PATH=\"\$HOME/bin:\$PATH\"' >> ~/.bashrc"
        echo "  source ~/.bashrc"
        echo ""
        read -p "Add to ~/.bashrc now? (y/n): " add_path
        if [ "$add_path" = "y" ]; then
            echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
            export PATH="$HOME/bin:$PATH"
            echo -e "${GREEN}✓${NC} Added to ~/.bashrc"
            echo "  Run: source ~/.bashrc"
        fi
    fi
fi

echo ""

################################################################################
# Step 5: Install scripts
################################################################################

echo -e "${BLUE}Step 4: Install Scripts${NC}"
echo ""
read -p "Install scripts to ~/bin/ now? (y/n): " install_now

if [ "$install_now" = "y" ]; then
    make install
    echo ""
    echo -e "${GREEN}✓${NC} Scripts installed to ~/bin/"
    echo ""
    echo "Available commands:"
    echo "  - extract_census_data"
    echo "  - find_characteristic_ids"
    echo "  - show_extractions"
else
    echo "Skipped installation. Run 'make install' when ready."
fi

echo ""

################################################################################
# Step 6: Initialize Git (if not already done)
################################################################################

echo -e "${BLUE}Step 5: Git Setup${NC}"
echo ""

if [ -d ".git" ]; then
    echo -e "${GREEN}✓${NC} Git repository already initialized"
else
    read -p "Initialize git repository? (y/n): " init_git
    if [ "$init_git" = "y" ]; then
        git init
        git add .
        git commit -m "Initial commit: Census extraction toolkit"
        echo -e "${GREEN}✓${NC} Git repository initialized"
        echo ""
        echo "Next steps:"
        echo "  1. Create GitHub repo: gh repo create census-extractor --public --source=. --push"
        echo "  2. Or follow instructions in GIT_SETUP_GUIDE.md"
    fi
fi

echo ""

################################################################################
# Step 7: Summary and next steps
################################################################################

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    Setup Complete!                          ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "What's configured:"
echo -e "  ${GREEN}✓${NC} Census data path: $census_dir"
echo -e "  ${GREEN}✓${NC} Scripts are executable"
if echo "$PATH" | grep -q "$HOME/bin"; then
    echo -e "  ${GREEN}✓${NC} PATH includes ~/bin"
else
    echo -e "  ${YELLOW}⚠${NC}  PATH needs ~/bin (see above)"
fi

if [ "$install_now" = "y" ]; then
    echo -e "  ${GREEN}✓${NC} Scripts installed"
else
    echo -e "  ${YELLOW}⚠${NC}  Scripts not installed yet (run 'make install')"
fi

echo ""
echo "Next steps:"
echo ""
echo "  1. Ensure census CSV files are in:"
echo "     $census_dir/2016/"
echo "     $census_dir/2021/"
echo ""
echo "  2. Run your first extraction:"
echo "     extract_census_data"
echo ""
echo "  3. Find more characteristics:"
echo "     find_characteristic_ids 'bicycle'"
echo ""
echo "  4. Check results:"
echo "     show_extractions"
echo ""
echo "Documentation:"
echo "  - README.md - Quick start"
echo "  - CENSUS_EXTRACTION_GUIDE.md - Detailed guide"
echo "  - QUICK_REFERENCE.txt - Command reference"
echo "  - GIT_SETUP_GUIDE.md - Git and GitHub setup"
echo ""
echo -e "${GREEN}Happy extracting! 🚀${NC}"
