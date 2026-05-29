param( $USER )

if ( ( $USER -eq $null ) -or ( $USER -eq "" ) ) {
    throw "Required parameter 'user' missing"
}

# https://learn.microsoft.com/en-us/entra/identity/users/licensing-service-plan-reference
$LICENSE_LOOKUP = @{
    "cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46" = "Microsoft 365 Business Premium";
    "f30db892-07e9-47e9-837c-80727f46fd3d" = "Microsoft Power Automate Free";
    "24c35284-d768-4e53-84d9-b7ae73dddf69" = "Microsoft 365 Business Premium Donation";
    "7ac9fe77-66b7-4e5e-9e46-10eed1cff547" = "Dynamics 365 Team Members";
    "c5928f49-12ba-48f7-ada3-0d743a3601d5" = "Visio Plan 2";
    "639dec6b-bb19-468b-871c-c5c441c4b0cb" = "Microsoft 365 Copilot";
    "18181a46-0d4e-45cd-891e-60aabd171b4e" = "Office 365 E1";
    "1e1a282c-9c54-43a2-9310-98ef728faace" = "Dynamics 365 Sales Enterprise Edition";
    "a403ebcc-fae0-4ca2-8c8c-7a907fd6c235" = "Microsoft Fabric (Free)";
    "4cde982a-ede4-4409-9ae6-b003453c8ea6" = "Microsoft Teams Rooms Pro";
    "36a0f3b3-adb5-49ea-bf66-762134cf063a" = "Microsoft Teams Premium";
    "3f9f06f5-3c31-472c-985f-62d9c10ec167" = "Power Pages vTrial for Makers";
    "50f60901-3181-4b75-8a2c-4c8e4c1d5a72" = "Microsoft 365 F1";
    "53818b1b-4a27-454b-8896-0dba576410e6" = "Planner and Project Plan 3";
    "5b631642-bd26-49fe-bd20-1daaa972ef80" = "Microsoft Power Apps for Developer";
    "6634e0ce-1a9f-428c-a498-f84ec7b8aa2e" = "Office 365 E2";
    "6a4a1628-9b9a-424d-bed5-4118f0ede3fd" = "Dynamics 365 Business Central for IWs";
    "ea126fc5-a19e-42e2-a731-da9d437bffcf" = "Dynamics 365 Plan 1 Enterprise Edition";
    "6af4b3d6-14bb-4a2a-960c-6c902aad34f3" = "Microsoft Teams Rooms Basic";
    "aa2695c9-8d59-4800-9dc8-12e01f1735af" = "Nonprofit Portal";
    "84a661c4-e949-4bd2-a560-ed7766fcaf2b" = "Microsoft Entra ID P2";
}


$USER_ID = if ( $USER.GetType().Name -eq "String" ) { $USER } else { $USER.Id }

$licenses = Get-MgUserLicenseDetail -UserId $USER_ID;

return $licenses | % {
    if ( $LICENSE_LOOKUP[$_.SkuId] -eq $null ) { Write-Error "No matching item found for the Sku '$($_.SkuId)'" }
    return [PSCustomObject]@{
        Name = $LICENSE_LOOKUP[$_.SkuId];
        SkuId = $_.SkuId;
    }
}
