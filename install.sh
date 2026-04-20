#!/usr/bin/env bash

echo "================================================"
echo "   Software Testing & Quality Assurance"
echo "           Lab File Downloader"
echo "================================================"
echo ""

# Base URL of your GitHub repo (raw content)
REPO_BASE="https://raw.githubusercontent.com/ashleyxdev/stqa-suite/master"

# Parallel arrays: ids, names, types, sections
IDS=(1 2 3 4 5 7 8 9 10 11 99 100)

NAMES=(
    "1-gmail-login-test-suite.xlsx"
    "2-two-website-test-suite.xlsx"
    "3-social-media-app-test-suite.xlsx"
    "4-defect-report.xlsx"
    "5-LoginTest.java"
    "7-update-student-records.py"
    "8-select-student-marks.py"
    "9-CountObjects.java"
    "10-CountListItems.java"
    "11-CountCheckboxes.java"
    "selenium-setup-guide.md"
    "pom.xml"
)

TYPES=(
    "Excel"
    "Excel"
    "Excel"
    "Excel"
    "Java"
    "Python"
    "Python"
    "Java"
    "Java"
    "Java"
    "Markdown"
    "XML"
)

SECTIONS=(
    "Practical"
    "Practical"
    "Practical"
    "Practical"
    "Practical"
    "Practical"
    "Practical"
    "Practical"
    "Practical"
    "Practical"
    "Setup"
    "Setup"
)

# Display: Lab Practicals
echo "Lab Practicals:"
echo "---------------"
for i in "${!IDS[@]}"; do
    if [[ "${SECTIONS[$i]}" == "Practical" ]]; then
        echo "  ${IDS[$i]}. [${TYPES[$i]}] ${NAMES[$i]}"
    fi
done

echo ""

# Display: Helper / Setup Files
echo "Helper / Setup Files:"
echo "---------------------"
for i in "${!IDS[@]}"; do
    if [[ "${SECTIONS[$i]}" == "Setup" ]]; then
        echo "  ${IDS[$i]}. [${TYPES[$i]}] ${NAMES[$i]}"
    fi
done

# Build valid IDs string for display
VALID_IDS=$(IFS=", "; echo "${IDS[*]}")

echo ""
read -rp "Enter your choice [$VALID_IDS]: " CHOICE

# Find the selected entry
SELECTED_INDEX=-1
for i in "${!IDS[@]}"; do
    if [[ "${IDS[$i]}" == "$CHOICE" ]]; then
        SELECTED_INDEX=$i
        break
    fi
done

if [[ $SELECTED_INDEX -eq -1 ]]; then
    echo "Invalid choice! Please enter one of: $VALID_IDS"
    exit 1
fi

SELECTED_NAME="${NAMES[$SELECTED_INDEX]}"
FILE_URL="$REPO_BASE/$SELECTED_NAME"

echo ""
echo "Downloading $SELECTED_NAME..."

if curl -fsSL "$FILE_URL" -o "$SELECTED_NAME"; then
    echo "✅ Download complete! File saved as: $SELECTED_NAME"
else
    echo "❌ Failed to download file. Please check the repository link or filename."
    exit 1
fi

echo ""
echo "Done!"