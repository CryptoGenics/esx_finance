# esx_finance

  This modification will make it so any outstanding bill from society_cardealer will be paid at a % based on the original billing amount once per IRL day. 
  
example: config is set to 10% - Billed someone for 100k as a cardealer - Person will pay $10k every IRL day for 10 days automatically
    
You can easily modify this script to add multiple businesses that giveout loans besides cardealers

___

# Installation
1. Clone this repository.
2. Extract the zip.
3. Change esx_finance-master to esx_finance
3. Put esx_finance to your resource folder.
4. Add "start esx_finance" in your "server.cfg".


# Setting up esx_billing for Financing (REQUIRED)

1. Go into esx_billing / server / main.lua
2. find the following lines
```
if xTarget ~= nil then
	MySQL.Async.execute(
		'INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
		{
			['@identifier']  = xTarget.identifier,
			['@sender']      = xPlayer.identifier,
			['@target_type'] = 'society',
			['@target']      = sharedAccountName,
			['@label']       = label,
			['@amount']      = amount
		},
		function(rowsChanged)
			TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_invoice'))
		end
	)
end
```
3. Replace with this (adding originial)
```			
if xTarget ~= nil then
	MySQL.Async.execute(
		'INSERT INTO billing (identifier, sender, target_type, target, label, amount, original) VALUES (@identifier, @sender, @target_type, @target, @label, @amount, @original)',
		{
			['@identifier']  = xTarget.identifier,
			['@sender']      = xPlayer.identifier,
			['@target_type'] = 'society',
			['@target']      = sharedAccountName,
			['@label']       = label,
			['@amount']      = amount,
			['@original']	 = amount
		},
		function(rowsChanged)
			TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_invoice'))
		end
	)
end
```
4. Last add "original" to your billing table
```
ALTER TABLE `billing` ADD `original` INT(11) NOT NULL ;
```

# Required resource
- es_extended
- Async
- Cron

# Made by
- CryptoGenics
- Based off esx_property rent cron job


