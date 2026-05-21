Write-Host "Downloading the AL Language compiler"
./.vscode/LoadALLanguage.ps1;

Write-Host "Creating AL Project for debugging"
$Path = (Get-Item $PSScriptRoot -force).parent.parent

New-Item -ItemType Directory -Force "$Path/AlDebugProject" | Out-Null
New-Item -ItemType Directory -Force "$Path/AlDebugProject/.vscode" | Out-Null

Set-Content "$Path/AlDebugProject/app.json" -Encoding UTF8 @'
{
  "id": "d700542d-5688-4e64-aecb-648fa385a652",
  "name": "ALProject1",
  "publisher": "Default Publisher",
  "version": "1.0.0.0"
}
'@

Set-Content "$Path/AlDebugProject/test.al" -Encoding UTF8 @'
table 1 MyTable
{
    fields
    {
        field(1; MyField; Integer) { }
        field(2; MyField2; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(MyTable.MyField);
        }
    }
}
'@

$dllPath = "$(((Get-Item $PSScriptRoot -force).parent))/bin/Debug/netstandard2.1/PDWCodeCop.dll"
Set-Content "$Path/AlDebugProject/.vscode/settings.json" -Encoding UTF8 @"
{
    "al.codeAnalyzers": [
        "$dllPath"
    ],
    "al.enableCodeAnalysis": true,
    "al.compilationOptions": {
            "maxDegreeOfParallelism": 1,
            "parallel": false
        }
}
"@