# Get Unread + Flagged For the Current User


## Getting Inbox Info (Unread Count)

Office365 Outlook > Send an HTTP Request
```json
{
	"name": "Get Basic Mailbox Info",
	"URI": "https://graph.microsoft.com/v1.0/me/mailFolders/Inbox",
	"Method": "GET",
	"Content-Type": "application/json"
}	
```

## Get Flagged Email Count

Office365 Outlook > Send an HTTP Request
```json
{
	"name": "Get Flagged Email Count",
	"URI": "https://graph.microsoft.com/v1.0/me/messages?$filter=flag/flagStatus eq 'flagged'&$count=true&$select=id",
	"Method": "GET",
	"Content-Type": "application/json"
}	
```

## Compose Pulling the Variables

Compose
```json
{
	"name": "Email Stats",
	"compose": {
		"flagged": @{body('Get_Flagged_Email_Count')?['@odata.count']},
		"unread": @{body('Get_Basic_Mailbox_Info')['unreadItemCount']}
	}
}
```


## Notification

Microsoft Teams > Post card in a chat or channel
```json

```json
{
	"poster": "Flow bot",
	"location": "Chat with Flow bot",
	"body/recipient": "@outputs('Flow_Info')?['userEmail']",
	"body/messageBody": "{\"type\":\"AdaptiveCard\",\"$schema\":\"https://adaptivecards.io/schemas/adaptive-card.json\",\"version\":\"1.5\",\"body\":[{\"type\":\"ColumnSet\",\"columns\":[{\"type\":\"Column\",\"width\":\"auto\",\"items\":[{\"type\":\"Icon\",\"name\":\"MailAlert\"}]},{\"type\":\"Column\",\"width\":\"stretch\",\"items\":[{\"type\":\"TextBlock\",\"text\":\"[@{workflow()?['tags']['flowDisplayName']}](@{concat('https://make.powerautomate.com/environments/', workflow()?['tags']['environmentName'], '/flows/', workflow()?['name'])})\",\"wrap\":true,\"size\":\"Large\",\"weight\":\"Bolder\"}],\"verticalContentAlignment\":\"Center\"}]},{\"type\":\"ColumnSet\",\"columns\":[{\"type\":\"Column\",\"width\":\"stretch\",\"items\":[{\"type\":\"TextBlock\",\"text\":\"@{outputs('Email_Stats')?['flagged']} flagged emails\",\"wrap\":true}]},{\"type\":\"Column\",\"width\":\"stretch\",\"items\":[{\"type\":\"TextBlock\",\"text\":\"@{outputs('Email_Stats')?['unread']} unread emails\",\"wrap\":true}]}]}]}"
}
```
