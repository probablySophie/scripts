
# Microsoft's Adaptive Cards


### Templates

[List Counter](./templates/ListCounter.json)  
![](./templates/ListCounter.png)  


[Loading](./templates/Loading.json) a super basic card that can be updated later  

[Weather](./templates/weather.json) nicely formats the results from an MSN Weather `Get forecast for today`  
Wants the variable: 'Timezone'

### Snippets

[Flow Name With Badge](./snippets/TitleWithBadge.json)  
Its probably good to replace the whole button with a variable  

[Runtime Info](./snippets/RuntimeInfo.json)  
Wants the compose `Flow Info` to exist with the contents of `FlowInfo.json`  
![](./snippets/RuntimeInfo.png)  

[Run info button](./snippets/RunInfoButton.json) - A button to show more about the current run  
Will need `#InfoContainer`'s `items: []` replaced


### Elements

1. Make a new Compose element.  
2. Call it `Flow Info`
3. Paste in the contents of (`FlowInfo.json`)[./elements/FlowInfo.json]
4. Set the `"timezone"` variable to [your current timezone](https://learn.microsoft.com/en-us/dotnet/api/microsoft.azure.management.monitor.models.timewindow.timezone?view=azure-dotnet-legacy")
