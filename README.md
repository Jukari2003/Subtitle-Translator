# Subtitle-Translator
Subtitle Translator

    Usage Instructions:
        - Download Subtitle-Translator.zip from GitHub
            - Top Right Hand Corner Click "Code"
            - Select "Download Zip"
        - Extract Files to a desired location
        - Right Click on Subtitle-Translator.ps1
        - Click "Edit"     (This should open up Reddit Downloader in Powershell ISE)
        - Powershell ISE Should open
          - Modify the 3 variables at the top to your desired input,output, and language code
        - Click the Green Play Arrow.
        - Success!

---------------------------------

    Possible Errors:
        - Execution-Policy 
            - Some systems may prevent you from executing the script even in PowerShell ISE.
                -   On a Home Computer: Run PowerShell ISE or PowerShell as an administrator
                    - Type the command:
                         -  Set-ExecutionPolicy Unrestricted
                    - Type 
                        -  Y
  
        - You're on a MAC
            - You will need to install PowerShell for MAC
                - https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7.1
