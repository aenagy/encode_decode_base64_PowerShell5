# encode_decode_base64_PowerShell5

## Introduction

I need a pure PowerShell solution to encode a binary file to base 64 and to decode base64 to a binary file.

Inspired by the following Stack Overflow article:

* Encode / Decode .EXE into Base64
  `https://stackoverflow.com/questions/42592518/encode-decode-exe-into-base64`

... and the answer from bielawski (`https://stackoverflow.com/users/2121227/bielawski`):

* `https://stackoverflow.com/a/60671753`


## Usage

This PowerShell script was created and tested with version 5.1 on Windows 10. This version of PowerShell was chosen as some environments don't allow users to install/upgrade to PowerShell 7+.

If/when/maybe I have time I will test on other platforms such as Ubuntu.

## Execution

These examples asume the above PowerShell session. Note that the script requires that the output file does NOT exist.

The 'action' parameter will accpent "en" or "encode" for base64 encoding and "de" or "decode" for base64 decoding.

### Encode a binary file to base64 text file.

If the output file is not specified then it is the same as the input file name with ".b64" appended as the new extension.

`.\EncodeDecode_Base64.ps1 -inFile .\testfile.zip -action en`

### Encode a binary file to base64 text file specified by user.

`.\EncodeDecode_Base64.ps1 -inFile .\testfile.zip -action en -outFile foobar`

### Decode a base64 text file to binary file.

`.\EncodeDecode_Base64.ps1 -inFile .\foobar..b64 -outFile barfoo.zip -action decode`


## Alternate solution for small-ish files

Use the Windows built-in utility 'certutil'.

`Get-Content -Path textfile??.txt | Out-File -FilePath foobar.txt -Append`

## Author

Andrew Nagy

https://www.linkedin.com/in/andrew-e-nagy/
