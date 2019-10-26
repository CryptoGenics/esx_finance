ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CarLoan(d, h, m)
	CreateThread(function()
		Wait(0)
		MySQL.Async.fetchAll('SELECT * FROM billing WHERE target = @target', {
			['@target'] = 'society_cardealer'
		}, function (result)
			for i=1, #result, 1 do
				local target     = 'society_cardealer'
				local xPlayer = ESX.GetPlayerFromIdentifier(result[i].identifier)
				local payment = result[i].original/100*Config.carPaymentperday

				if xPlayer then
					if Config.Negitive then
						if result[i].amount > 0 then

							xPlayer.removeAccountMoney('bank', math.floor(payment))

							TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)
								account.addMoney(math.floor(payment))
							end)

							MySQL.Sync.execute('UPDATE billing SET amount = amount - @amount WHERE id = @id',
							{
								['@amount'] = math.floor(payment),
								['@id'] = result[i].id
							})

							TriggerClientEvent('esx:showNotification', xPlayer.source, "Car Payment Made of $".. ESX.Math.GroupDigits(math.floor(result[i].original/100*Config.carPaymentperday)))
						else

							MySQL.Sync.execute('DELETE FROM billing WHERE `id` = @id',
							{
								['@id'] = result[i].id
							})

						end
					else
						local playerbank = xPlayer.getAccount('bank').money
					
						if playerbank > payment then
							if result[i].amount > 0 then

								xPlayer.removeAccountMoney('bank', math.floor(payment))

								TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)
									account.addMoney(math.floor(payment))
								end)

								MySQL.Sync.execute('UPDATE billing SET amount = amount - @amount WHERE id = @id',
								{
									['@amount'] = math.floor(payment),
									['@id'] = result[i].id
								})

								TriggerClientEvent('esx:showNotification', xPlayer.source, "Car Payment Made of $".. ESX.Math.GroupDigits(math.floor(result[i].original/100*Config.carPaymentperday)))
							else

								MySQL.Sync.execute('DELETE FROM billing WHERE `id` = @id',
								{
									['@id'] = result[i].id
								})

							end
						end
					end
				else
					if Config.Negitive then
						if result[i].amount > 0 then

							TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)
								account.addMoney(math.floor(payment))
							end)
                  
							MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier',
							{
								['@bank']       = math.floor(payment),
								['@identifier'] = result[i].identifier
							})

							MySQL.Sync.execute('UPDATE billing SET amount = amount - @amount WHERE id = @id',
							{
								['@amount']       = math.floor(payment),
								['@id'] = result[i].id
							})

						else

							MySQL.Sync.execute('DELETE FROM billing WHERE `id` = @id',
							{
								['@id'] = result[i].id
							})

						end
					else
						MySQL.Async.fetchScalar('SELECT bank FROM users WHERE identifier = @identifier', 
						{
							['@identifier'] = result[i].identifier
						}, function(userbank)

							if userbank > payment then
								if result[i].amount > 0 then

									TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)
										account.addMoney(math.floor(payment))
									end)
											
									MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier',
									{
										  ['@bank']       = math.floor(payment),
										  ['@identifier'] = result[i].identifier
									})

									MySQL.Sync.execute('UPDATE billing SET amount = amount - @amount WHERE id = @id',
									{
										['@amount']       = math.floor(payment),
										['@id'] = result[i].id
									})

								else

									MySQL.Sync.execute('DELETE FROM billing WHERE `id` = @id',
									{
										['@id'] = result[i].id
									})

								end
							end
						end)
					end
				end
			end
		end)
	end)
end

if Config.CarLoan then
	TriggerEvent('cron:runAt', Config.CarLoantime, 0, CarLoan)
end
