#Область ЗагрузкаДанных
&НаСервере
Процедура ЗагрузкаНаСервере(Адрес)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	
	Поток = ДвоичныеДанные.ОткрытьПотокДляЧтения();  
	
	СпособЧтения = "XDTO";
	
	Если СпособЧтения  = "XDTO" Тогда
		
		ЧтениеXML = Новый ЧтениеXML;   
		ЧтениеXML.ОткрытьПоток(Поток);
		ДанныеXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML); 
				
		//постояльцы
		Для Каждого ДанныеПостояльцы из ДанныеXDTO.Постояльцы.Постоялец Цикл
			Постояльцы  = Справочники.Постояльцы.СоздатьЭлемент();
			Постояльцы.Наименование = ДанныеПостояльцы.ФИО; 
			Постояльцы.Телефон = ДанныеПостояльцы.Телефон; 
			Постояльцы.АдресЭлектроннойПочты = ДанныеПостояльцы.Почта;  
			Постояльцы.Пол = ДанныеПостояльцы.Пол;
			Постояльцы.ДатаРождения = ДанныеПостояльцы.ДатаРождения;
			Постояльцы.Записать();   
		КонецЦикла; 
		//типыномеров
		Для Каждого ДанныеНомера из ДанныеXDTO.ТипыНомеров.ТипНомера Цикл      
			
			ТипыНомеров  = Справочники.ТипыНомеров.СоздатьЭлемент();
			ТипыНомеров.Наименование = ДанныеНомера.Наименование;
			ТипыНомеров.Количество = ДанныеНомера.Количество;
			ТипыНомеров.Цена = ДанныеНомера.Цена;
			ТипыНомеров.Описание = ДанныеНомера.Описание;
			ТипыНомеров.Записать(); 
			
		КонецЦикла;
		
		Для Каждого ДанныеБронь из ДанныеXDTO.Бронирования.Бронирование Цикл         
			//бронирование
			Бронирования = Документы.Бронирование.СоздатьДокумент();
			Бронирования.Дата = ДанныеБронь.Дата;
			Бронирования.Номер = ДанныеБронь.Номер;
			Бронирования.ДатаЗаезда = ДанныеБронь.ДатаЗаезда;
			Бронирования.ДатаВыезда = ДанныеБронь.ДатаВыезда; 
						
			Бронирования.ТипНомера = Справочники.ТипыНомеров.НайтиПоКоду(ДанныеБронь.ТипНомера);
							
			ПостоялецБрони = Бронирования.Постояльцы.Добавить(); 
			ПостоялецБрони.Постоялец =  Справочники.Постояльцы.НайтиПоКоду(ДанныеБронь.Постоялец);
				
			Бронирования.Записать(РежимЗаписиДокумента.Проведение); 
			
		КонецЦикла; 

		Сообщить("Данные загружены!");
	КонецЕсли; 
					
КонецПроцедуры     

&НаКлиенте
Асинх Процедура Загрузка(Команда) 
	
	ПараметрыДиалога =  Новый ПараметрыДиалогаПомещенияФайлов;
	ПараметрыДиалога.Фильтр = "Текстовый документ|*.xml;";
	Результат = Ждать ПоместитьФайлНаСерверАсинх(,,, ПараметрыДиалога);
	
	ЗагрузкаНаСервере(Результат.Адрес);

	
КонецПроцедуры
#КонецОбласти
