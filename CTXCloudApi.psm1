#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname

    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename


