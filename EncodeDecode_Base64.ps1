<#
I need a pure PowerShell solution to encode a binary file to base 64 and to decode base64 to a binary file.

Inspired by the following Stack Overflow article:

* Encode / Decode .EXE into Base64
  `https://stackoverflow.com/questions/42592518/encode-decode-exe-into-base64`

... and the answer from bielawski (`https://stackoverflow.com/users/2121227/bielawski`):

* `https://stackoverflow.com/a/60671753`

#>

Param(
    [Parameter(Mandatory=$true)]
    [ValidateScript(
        {Test-Path -Path $_ -PathType Leaf}
    )]
    [string]
    $inFile
    ,
    [string]
    $outFile
    ,
    [Parameter(Mandatory=$true)]
    [ValidateSet( "encode", "en", "decode", "de" )]
    [string]
    $action
)

$fileExtensionDivider = "."
$folderPathDivider = "\"
$inputFile = Get-ChildItem -Path $inFile
$action = $action.Substring( 0 , 2 )

if ( Test-Path -Path $inputFile -PathType Leaf )
{
    Write-Host "Found inFile     '${infile}'. Continuing."
} else {
    Write-Error "ERROR: Unable to find 'inFile' '${inFile}'. Aborting script."
    exit 1
}
$inFileObj = Get-ChildItem -Path $inFile

if ( $outFile -and $outFile.Length -gt 0)
{
    if ( Split-Path -Path $outFile -IsAbsolute )
    {
        [string]$outputFileFolder    = $inputFile.DirectoryName

    } else {
        # https://superuser.com/questions/1660757/how-to-get-current-path-in-powershell-into-a-variable
        [string]$outputFileFolder    = $PWD.Path
    }
    # https://stackoverflow.com/a/9788998
    [string]$outputFileBaseName      = [System.IO.Path]::GetFileNameWithoutExtension( $outFile )
    [string]$outputFileExtension     = [System.IO.Path]::GetExtension( $outFile ).Replace( $fileExtensionDivider , "" )
} else {
    Write-Information "`$outFile is either null nor empty. Using 'inFile' name for 'outFile'. Continuing."
    # https://stackoverflow.com/a/9788998
    [string]$outputFileFolder        = $PWD.Path
    [string]$outputFileBaseName      = [System.IO.Path]::GetFileNameWithoutExtension( $inFile  ).Replace( "*" , "" ).Replace( "?" , "" )
    [string]$outputFileExtension     = [System.IO.Path]::GetExtension( $inFile ).Replace( "*" , "" ).Replace( "?" , "" ).Replace( $fileExtensionDivider , "" )
}


$outputFile = Join-Path -Path $outputFileFolder -ChildPath ( $outputFileBaseName + "." + $outputFileExtension )
<#
if ( Test-Path -Path $outputFile )
{
    Write-Error "`nERROR: output file '$outputFile' exists. Delete or rename this file and retry. Aborting script.`n"
    exit 2
}
Write-Information "Output file            '$outputFile' does not exist. Continuing."
#>


switch ( $action )
{
    "en" {
        #$outputFile = $outputFileFolder + $folderPathDivider + $outputFileBaseName + $fileExtensionDivider + $outputFileExtension 
        $outFileEncoded = $outputFile + ".b64"
        # New-Item -Path $outFileEncoded -ItemType File
        Write-Host "Encoding:`n from input file '$($inputFile.FullName)'`n to output file  '$outFileEncoded'."
        [IO.File]::WriteAllBytes( $outFileEncoded , [char[]][Convert]::ToBase64String([IO.File]::ReadAllBytes($inputFile.FullName)) )
        #Get-ChildItem -Path $outputFile
        Get-FileHash -Algorithm SHA384 -Path $outputFile | Format-List
        break
    }
    "de" {
        if ( $outputFileExtension -eq "b64" )
        {
            $outputFile = $outputFileFolder + $folderPathDivider + $outputFileBaseName

        } else {
            $outputFile = $outputFileFolder + $folderPathDivider + $outputFileBaseName + $fileExtensionDivider + $outputFileExtension 

        }
        $outFileDecoded = $outputFile
        # New-Item -Path $outFileDecoded -ItemType File
        Write-Host "Decoding:`n from input file '$inputFile.FullName'`n to output file  '$outFileEncoded'."
        [IO.File]::WriteAllBytes( $outFileDecoded , [Convert]::FromBase64String([char[]][IO.File]::ReadAllBytes($inputFile.FullName)) )
        #Get-ChildItem -Path $outputFile
        Get-FileHash -Algorithm SHA384 -Path $outputFile | Format-List
        break
    }
}

Write-Host "Done."
