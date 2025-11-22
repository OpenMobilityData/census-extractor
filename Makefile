# Makefile for Census Data Extraction Toolkit
# Author: Ryan Hoge
# Description: Extracts specific characteristics from Statistics Canada census CSVs

# Installation directory
INSTALL_DIR = $(HOME)/bin

# Script files to install
SCRIPTS = extract_census_data.sh \
          find_characteristic_ids.sh \
          show_extractions.sh

# Documentation files (not installed, just for reference)
DOCS = README.md \
       CENSUS_EXTRACTION_GUIDE.md \
       QUICK_REFERENCE.txt

.PHONY: all install uninstall clean help test

# Default target
all: help

# Install scripts to ~/bin/
install:
	@echo "Installing census extraction scripts to $(INSTALL_DIR)..."
	@mkdir -p $(INSTALL_DIR)
	@for script in $(SCRIPTS); do \
		echo "  Installing $$script..."; \
		install -m 755 $$script $(INSTALL_DIR)/$$(basename $$script .sh); \
	done
	@echo ""
	@echo "✓ Installation complete!"
	@echo ""
	@echo "Scripts installed (without .sh extension):"
	@echo "  - extract_census_data"
	@echo "  - find_characteristic_ids"
	@echo "  - show_extractions"
	@echo ""
	@echo "Make sure $(INSTALL_DIR) is in your PATH."
	@echo "Add to ~/.zshrc or ~/.bashrc if needed:"
	@echo '  export PATH="$$HOME/bin:$$PATH"'
	@echo ""
	@echo "Usage examples:"
	@echo "  extract_census_data"
	@echo "  find_characteristic_ids 'bicycle'"
	@echo "  show_extractions"

# Uninstall scripts from ~/bin/
uninstall:
	@echo "Uninstalling census extraction scripts from $(INSTALL_DIR)..."
	@for script in $(SCRIPTS); do \
		target=$(INSTALL_DIR)/$$(basename $$script .sh); \
		if [ -f $$target ]; then \
			echo "  Removing $$target"; \
			rm -f $$target; \
		fi; \
	done
	@echo "✓ Uninstallation complete!"

# Clean generated files
clean:
	@echo "Cleaning up..."
	@find . -name "*.bak" -delete
	@find . -name "*~" -delete
	@find . -name ".DS_Store" -delete
	@echo "✓ Cleanup complete!"

# Test that scripts are valid bash
test:
	@echo "Testing script syntax..."
	@for script in $(SCRIPTS); do \
		echo "  Checking $$script..."; \
		bash -n $$script || exit 1; \
	done
	@echo "✓ All scripts have valid syntax!"

# Display help
help:
	@echo "Census Data Extraction Toolkit - Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make install    - Install scripts to ~/bin/"
	@echo "  make uninstall  - Remove scripts from ~/bin/"
	@echo "  make test       - Test script syntax"
	@echo "  make clean      - Remove backup and temporary files"
	@echo "  make help       - Show this help message"
	@echo ""
	@echo "Quick start:"
	@echo "  1. make install"
	@echo "  2. extract_census_data"
	@echo "  3. find_characteristic_ids 'your search term'"
	@echo ""
	@echo "Documentation:"
	@echo "  - README.md for quick start"
	@echo "  - CENSUS_EXTRACTION_GUIDE.md for detailed docs"
	@echo "  - QUICK_REFERENCE.txt for command reference"
