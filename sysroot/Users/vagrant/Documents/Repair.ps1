[CmdletBinding(SupportsShouldProcess)]
Param (
    [Parameter(Mandatory)]
    [ValidateSet("soneta/server.standard", "soneta/server.premium", "soneta/web.standard", "soneta/web.premium")]
    $name,
    [Parameter(Mandatory)]
    $tag,
    $registry = "http://megiddo2:5000"
)

function deleteFromRegistry
{
    Param(
        [Parameter(Mandatory)]
        $uri
    )

    if ($PSCmdlet.ShouldProcess($uri))
    {
        Invoke-WebRequest -UseBasicParsing -Method delete -Uri $uri
    }
}

function garbageCollect
{
    Param(
        $container = "soneta-registry"
    )

    if ($PSCmdlet.ShouldProcess($container))
    {
        docker exec $container registry.exe garbage-collect /config/config.yml
    }
}

function restartContainer
{
    Param(
        $container = "soneta-registry"
    )

    if ($PSCmdlet.ShouldProcess($container))
    {
        docker restart $container
    }
}

function push
{
    Param(
        [Parameter(Mandatory)]
        $fqin
    )

    if ($PSCmdlet.ShouldProcess($fqin))
    {
        docker push $fqin
    }
}



$image = (docker image ls --format '{{.Repository}},{{.Tag}}' | ConvertFrom-Csv -Header Name, Tag | ? Name -like "*$name" | ? Tag -eq $tag)

if ($image)
{
    $digest = (Invoke-WebRequest -UseBasicParsing -Uri $registry/v2/$name/manifests/$tag `
        -Headers @{ Accept = 'application/vnd.docker.distribution.manifest.v2+json' } |
        Select-Object -ExpandProperty Headers)['Docker-Content-Digest']

    if ($digest)
    {
        deleteFromRegistry $registry/v2/$name/manifests/$digest
    
        garbageCollect "soneta-registry"

        restartContainer "soneta-registry"
        
        push "megiddo2:5000/$($name):$($tag)"
    }
    else
    {
        Write-Warning "Image $name tagged with $tag is not pushed."
        exit 2        
    }
}
else
{
    Write-Warning "Image $name tagged with $tag not exists."
    exit 1
}