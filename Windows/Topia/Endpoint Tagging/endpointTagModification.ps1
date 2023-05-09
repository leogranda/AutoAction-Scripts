#set endpointtag key value pairs 
function set-endpointtags ($tags)
{

    $config_file = "C:\Program Files\Vicarius\Topia\Topia.exe.config"
    if (Test-Path $config_file)
    {
        [xml]$xmlDoc = Get-Content $config_file 
        $tag = $xmlDoc.configuration.appSettings.ChildNodes | ?{$_.key -eq "EndpointTag"}
        $tag.value = $tags
        $xmlDoc.Save($config_file)
        Write-Host "Endpoint tags were added"
	  Write-Host $tags        
    }
    else
    {
        Write-Error "No Topia config path found"
    }
}




$tags = ""
foreach ($arg in $args)

    
{
    
    #Input validation

    if ($arg.Contains(';') -or $arg.Contains(')') -or $arg.Contains('(') -or $arg.Contains('}') -or $arg.Contains('{') -or $arg.Contains('[') -or $arg.Contains(']')  ) { 
    Write-Host "Failed to add endpoint tags - Special characters are not valid [';'  '('    ')'  '{'  '}'  '['  ']'] 
Use space or comma to enter more than one tag  - example: key1:value1 key2:value2 OR key1:value1,key2:value2
Use '_' to separate values within the same tag - example: key:value1_value2"
    exit} 

    #Tags writing

    if ( $tags -ne "")
    {
        $tags = $tags + "," + $arg
        
        
    }
    else
    {
        $tags = $arg
        
        
    }
}
    
set-endpointtags $tags
Restart-Service topia -Force
