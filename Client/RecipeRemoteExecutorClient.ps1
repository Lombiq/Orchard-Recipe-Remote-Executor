param
(
    [Parameter(Mandatory = $true, HelpMessage = "The URL where the recipes will be posted. The URL pattern is https://mywebsite.com/api/Lombiq.Hosting.RecipeRemoteExecutor/Recipes/Batch, but you only need to define mywebsite.com.")]
    [string] $HostName = $(throw "You need to specify the host where the recipes will be executed."),

    [Parameter(Mandatory = $true, HelpMessage = "The name of the user to authenticate. Make sure that the user is in a role that is permitted to run recipes remotely.")]
    [string] $UserName = $(throw "You need to specify the username."),

    [Parameter(Mandatory = $true, HelpMessage = "The password of the user.")]
    [string] $Password = $(throw "You need to specify the password."),

    [Parameter(Mandatory = $true, HelpMessage = "The list of the recipe data that will be sent to the server. Make sure that this object is a list and each element has a RecipeText and TenantName property.")]
    [array] $CompositeRecipeData = $(throw "You need to specify the recipes.")
)

try
{
    $url = "https://$HostName/api/Lombiq.Hosting.RecipeRemoteExecutor/Recipes/Batch"
    $authentication = "Basic " + [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($UserName + ":" + $Password))
    $jsonRecipes = ConvertTo-Json($CompositeRecipeData)

    $payLoad = [System.Text.Encoding]::UTF8.GetBytes($jsonRecipes)

    $webRequest = [System.Net.WebRequest]::Create($url)
    $webRequest.Headers.Add("AUTHORIZATION", $authentication);
    $webRequest.ContentType = "application/json"
    $webRequest.ContentLength = $payLoad.Length
    $webRequest.Method = "POST"

    $requestStream = $webRequest.GetRequestStream()
    $requestStream.Write($payLoad, 0, $payLoad.length)
    $requestStream.Close()

    [System.Net.WebResponse] $webResponse = $webRequest.GetResponse()
    $responseStream = $webResponse.GetResponseStream()
    $streamReader = New-Object System.IO.StreamReader -ArgumentList $responseStream
    [string] $results = $streamReader.ReadToEnd()

    Write-Host $results
}
catch
{
    Write-Host ("`n*****`nERROR WHILE EXECUTING THE RECIPES!`n*****`n")
    exit 1
}

exit 0