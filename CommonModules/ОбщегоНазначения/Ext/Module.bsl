﻿
Процедура УстановитьМинимальныеПоляПечати(ТабличныйДокумент) Экспорт
	СисИнфо = Новый СистемнаяИнформация;
	ЗначениеБоковогоПоля = ?(ПустаяСтрока(СисИнфо.ИнформацияПрограммыПросмотра), 5, 10); 
	
	Если ТабличныйДокумент.ПолеСлева < ЗначениеБоковогоПоля Тогда
		ТабличныйДокумент.ПолеСлева = ЗначениеБоковогоПоля;
	КонецЕсли; 
	
	Если ТабличныйДокумент.ПолеСправа < ЗначениеБоковогоПоля Тогда
		ТабличныйДокумент.ПолеСправа = ЗначениеБоковогоПоля;
	КонецЕсли;
	
	Если ТабличныйДокумент.ПолеСверху < 5 Тогда
		ТабличныйДокумент.ПолеСверху = 5;
	КонецЕсли; 

	Если ТабличныйДокумент.ПолеСнизу < 5 Тогда
		ТабличныйДокумент.ПолеСнизу = 5;
	КонецЕсли;

КонецПроцедуры

Функция МакетПечатнойФормы(ПутьКМакету) Экспорт
	//УправлениеПечатью.МакетПечатнойФормы();
КонецФункции

Процедура ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка) Экспорт
	Элемент = ОбъектыПечати.НайтиПоЗначению(Ссылка);
	Если Элемент = Неопределено Тогда
		ИмяОбласти = "Документ_" + Формат(ОбъектыПечати.Количество() + 1, "ЧН=; ЧГ=");
		ОбъектыПечати.Добавить(Ссылка, ИмяОбласти);
	Иначе
		ИмяОбласти = Элемент.Представление;
	КонецЕсли;
	
	НомерСтрокиОкончание = ТабличныйДокумент.ВысотаТаблицы;
	ТабличныйДокумент.Область(НомерСтрокиНачало, , НомерСтрокиОкончание, ).Имя = ИмяОбласти;
КонецПроцедуры

Функция НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета) Экспорт
	//УправлениеПечатью.НужноПечататьМакет();
КонецФункции	

Процедура ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета, СинонимМакета, ТабличныйДокумент,
	Картинка = Неопределено, ПолныйПутьКМакету = "", ИмяФайлаПечатнойФормы = Неопределено) Экспорт
	//УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию();
КонецПроцедуры	

Функция СведенияОЮрФизЛице(Компания, Период = '00010101', Знач БанковскийСчет = Неопределено, ПлатежВБюджет = Ложь) Экспорт
	
	//Реквизиты = Новый Структура();
	//Реквизиты.Вставить("НаименованиеДляПечатныхФорм",        "");
	//Реквизиты.Вставить("ФактическийАдрес",                   ""); 
	//
	//Если ЗначениеЗаполнено(Период) Тогда
	//	Запрос = Новый Запрос();
	//	Запрос.Параметры.Вставить("Организация", Компания);
	//	Запрос.Параметры.Вставить("ДатаСведений", Период);
	//	Запрос.Текст =
	//	"ВЫБРАТЬ
	//	|	МАКСИМУМ(ИсторияНаименованийОрганизаций.Период) КАК Период,
	//	|	ИсторияНаименованийОрганизаций.Ссылка КАК Ссылка
	//	|ПОМЕСТИТЬ ЗначенияНаименований
	//	|ИЗ
	//	|	ВнешнийИсточникДанных.БухгалтерияПредприятия30.Таблица.ОрганизацииИсторияНаименований КАК ИсторияНаименованийОрганизаций
	//	|ГДЕ
	//	|	ИсторияНаименованийОрганизаций.Ссылка = &Организация
	//	|	И ИсторияНаименованийОрганизаций.Период <= &ДатаСведений
	//	|
	//	|СГРУППИРОВАТЬ ПО
	//	|	ИсторияНаименованийОрганизаций.Ссылка
	//	|;
	//	|
	//	|////////////////////////////////////////////////////////////////////////////////
	//	|ВЫБРАТЬ
	//	|	ИсторияНаименованийОрганизаций.НаименованиеПолное КАК НаименованиеПолное
	//	|ИЗ
	//	|	ЗначенияНаименований КАК ЗначенияНаименований
	//	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВнешнийИсточникДанных.БухгалтерияПредприятия30.Таблица.ОрганизацииИсторияНаименований КАК ИсторияНаименованийОрганизаций
	//	|		ПО ЗначенияНаименований.Ссылка = ИсторияНаименованийОрганизаций.Ссылка
	//	|			И ЗначенияНаименований.Период = ИсторияНаименованийОрганизаций.Период";
	//	
	//	Выборка = Запрос.Выполнить().Выбрать();
	//	Если Выборка.Следующий() Тогда
	//		НаименованияОрганизации.СокращенноеНаименование     = Выборка.НаименованиеСокращенное;
	//		НаименованияОрганизации.ПолноеНаименование          = Выборка.НаименованиеПолное;
	//		НаименованияОрганизации.НаименованиеДляПечатныхФорм = ?(Выборка.ВариантНаименованияДляПечатныхФорм = Перечисления.ВариантыНаименованияДляПечатныхФорм.ПолноеНаименование,
	//																	Выборка.НаименованиеПолное, Выборка.НаименованиеСокращенное);
	//		НаименованияОрганизации.ФИО.Фамилия  = Выборка.ФамилияИП;
	//		НаименованияОрганизации.ФИО.Имя      = Выборка.ИмяИП;
	//		НаименованияОрганизации.ФИО.Отчество = Выборка.ОтчествоИП;
	//		НаименованияОрганизации.ФИО.Представление = СокрЛП(СокрЛП(Выборка.ФамилияИП) + " " + СокрЛП(Выборка.ИмяИП) + " " + СокрЛП(Выборка.ОтчествоИП));
	//		Возврат НаименованияОрганизации;
	//	КонецЕсли;
	//КонецЕсли;

	//Реквизиты = НовыйРеквизитыКомпании();
	//
	//Если Не ЗначениеЗаполнено(Компания) Тогда
	//	Возврат Реквизиты;
	//КонецЕсли;
	//
	//Если ТипЗнч(Компания) = Тип("СправочникСсылка.Организации") Тогда
	//	ЗаполнитьРеквизитыОрганизации(Реквизиты, Компания, Период);
	//ИначеЕсли ТипЗнч(Компания) = Тип("СправочникСсылка.Контрагенты") Тогда
	//	ЗаполнитьРеквизитыКонтрагента(Реквизиты, Компания, Период);
	//Иначе
	//	Возврат Реквизиты;
	//КонецЕсли;
	//
	//Если ПравоДоступа("Чтение", Метаданные.Справочники.БанковскиеСчета) Тогда
	//	
	//	Если Не ЗначениеЗаполнено(БанковскийСчет) Тогда
	//		БанковскийСчет = ПолучитьБанковскийСчетПоУмолчанию(Компания);
	//	КонецЕсли;
	//	
	//	ЗаполнитьРеквизитыБанковскогоСчета(Реквизиты, БанковскийСчет);
	//	
	//КонецЕсли;
	//
	//// Вторичные данные
	//Реквизиты.Представление               = СокрЛП(Реквизиты.Представление);
	//Реквизиты.ПолноеНаименование          = СокрЛП(Реквизиты.ПолноеНаименование);
	//Реквизиты.СокращенноеНаименование     = СокрЛП(Реквизиты.СокращенноеНаименование);
	//Реквизиты.НаименованиеДляПечатныхФорм = СокрЛП(Реквизиты.НаименованиеДляПечатныхФорм);
	//Реквизиты.ТекстКорреспондента         = СокрЛП(Реквизиты.ТекстКорреспондента);
	//
	//Если Не ЗначениеЗаполнено(Реквизиты.ПолноеНаименование) Тогда
	//	Если ЗначениеЗаполнено(Реквизиты.СокращенноеНаименование) Тогда
	//		Реквизиты.ПолноеНаименование = Реквизиты.СокращенноеНаименование;
	//	Иначе
	//		Реквизиты.ПолноеНаименование = Реквизиты.Представление;
	//	КонецЕсли;
	//КонецЕсли;
	//
	//Если ПлатежВБюджет И Не ПустаяСтрока(Реквизиты.ТекстКорреспондента) Тогда
	//	Реквизиты.ПолноеНаименование = Реквизиты.ТекстКорреспондента;
	//КонецЕсли;
	//
	//Если Реквизиты.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо
	//	И Не ПустаяСтрока(Реквизиты.СвидетельствоСерияНомер) Тогда
	//	Реквизиты.Свидетельство = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//		НСтр("ru = 'свидетельство %1 от %2'"),
	//		Реквизиты.СвидетельствоСерияНомер,
	//		Формат(Реквизиты.СвидетельствоДатаВыдачи, "ДЛФ=D"));
	//КонецЕсли;
	//
	//Возврат Реквизиты;

КонецФункции

Функция ОписаниеОрганизации(СписокСведений, Список = "", СПрефиксом = Истина) Экспорт
 //ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации();	
КонецФункции	

Функция ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти, РезультатПриОшибке = Истина) Экспорт
	//ОбщегоНазначенияБПВызовСервера.ПроверитьВыводТабличногоДокумента();
КонецФункции

Функция НомерНаПечать(Знач НомерОбъекта, УдалитьПрефиксИнформационнойБазы = Ложь, УдалитьПользовательскийПрефикс = Ложь) Экспорт
	
//ПрефиксацияОбъектовКлиентСервер.НомерНаПечать();	
	
КонецФункции

&НаСервере
Функция РазложитьСтрокуНаПодстроки(ВходящаяСтрока, Разделитель) Экспорт
						   
	МассивСтрок = Новый Массив();
	ВходящаяСтрока = СтрЗаменить(ВходящаяСтрока, Разделитель, Символы.ПС);
	
	Для ИндексСтроки = 1 По СтрЧислоСтрок(ВходящаяСтрока) Цикл
		Подстрока = СтрПолучитьСтроку(ВходящаяСтрока, ИндексСтроки);
		МассивСтрок.Добавить(Подстрока);
	КонецЦикла;
	
	Возврат МассивСтрок;

КонецФункции 

&НаСервере
Функция ОбновитьИнформациюОстаткиБанкКасса(СтрокаXML) Экспорт
		
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	ТабДок = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);

	Дата = ТабДок.Дата;
	ОрганизацияИНН = ТабДок.ОрганизацияИНН;
	Организация = ВнешниеИсточникиДанных.БухгалтерияПредприятия30.Таблицы.Организации.НайтиПоПолю("ИНН", ОрганизацияИНН);
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Храм_ЕпархиальныйОтчет.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.Храм_ЕпархиальныйОтчет КАК Храм_ЕпархиальныйОтчет
		|ГДЕ
		|	Храм_ЕпархиальныйОтчет.Организация = &Организация
		|	И Храм_ЕпархиальныйОтчет.КонПериода >= &Дата";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДокументОтчет = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ДокументОтчет.НеобходимоПересчитатьДанные = Истина;
		ДокументОтчет.Записать();
	КонецЦикла;

КонецФункции

Процедура ОбновитьДанныеИзВнешнегоИсточника() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Храм_ЕпархиальныйОтчет.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.Храм_ЕпархиальныйОтчет КАК Храм_ЕпархиальныйОтчет
		|ГДЕ
		|	Храм_ЕпархиальныйОтчет.НеобходимоПересчитатьДанные = ИСТИНА";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДокументОтчет = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ДокументОтчет.ЗаполнитьПоДаннымБухучетаНаСервере();
		ДокументОтчет.НеобходимоПересчитатьДанные = Ложь;
		ДокументОтчет.Записать();
	КонецЦикла;

КонецПроцедуры
