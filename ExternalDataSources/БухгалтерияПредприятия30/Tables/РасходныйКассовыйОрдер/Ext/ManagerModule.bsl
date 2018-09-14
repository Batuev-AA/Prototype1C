﻿
Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Год(Данные.Дата)>3999 Тогда 
		ДатаДокумента = ДобавитьМесяц(Данные.Дата,-24000); //Уберем смещение 2000
	Иначе
		ДатаДокумента = Данные.Дата; 
	КонецЕсли;	

	Представление = НСтр("ru='Выдача наличных №'") + Строка(Данные.Номер) + НСтр("ru=' от '") + Формат(ДатаДокумента, "ДФ='dd.MM.yyyy""г.""'");
	
КонецПроцедуры
