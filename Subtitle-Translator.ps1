clear-host
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Set-Location $dir

#WARNING MAKE SURE OUTPUT DIRECTORY IS EMPTY, IT WILL OVERWRITE ANY FILES IN IT!

$script:target_dir = "Z:\Portal Subtitle Folder"
$script:output_dir = "C:\TEST"
$script:target_language = "en"

################################################################################
######Translate Text############################################################
function translate_text($text)
{
    $Translation = New-Object System.Collections.Generic.List[System.Object]

    $Uri = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$($script:target_language)&dt=t&q=$text"
    $RawResponse = (Invoke-WebRequest -Uri $Uri -Method Get).Content
    $CleanResponse = $RawResponse -split '\\r\\n' -replace '^(","?)|(null.*?\[")|\[{3}"' -split '","'
    $LineNumber = 0
    foreach ($Line in $CleanResponse) 
    {
        $LineNumber++
        if($LineNumber%2) 
        {
            $Translation.Add($Line)
        }
    }
    return $Translation
}


################################################################################
######Main######################################################################
function main
{

    $files = Get-ChildItem -LiteralPath $script:target_dir -File -ErrorAction SilentlyContinue | where {$_.extension -in ".srt"}

    foreach($file in $files)
    {
        $output_file =$script:output_dir + "\" + $file.BaseName + $file.extension
        if(Test-Path -LiteralPath $output_file)
        {
            Remove-Item $output_file
        }
        $writer = [System.IO.StreamWriter]::new($output_file)


        $srt_file = Get-Content -literalpath $file.FullName
        $count = 0;
        foreach($line in $srt_file)
        {
            $count++
            if(($line -ne "") -and (!($line -match "^\d+")))
            {
                
                write-host -----------------------------
                write-host $line
                $new_text = translate_text $line
                $new_text = "$new_text"
                $scraps = ("tea_AllEn","de_en_","Du sagd","es_en_","`",da","`",1","fr_en_",",1e") #Scrub Google Translate nonsense
                foreach($scrap in $scraps)
                {
                    if($new_text -match "$scrap")
                    {
                        $index = $new_text.IndexOf("$scrap")
                        $new_text = $new_text.Substring(0, $index)
                    }
                }
                $new_text = $new_text -replace "\\h|\\h|\\",""
                $new_text = $new_text -replace '\"','"'
                $new_text = $new_text.Trim()
                $new_text = $new_text.Trim("-")
                $new_text = $new_text.Trim()
                $writer.WriteLine("$new_text")
                write-host $new_text
            }
            else
            {
                $writer.WriteLine($line)
            }
            if($count -eq 30)
            {
               #break;
            }
        }
        $writer.close()
    }
}
################################################################################
################################################################################
main