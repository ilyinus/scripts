SELECT TOP (1000) [_UserId]
      ,[_ObjectKey]
      ,[_SettingsKey]
      ,[_Version]
      ,[_SettingsPresentation]
      ,[_SettingsData]
  FROM [gp_work].[dbo].[_SystemSettings]
  where _UserId = 'Сергеев Вячеслав'
  and _ObjectKey like 'РегистрСведений.ИсторияИзмененийРеквизитов.Форма.ФормаСписка.Список%'

  /*  delete
  FROM [gp_work].[dbo].[_SystemSettings]
  where _UserId = 'Сергеев Вячеслав'
  and _ObjectKey like 'РегистрСведений.ИсторияИзмененийРеквизитов.Форма.ФормаСписка.Список%'
  */
