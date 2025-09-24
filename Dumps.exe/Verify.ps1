<#
    The-Void: Verify.ps1 - SHA512 Hash Verification
    Copyright (c) 2025 LordSodomiser
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

$ErrorActionPreference = "Stop"
try {
    $checksums = Get-Content .\CHECKSUM
    $allPassed = $true
    foreach ($line in $checksums) {
        $hash, $file = $line -split '\s+', 2
        $file = $file.Trim()
        if (Test-Path $file) {
            $computedHash = (Get-FileHash -Algorithm SHA512 $file).Hash
            if ($computedHash -eq $hash) {
                Write-Host "$file : OK" -ForegroundColor Green
            } else {
                Write-Host "$file : FAILED" -ForegroundColor Red
                $allPassed = $false
            }
        } else {
            Write-Host "$file : NOT FOUND" -ForegroundColor Red
            $allPassed = $false
        }
    }
    if ($allPassed) {
        Write-Host "All files verified successfully." -ForegroundColor Green
    } else {
        Write-Host "Verification failed for one or more files." -ForegroundColor Red
    }
} catch {
    Write-Host "Error reading CHECKSUM file or verifying hashes: $_" -ForegroundColor Red
}
