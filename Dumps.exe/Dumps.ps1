<#
    The-Void: Dumps.ps1 - PowerShell Data Transfer
    Copyright (c) 2025 <LordSodomiser>
    Licensed under the Mozilla Public License 2.0 or a commercial license.
    See LICENSE file or https://github.com/LordSodomiser/The-Void/blob/main/LICENSE for details

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
#>

# =========================
# CONFIGURATION
# =========================
$RetryWait    = 30   # seconds between retries
$SleepTimeout = 15   # minutes restore time

# =========================
# FUNCTIONS
# =========================
Add-Type -AssemblyName System.Windows.Forms

function Show-RetryCancel {
    param($Message, $Title)
    return [System.Windows.Forms.MessageBox]::Show(
        $Message, $Title,
        [System.Windows.Forms.MessageBoxButtons]::RetryCancel,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
}

function Show-OK {
    param($Message, $Title)
    [System.Windows.Forms.MessageBox]::Show(
        $Message, $Title,
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    ) | Out-Null
}

function Get-FreeDriveLetter {
    $allLetters = [char[]](68..90)
    $usedLetters = (Get-PSDrive -PSProvider FileSystem).Name
    $free = $allLetters | Where-Object { $_ -notin $usedLetters }
    if (-not $free) {
        [System.Windows.Forms.MessageBox]::Show("No free drive letters available. Exiting.","Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
        exit 1
    }
    return $free[0]
}

function Select-UNCDriveGUI {
    # Get mapped network drives
    $networkDrives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.DisplayRoot -like "\\*" }

    # Build selection list
    $items = @()
    foreach ($drive in $networkDrives) {
        $items += "$($drive.Name): $($drive.DisplayRoot)"
    }

    # Add option for manual UNC input
    $items += "Manual UNC Path..."

    # GUI selection
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select Destination Network Drive"
    $form.Size = New-Object System.Drawing.Size(400,300)
    $form.StartPosition = "CenterScreen"

    $listbox = New-Object System.Windows.Forms.ListBox
    $listbox.Size = New-Object System.Drawing.Size(360,200)
    $listbox.Location = New-Object System.Drawing.Point(10,10)
    $listbox.SelectionMode = "One"
    $listbox.Items.AddRange($items)
    $form.Controls.Add($listbox)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(150,220)
    $okButton.Add_Click({ $form.Tag = $listbox.SelectedItem; $form.Close() })
    $form.Controls.Add($okButton)

    $form.ShowDialog() | Out-Null
    if (-not $form.Tag) { exit 1 }

    $selection = $form.Tag

    if ($selection -eq "Manual UNC Path...") {
    try {
        Add-Type -AssemblyName Microsoft.VisualBasic -ErrorAction Stop
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    } catch {
        Write-Error "Required assemblies could not be loaded. Are you in PowerShell 7 instead of 5.1?"
        exit 1
    }

    $manualUNC = [Microsoft.VisualBasic.Interaction]::InputBox(
        "Enter UNC path (e.g., \\server\share):",
        "Enter UNC Path"
    )

    if ([string]::IsNullOrWhiteSpace($manualUNC)) {
        Write-Host "No UNC path entered. Exiting..."
        exit 1
    }

    $freeLetter = Get-FreeDriveLetter
    Write-Host "Mapping ${freeLetter}: to $manualUNC..."
    cmd /c "net use ${freeLetter}: `"$manualUNC`" /persistent:no" | Out-Null

    if (-not (Test-Path "${freeLetter}:\")) {
        [System.Windows.Forms.MessageBox]::Show(
            "Cannot access $manualUNC",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
            exit 1
        }
        else {
            return "${freeLetter}:\"
        }
    }
    else {
        # Extract drive letter from mapped drive selection
        $selectedDriveLetter = ($selection -split ":")[0].Trim()
        return "${selectedDriveLetter}:\"
    }
}

function Test-DestRoot {
    param($DestRoot)
    Write-Host "Checking if destination $DestRoot is accessible..."
    return (Test-Path $DestRoot)
}

# =========================
# GUI selection + retry loop
# =========================
while ($true) {
    $DestRoot = Select-UNCDriveGUI
    if (Test-DestRoot -DestRoot $DestRoot) { break }

    $res = Show-RetryCancel "Unable to access $DestRoot.`nCheck network or server and Retry, or Cancel." "Destination Error"
    if ($res -eq [System.Windows.Forms.DialogResult]::Cancel) { exit 1 }
    Start-Sleep -Seconds $RetryWait
}

# =========================
# Prevent sleep
# =========================
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0

# =========================
# Desktop path + logs
# =========================
$DesktopPath = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders").Desktop
if (-not $DesktopPath) { $DesktopPath = [Environment]::GetFolderPath("Desktop") }
$LogDir = Join-Path $DesktopPath "Dump Logs"
if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }

# =========================
# Timestamp
# =========================
$DateStamp = Get-Date -Format "yyyy-MM-dd_HHmm"

# =========================
# Loop through removable drives
# =========================
Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 } | ForEach-Object {
    $Drive = $_.DeviceID

    Get-ChildItem -Path "${Drive}\" -Directory | ForEach-Object {
        $SourceFolder = $_.FullName
        $FolderName = $_.Name

        Write-Host "=========================================="
        Write-Host "Starting copy from $FolderName from $Drive"
        Write-Host "=========================================="

        $Dest = Join-Path $DestRoot ("$FolderName" + "_$DateStamp")
        if (-not (Test-Path $Dest)) { New-Item -ItemType Directory -Path $Dest | Out-Null }

        $LogFile = Join-Path $LogDir ("$FolderName" + "_$DateStamp" + "_robocopy.log")

        robocopy "$SourceFolder" "$Dest" /E /Z /R:3 /W:$RetryWait /FFT /COPY:DT /NP /TEE /LOG:"$LogFile" /XD "System Volume Information" /XA:H /XA:S

        Get-ChildItem "$Dest" -Recurse | ForEach-Object { $_.Attributes = 'Normal' }

        Write-Host "Finished copying $FolderName to $Dest"
    }
}

# =========================
# Restore sleep after 15 mins
# =========================
Start-Sleep -Seconds ($SleepTimeout * 60)
powercfg -change -standby-timeout-ac ($SleepTimeout)
powercfg -change -standby-timeout-dc ($SleepTimeout)

# =========================
# Done message
# =========================
Show-OK "All phone dumps copied successfully.`nLogs in Desktop\Phone Dump Logs." "Copy Complete"
