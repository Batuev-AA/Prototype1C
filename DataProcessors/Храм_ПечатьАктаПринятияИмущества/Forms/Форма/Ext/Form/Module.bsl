﻿
&НаСервере
Функция ПечатьАктаПринятияИмуществаНаСервере()

	
	Если не ЗначениеЗаполнено(Объект.СсылкаНаОбъект) Тогда
		возврат Неопределено;
	КонецЕсли;
	
	
	ДокОбъект =  Объект.СсылкаНаОбъект;
	
	
	ОбъектыПечати = новый СписокЗначений;
	ОбъектыПечати.Добавить(ДокОбъект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры макета по умолчанию
	ТабДокумент.РазмерКолонтитулаСверху = 0;
	ТабДокумент.РазмерКолонтитулаСнизу  = 0;
	ТабДокумент.АвтоМасштаб             = Истина;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;
	ТабДокумент.ИмяПараметровПечати     = "ПАРАМЕТРЫ_ПЕЧАТИ_Храм_Храм_АктПринятияИмущества";
	
	ПечатьТорговыхДокументов.УстановитьМинимальныеПоляПечати(ТабДокумент);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.Храм_ПечатьАктаПринятияИмущества.ПФ_MXL_Храм_АктПринятияИмущества");
	
	
	// Запомним номер строки, с которой начали выводить текущий документ.
	НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
	
	// Получаем области макета для вывода в табличный документ.
	ШапкаДокумента   = Макет.ПолучитьОбласть("Шапка");
	//ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	//СтрокаТаблицы    = Макет.ПолучитьОбласть("СтрокаТаблицы");
	//ТелоОтчета    = Макет.ПолучитьОбласть("ТелоОтчета");
	Подвал  = Макет.ПолучитьОбласть("Подвал");
	
	//ОборотШапка   = Макет.ПолучитьОбласть("ОборотШапка");
	ОборотЗаголовокТаблицы   = Макет.ПолучитьОбласть("ОборотЗаголовокТаблицы");
	ОборотСтрокиТаблицы   = Макет.ПолучитьОбласть("ОборотСтрокиТаблицы");
	ОборотИтоги   = Макет.ПолучитьОбласть("ОборотИтоги");
	
	
	
	
	// Выведем шапку документа.
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ДокОбъект.Организация, ДокОбъект.Дата);
	
	СтруктураШапки = Новый Структура;
	СтруктураШапки.Вставить("Организация",   ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм"));
	СтруктураШапки.Вставить("АдресОрганизации",   ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "ФактическийАдрес"));
	СтруктураШапки.Вставить("ТелефонОрганизации",   ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "Телефоны"));
	СтруктураШапки.Вставить("НомерДокумента", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДокОбъект.Номер, Истина, Ложь));
	СтруктураШапки.Вставить("ДатаДокумента",  Формат(ДокОбъект.Дата, "ДЛФ=ДД"));
	
	
	СтруктураШапки.Вставить("НачПериода", Формат(ДокОбъект.Дата,"ДЛФ=ДД" ));
	СтруктураШапки.Вставить("КонПериода", Формат(ДокОбъект.Дата,"ДЛФ=ДД" ));
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ПредседательКомиссии КАК ПредседательКомиссии,
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ЧленКомиссии1 КАК ЧленКомиссии1,
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ЧленКомиссии2 КАК ЧленКомиссии2
	|ИЗ
	|	РегистрСведений.Храм_ИнвентаризационнаяКомиссия.СрезПоследних(&Период, Организация = &Организация) КАК Храм_ИнвентаризационнаяКомиссияСрезПоследних";
	
	Запрос.УстановитьПараметр("Период",ДокОбъект.Дата );
	Запрос.УстановитьПараметр("Организация",ДокОбъект.Организация );
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СтруктураШапки.Вставить("ПредседательКомиссии",   Выборка.ПредседательКомиссии);
		СтруктураШапки.Вставить("ЧленКомиссии1", Выборка.ЧленКомиссии1);
		СтруктураШапки.Вставить("ЧленКомиссии2",  Выборка.ЧленКомиссии2);
		
		
	КонецЕсли;;
	
	
	
	
	ШапкаДокумента.Параметры.Заполнить(СтруктураШапки);
	ТабДокумент.Вывести(ШапкаДокумента);
	
	
	///////////////////		
	ТабДокумент.Вывести(ОборотЗаголовокТаблицы);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ОприходованиеТоваровТовары.Номенклатура КАК Номенклатура,
	               |	ОприходованиеТоваровТовары.Количество КАК Количество,
	               |	ОприходованиеТоваровТовары.Цена КАК Цена,
	               |	ОприходованиеТоваровТовары.Сумма КАК Сумма
	               |ИЗ
	               |	Документ.ОприходованиеТоваров.Товары КАК ОприходованиеТоваровТовары
	               |ГДЕ
	               |	ОприходованиеТоваровТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",ДокОбъект);

	
	
	Результат1 = Запрос.Выполнить();
	Выборка1 = Результат1.Выбрать();
	СтруктураОборотСтроки = Новый Структура;
	
	Остаток = 0;
	КолвоОстаток = 0;
	Номер = 0;
	Пока Выборка1.Следующий() Цикл
		Номер = Номер +1;
		
		СтруктураОборотСтроки.Вставить("Номер", Номер);
		СтруктураОборотСтроки.Вставить("Номенклатура", Выборка1.Номенклатура);
		СтруктураОборотСтроки.Вставить("Количество", Выборка1.Количество);
		СтруктураОборотСтроки.Вставить("Сумма", Выборка1.Сумма);
		СтруктураОборотСтроки.Вставить("Цена", Выборка1.Цена);
			
		Остаток = Остаток + Выборка1.Сумма;
		КолвоОстаток = КолвоОстаток + Выборка1.Количество;
		
		
		ОборотСтрокиТаблицы.Параметры.Заполнить(СтруктураОборотСтроки);
		ТабДокумент.Вывести(ОборотСтрокиТаблицы);
		
	КонецЦикла;
	
	
	//	Итого = 0;
	//	ВыборкаСОПВ= Выборка.СведенияОПеречисленияхВзносов.Выбрать();
	//	Пока ВыборкаСОПВ.Следующий() Цикл
	//			СтруктураОборотСтроки.Вставить("НазваниеДокумента", ВыборкаСОПВ.НазваниеДокумента);
	//			СтруктураОборотСтроки.Вставить("НомерДокумента", ВыборкаСОПВ.НомерДокумента);
	//			СтруктураОборотСтроки.Вставить("ДатаДокумента", формат(ВыборкаСОПВ.ДатаДокумента,"ДЛФ=Д"));
	//			СтруктураОборотСтроки.Вставить("СуммаДокумента", ВыборкаСОПВ.СуммаДокумента);
	//	        ОборотСтрокиТаблицы.Параметры.Заполнить(СтруктураОборотСтроки);
	//			ТабДокумент.Вывести(ОборотСтрокиТаблицы);
	//			Итого = Итого + ВыборкаСОПВ.СуммаДокумента;
	//
	//	КонецЦикла;
	//	
	СтруктураОборотИтоги = Новый Структура;
	СтруктураОборотИтоги.Вставить("Остаток", Остаток);
	СтруктураОборотИтоги.Вставить("КолвоОстаток", КолвоОстаток);
	
		СтруктураОборотИтоги.Вставить("СуммаПрописью", ЧислоПрописью(Остаток, "Л = ru_RU; ДП = Истина", "рубль,рубля,рублей,м,коп.,коп.,коп.,ж,2"));
	
	
	
	
	
	
	
	ОборотИтоги.Параметры.Заполнить(СтруктураОборотИтоги);
	ТабДокумент.Вывести(ОборотИтоги);
	
	
	
	
	
	//		
	//	// Выведем подвал документа.
	СтруктураПодвала = Новый Структура;
	//	СтруктураПодвала.Вставить("Настоятель",  Выборка.Настоятель);
	//СтруктураПодвала.Вставить("ПредседательПриходскогоСовета",    Выборка.ПредседательПриходскогоСовета);
	//СтруктураПодвала.Вставить("Казначей",  Выборка.Казначей);
	//	
	Подвал.Параметры.Заполнить(СтруктураПодвала);
	//	
	ТабДокумент.Вывести(Подвал);
	//	
	//	
	//	// Выведем разрыв страницы.
	//	ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	//	
	//	
	//	ТабДокумент.Вывести(ОборотШапка);
	//	
	//	ТабДокумент.Вывести(ОборотЗаголовокТаблицы);
	//	
	//	
	//	СтруктураОборотСтроки = Новый Структура;
	
	//	Итого = 0;
	//	ВыборкаСОПВ= Выборка.СведенияОПеречисленияхВзносов.Выбрать();
	//	Пока ВыборкаСОПВ.Следующий() Цикл
	//			СтруктураОборотСтроки.Вставить("НазваниеДокумента", ВыборкаСОПВ.НазваниеДокумента);
	//			СтруктураОборотСтроки.Вставить("НомерДокумента", ВыборкаСОПВ.НомерДокумента);
	//			СтруктураОборотСтроки.Вставить("ДатаДокумента", формат(ВыборкаСОПВ.ДатаДокумента,"ДЛФ=Д"));
	//			СтруктураОборотСтроки.Вставить("СуммаДокумента", ВыборкаСОПВ.СуммаДокумента);
	//	        ОборотСтрокиТаблицы.Параметры.Заполнить(СтруктураОборотСтроки);
	//			ТабДокумент.Вывести(ОборотСтрокиТаблицы);
	//			Итого = Итого + ВыборкаСОПВ.СуммаДокумента;
	//
	//	КонецЦикла;
	//	
	//	СтруктураОборотИтоги = Новый Структура;
	//	СтруктураОборотИтоги.Вставить("СуммаИтого", Итого);
	//	ОборотИтоги.Параметры.Заполнить(СтруктураОборотИтоги);
	//	ТабДокумент.Вывести(ОборотИтоги);
	//			
	
	// В табличном документе зададим имя области, в которую был 
	// выведен объект. Нужно для возможности печати покомплектно.
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
	НомерСтрокиНачало, ОбъектыПечати, ДокОбъект.Ссылка);
	
	
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	//ТабДокумент.ОтображатьСетку = Ложь;
	Возврат ТабДокумент;
	
	
КонецФункции




&НаКлиенте
Процедура ПечатьАктаПринятияИмущества(Команда)
	ТабДокумент = ПечатьАктаПринятияИмуществаНаСервере();
	
	если ТабДокумент<>Неопределено Тогда
		ТабДокумент.ТолькоПросмотр = Истина;
		
		ТабДокумент.Показать();
	КонецЕсли;

КонецПроцедуры
