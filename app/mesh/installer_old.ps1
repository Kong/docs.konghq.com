# Copyright 2021 Kong Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Kept for older releases of Kong-Mesh before we moved in 2.2.0 to the new package location

$Arch             = If ($Arch) {$Arch} Else {"amd64"}
$ProductName      = If ($ProductName) {$ProductName} Else {"Kuma"}
$LatestVersionUrl = If ($LatestVersionUrl) {$LatestVersionUrl} Else {"https://docs.konghq.com/mesh/latest_version/"}
$Version          = If ($Version) {$Version} Else {(Invoke-WebRequest -Uri $LatestVersionUrl).Content.Trim()}
$RepoPrefix       = If ($RepoPrefix) {$RepoPrefix} Else {"kong-mesh"}
$Distro           = If ($Distro) {$Distro} Else {"windows"}
$ArchiveName      = "$RepoPrefix-$Version-$Distro-$Arch.tar.gz"
$Pwd              = (Get-Item .).FullName
$Url              = "https://download.konghq.com/mesh-alpine/$ArchiveName"
$ArchivePath      = "${Pwd}\$ArchiveName"
$UnarchivePath    = "${Pwd}\$RepoPrefix-$Version"

Write-Host ""
Write-Host "Welcome to the $ProductName automated download!"

([PSCustomObject]@{
    "$ProductName Version" = $Version
    "Architecture"         = $Arch
    "Operating System"     = $Distro
    "Downloading From"     = $Url
    "Downloading To"       = $ArchivePath
} | Format-List | Out-String).Trim()

Write-Host ""
Write-Host "Downloading $Url"

Try {
    Invoke-WebRequest -Uri $Url -OutFile $ArchivePath
    tar xzf $ArchivePath
    Write-Host "$ProductName $Version has been downloaded`r`n"
    Get-Content -Path "${UnarchivePath}\README" -Encoding utf8
    Write-Host ""
} Catch {
    Write-Error "Unable to download $ProductName $Version from ${Url}: $_.Exception.Message"
    Return
}
