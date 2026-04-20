Write-Host "================================================"
Write-Host "   Software Testing & Quality Assurance"
Write-Host "           Lab File Downloader"
Write-Host "================================================"
Write-Host ""

# Base URL of your GitHub repo (raw content)
$repoBase = "https://raw.githubusercontent.com/ashleyxdev/stqa-suite/master"

# ID for practicals = their filename prefix number
# ID for setup files = 99, 100, ... (to avoid conflict with future practicals)
$labFiles = @(
    @{ id = 1;  name = "1-gmail-login-test-suite.xlsx";          type = "Excel";    section = "Practical" },
    @{ id = 2;  name = "2-two-website-test-suite.xlsx";          type = "Excel";    section = "Practical" },
    @{ id = 3;  name = "3-social-media-app-test-suite.xlsx";     type = "Excel";    section = "Practical" },
    @{ id = 4;  name = "4-defect-report.xlsx";                   type = "Excel";    section = "Practical" },
    @{ id = 5;  name = "5-LoginTest.java";                  type = "Java";     section = "Practical" },
    @{ id = 7;  name = "7-update-student-records.py";       type = "Python";   section = "Practical" },
    @{ id = 8;  name = "8-select-student-marks.py";         type = "Python";   section = "Practical" },
    @{ id = 9;  name = "9-CountObjects.java";               type = "Java";     section = "Practical" },
    @{ id = 10;  name = "10-CountListItems.java";           type = "Java";     section = "Practical" },
    @{ id = 11;  name = "11-CountCheckboxes.java";          type = "Java";     section = "Practical" },
    @{ id = 99; name = "selenium-setup-guide.md";           type = "Markdown"; section = "Setup"     },
    @{ id = 100; name = "pom.xml";                          type = "XML";      section = "Setup"     }
)

# Display: Lab Practicals
Write-Host "Lab Practicals:"
Write-Host "---------------"
foreach ($f in $labFiles | Where-Object { $_.section -eq "Practical" }) {
    Write-Host "  $($f.id). [$($f.type)] $($f.name)"
}

Write-Host ""

# Display: Helper / Setup Files
Write-Host "Helper / Setup Files:"
Write-Host "---------------------"
foreach ($f in $labFiles | Where-Object { $_.section -eq "Setup" }) {
    Write-Host "  $($f.id). [$($f.type)] $($f.name)"
}

# Show valid choices explicitly
$validIds = ($labFiles | ForEach-Object { $_.id }) -join ", "
Write-Host ""
$choice = Read-Host "Enter your choice [$validIds]"

$selected = $labFiles | Where-Object { $_.id -eq [int]$choice }

if (-not $selected) {
    Write-Host "Invalid choice! Please enter one of: $validIds"
    exit
}

# Download selected file
$fileUrl = "$repoBase/$($selected.name)"
Write-Host "`nDownloading $($selected.name)..."
try {
    Invoke-WebRequest -Uri $fileUrl -OutFile $selected.name -ErrorAction Stop
    Write-Host "✅ Download complete! File saved as: $($selected.name)"
} catch {
    Write-Host "❌ Failed to download file. Please check the repository link or filename."
}

Write-Host "`nDone!"