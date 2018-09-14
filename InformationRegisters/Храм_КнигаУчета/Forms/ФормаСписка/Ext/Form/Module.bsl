﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЭтаФорма.Параметры.Свойство("ДатаНачала") Тогда	
		Элементы.Список.Период.ДатаНачала = ЭтаФорма.Параметры.ДатаНачала;
	КонецЕсли;
	
	Если ЭтаФорма.Параметры.Свойство("ДатаОкончания") Тогда
		Элементы.Список.Период.ДатаОкончания = ЭтаФорма.Параметры.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПриИзмененииНаСервере()
	СчитаемИтогиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	СписокПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаИзменения()
	
	НастройкиСпискаТек = "";
	Для Каждого ЭлементПользНастроек Из	Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		//тут отборы и сортировка - отловим их
		НастройкиСпискаТек = НастройкиСпискаТек + СокрЛП(ЭлементПользНастроек) + СокрЛП(Элементы.Список.Период.ДатаНачала) + СокрЛП(Элементы.Список.Период.ДатаОкончания);
	КонецЦикла;
	
	//тут добавим в ловушку период списка (если это список документов)
	НастройкиСпискаТек = НастройкиСпискаТек + СокрЛП(Элементы.Список.Период.ДатаНачала) + СокрЛП(Элементы.Список.Период.ДатаОкончания) + СокрЛП(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор);
	Если не НастройкиСписка = НастройкиСпискаТек Тогда	
		
		//чей-то поменялось
		НастройкиСписка = НастройкиСпискаТек;
		
		СчитаемИтогиНаСервере();	
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СчитаемИтогиНаСервере()
	
	//получаем схему компоновки списка
	СКД = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	
	//добавляем ресурсы
	ПолеИтога = СКД.ПоляИтога.Добавить();
	ПолеИтога.ПутьКДанным 	= "СуммаПриход";
	ПолеИтога.Выражение 	= "СУММА(СуммаПриход)";
	
	ПолеИтога = СКД.ПоляИтога.Добавить();
	ПолеИтога.ПутьКДанным 	= "СуммаРасход";
	ПолеИтога.Выражение 	= "СУММА(СуммаРасход)";
	
	//получаем настройки компоновки списка (в ней уже есть отборы и поиск)
	НастройкаСКД 	= Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	//Нам не нужна вся таблица, а только итог
	//Очищаем поля основной группировки - получаем в итоге группировку всего запроса по "неопределено" и на выходе одну строку в результате
	НастройкаСКД.Структура[0].ПоляГруппировки.Элементы.Очистить();
	
	//Нам не нужны все поля, а только наши ресурсы
	НастройкаСКД.Структура[0].Выбор.Элементы.Очистить();
	Выб = НастройкаСКД.Структура[0].Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Выб.Поле 			= Новый ПолеКомпоновкиДанных("СуммаПриход");
	Выб.Использование 	= Истина;
	
	Выб = НастройкаСКД.Структура[0].Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Выб.Поле 			= Новый ПолеКомпоновкиДанных("СуммаРасход");
	Выб.Использование 	= Истина;
	
	//Получаем результат
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СКД, НастройкаСКД,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")) ;
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	//Заполняем реквизиты итогов подвала
	ИтогиПриходПодвал = Результат.Итог("СуммаПриход");
	ИтогиРасходПодвал = Результат.Итог("СуммаРасход");

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииЯчейки(Элемент)
	СчитаемИтогиНаСервере();
КонецПроцедуры

&НаСервере
Функция ПечатьАктаВскрытияЯщиковНаСервере()
	
	Если не ЗначениеЗаполнено(ДокументВладелец) Тогда
		возврат Неопределено;
	КонецЕсли;
	
	
	Объект =  ДокументВладелец;
	
	
	ОбъектыПечати = новый СписокЗначений;
	ОбъектыПечати.Добавить(Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры макета по умолчанию
	ТабДокумент.РазмерКолонтитулаСверху = 0;
	ТабДокумент.РазмерКолонтитулаСнизу  = 0;
	ТабДокумент.АвтоМасштаб             = Истина;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;
	ТабДокумент.ИмяПараметровПечати     = "ПАРАМЕТРЫ_ПЕЧАТИ_Храм_Храм_АктВскрытияЯщиковСбораПожертвований";
	
	ОбщегоНазначения.УстановитьМинимальныеПоляПечати(ТабДокумент);
	
	Макет = ОбщегоНазначения.МакетПечатнойФормы("РегистрСведений.Храм_КнигаУчета.ПФ_MXL_Храм_АктВскрытияЯщиковСбораПожертвований");
	
	
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
	СведенияОбОрганизации = ОбщегоНазначения.СведенияОЮрФизЛице(Объект.Организация, Объект.Дата);
	
	СтруктураШапки = Новый Структура;
	СтруктураШапки.Вставить("Организация",   ОбщегоНазначения.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм"));
	СтруктураШапки.Вставить("АдресОрганизации",   ОбщегоНазначения.ОписаниеОрганизации(СведенияОбОрганизации, "ФактическийАдрес"));
	СтруктураШапки.Вставить("ТелефонОрганизации",   ОбщегоНазначения.ОписаниеОрганизации(СведенияОбОрганизации, "Телефоны"));
	СтруктураШапки.Вставить("НомерДокумента", ОбщегоНазначения.НомерНаПечать(Объект.Номер, Истина, Ложь));
	СтруктураШапки.Вставить("ДатаДокумента",  Формат(Объект.Дата, "ДЛФ=ДД"));
	
	
	СтруктураШапки.Вставить("НачПериода", Формат(Объект.Дата,"ДЛФ=ДД" ));
	СтруктураШапки.Вставить("КонПериода", Формат(Объект.Дата,"ДЛФ=ДД" ));
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ПредседательКомиссии КАК ПредседательКомиссии,
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ЧленКомиссии1 КАК ЧленКомиссии1,
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ЧленКомиссии2 КАК ЧленКомиссии2
	|ИЗ
	|	РегистрСведений.Храм_ИнвентаризационнаяКомиссия.СрезПоследних(&Период, Организация = &Организация) КАК Храм_ИнвентаризационнаяКомиссияСрезПоследних";
	
	Запрос.УстановитьПараметр("Период",Объект.Дата );
	Запрос.УстановитьПараметр("Организация",Объект.Организация );
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	ВыборкаДляПодвала = Результат.Выбрать();

	Если Выборка.Следующий() Тогда
		
		СтруктураШапки.Вставить("ПредседательКомиссии",   Выборка.ПредседательКомиссии);
		СтруктураШапки.Вставить("ЧленКомиссии1", Выборка.ЧленКомиссии1);
		СтруктураШапки.Вставить("ЧленКомиссии2",  Выборка.ЧленКомиссии2);
		
		
	КонецЕсли;;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Храм_КнигаУчета.Ящик.МестоРасположения КАК ЯщикМестоРасположения
	|ИЗ
	|	РегистрСведений.Храм_КнигаУчета КАК Храм_КнигаУчета
	|ГДЕ
	|	Храм_КнигаУчета.ДокументХозяйственнойОперации = &ДокументХозяйственнойОперации";
	
	Запрос.УстановитьПараметр("ДокументХозяйственнойОперации",Объект);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	АдресУстановки = ""; 
	Пока Выборка.Следующий() Цикл
		Если АдресУстановки = "" Тогда
			
			АдресУстановки = АдресУстановки + Выборка.ЯщикМестоРасположения;
		Иначе
			АдресУстановки = АдресУстановки + "; " + Выборка.ЯщикМестоРасположения;
		КонецЕсли;
	КонецЦикла;;
	
	СтруктураШапки.Вставить("АдресУстановки",   АдресУстановки);
	
	
	ШапкаДокумента.Параметры.Заполнить(СтруктураШапки);
	ТабДокумент.Вывести(ШапкаДокумента);
	
	
	///////////////////		
	ТабДокумент.Вывести(ОборотЗаголовокТаблицы);
	
	Запрос = Новый Запрос;               //Запрос такой хитрый потому что к одному документу надо выбрать одну проводку
	Запрос.Текст = "ВЫБРАТЬ
	|	Храм_КнигаУчета.Ящик КАК Ящик,
	|	Храм_КнигаУчета.НаправлениеПрихода КАК НаправлениеПрихода,
	|	Храм_КнигаУчета.НаправлениеРасхода КАК НаправлениеРасхода,
	|	Храм_КнигаУчета.СуммаПриход КАК СуммаПриход
	|ИЗ
	|	РегистрСведений.Храм_КнигаУчета КАК Храм_КнигаУчета
	|ГДЕ
	|	Храм_КнигаУчета.ДокументХозяйственнойОперации = &ДокументХозяйственнойОперации";
	
	Запрос.УстановитьПараметр("ДокументХозяйственнойОперации", Объект);
	
	
	Результат1 = Запрос.Выполнить();
	Выборка1 = Результат1.Выбрать();
	СтруктураОборотСтроки = Новый Структура;
	
	Остаток = 0;
	ОборотПриход = 0;
	ОборотРасход = 0;
	Номер = 0;
	Пока Выборка1.Следующий() Цикл
		Номер = Номер +1;
		
		//СтруктураОборотСтроки.Вставить("НомерЯщика", Номер);
		СтруктураОборотСтроки.Вставить("ДокументХозяйственнойОперации", Объект);
		СтруктураОборотСтроки.Вставить("Ящик", Выборка1.Ящик);
		//Если Выборка1.НаправлениеПрихода = Справочники.Храм_НаправленияПрихода.Целевое Тогда
		//	СтруктураОборотСтроки.Вставить("НаправлениеРасхода", " на цели " + Выборка1.НаправлениеРасхода);
		//иначе
		//	СтруктураОборотСтроки.Вставить("НаправлениеРасхода", " на уставные цели" );
		//КонецЕсли;
		СтруктураОборотСтроки.Вставить("СуммаПрописью", ЧислоПрописью(Выборка1.СуммаПриход, "Л = ru_RU; ДП = Истина", "рубль,рубля,рублей,м,копейка,копейки,копеек,ж,2"));
		
		//СтруктураОборотСтроки.Вставить("Содержание",Выборка1.ДокументХозяйственнойОперацииПредставление);
		//СтруктураОборотСтроки.Вставить("СчетДт", Выборка1.СчетДт);
		//СтруктураОборотСтроки.Вставить("СчетКт", Выборка1.СчетКт);
		//СтруктураОборотСтроки.Вставить("Приход", Выборка1.СуммаПриход);
		//СтруктураОборотСтроки.Вставить("Расход", Выборка1.СуммаРасход);
		//Остаток = 	Остаток + Выборка1.СуммаПриход - Выборка1.СуммаРасход;
		//СтруктураОборотСтроки.Вставить("Остаток", Остаток);
		//ОборотПриход = ОборотПриход + Выборка1.СуммаПриход;
		//ОборотРасход = ОборотРасход + Выборка1.СуммаРасход;
		
		
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
	СтруктураОборотИтоги.Вставить("Приход", ОборотПриход);
	СтруктураОборотИтоги.Вставить("Расход", ОборотРасход);
	
	
	
	
	
	
	
	
	
	ОборотИтоги.Параметры.Заполнить(СтруктураОборотИтоги);
	ТабДокумент.Вывести(ОборотИтоги);
	
	
	
	
	
	//		
	//	// Выведем подвал документа.
	СтруктураПодвала = Новый Структура;
	//	СтруктураПодвала.Вставить("Настоятель",  Выборка.Настоятель);
	//СтруктураПодвала.Вставить("ПредседательПриходскогоСовета",    Выборка.ПредседательПриходскогоСовета);
	//СтруктураПодвала.Вставить("Казначей",  Выборка.Казначей);

	Если ВыборкаДляПодвала.Следующий() Тогда
		
		СтруктураПодвала.Вставить("ПредседательКомиссии",   ВыборкаДляПодвала.ПредседательКомиссии);
		СтруктураПодвала.Вставить("ЧленКомиссии1", ВыборкаДляПодвала.ЧленКомиссии1);
		СтруктураПодвала.Вставить("ЧленКомиссии2",  ВыборкаДляПодвала.ЧленКомиссии2);
		
		
	КонецЕсли;;
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
	ОбщегоНазначения.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
	НомерСтрокиНачало, ОбъектыПечати, Объект.Ссылка);
	
	
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	//ТабДокумент.ОтображатьСетку = Ложь;
	Возврат ТабДокумент;
	
	
КонецФункции

&НаКлиенте
Процедура ПечатьАктаВскрытияЯщиков(Команда)
	ТабДокумент = ПечатьАктаВскрытияЯщиковНаСервере();
	
	если ТабДокумент<>Неопределено Тогда
		ТабДокумент.ТолькоПросмотр = Истина;
		
		ТабДокумент.Показать();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПечатьАктаПриемаПожертвованийНаСервере()
	
	Если не ЗначениеЗаполнено(ДокументВладелец) Тогда
		возврат Неопределено;
	КонецЕсли;
	
	
	Объект =  ДокументВладелец;
	
	
	ОбъектыПечати = новый СписокЗначений;
	ОбъектыПечати.Добавить(Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры макета по умолчанию
	ТабДокумент.РазмерКолонтитулаСверху = 0;
	ТабДокумент.РазмерКолонтитулаСнизу  = 0;
	ТабДокумент.АвтоМасштаб             = Истина;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;
	ТабДокумент.ИмяПараметровПечати     = "ПАРАМЕТРЫ_ПЕЧАТИ_Храм_Храм_АктПриемаПожертвований";
	
	ОбщегоНазначения.УстановитьМинимальныеПоляПечати(ТабДокумент);
	
	Макет = ОбщегоНазначения.МакетПечатнойФормы("РегистрСведений.Храм_КнигаУчета.ПФ_MXL_Храм_АктПриемаПожертвований");
	
	
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
	СведенияОбОрганизации = ОбщегоНазначения.СведенияОЮрФизЛице(Объект.Организация, Объект.Дата);
	
	СтруктураШапки = Новый Структура;
	СтруктураШапки.Вставить("Организация",   ОбщегоНазначения.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм"));
	СтруктураШапки.Вставить("АдресОрганизации",   ОбщегоНазначения.ОписаниеОрганизации(СведенияОбОрганизации, "ФактическийАдрес"));
	СтруктураШапки.Вставить("ТелефонОрганизации",   ОбщегоНазначения.ОписаниеОрганизации(СведенияОбОрганизации, "Телефоны"));
	СтруктураШапки.Вставить("НомерДокумента", ОбщегоНазначения.НомерНаПечать(Объект.Номер, Истина, Ложь));
	СтруктураШапки.Вставить("ДатаДокумента",  Формат(Объект.Дата, "ДЛФ=ДД"));
	
	
	СтруктураШапки.Вставить("НачПериода", Формат(Объект.Дата,"ДЛФ=ДД" ));
	СтруктураШапки.Вставить("КонПериода", Формат(Объект.Дата,"ДЛФ=ДД" ));
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ПредседательКомиссии КАК ПредседательКомиссии,
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ЧленКомиссии1 КАК ЧленКомиссии1,
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ЧленКомиссии2 КАК ЧленКомиссии2
	|ИЗ
	|	РегистрСведений.Храм_ИнвентаризационнаяКомиссия.СрезПоследних(&Период, Организация = &Организация) КАК Храм_ИнвентаризационнаяКомиссияСрезПоследних";
	
	Запрос.УстановитьПараметр("Период",Объект.Дата );
	Запрос.УстановитьПараметр("Организация",Объект.Организация );
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СтруктураШапки.Вставить("ПредседательКомиссии",   Выборка.ПредседательКомиссии);
		СтруктураШапки.Вставить("ЧленКомиссии1", Выборка.ЧленКомиссии1);
		СтруктураШапки.Вставить("ЧленКомиссии2",  Выборка.ЧленКомиссии2);
		
		
	КонецЕсли;;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Храм_КнигаУчета.Ящик.МестоРасположения КАК ЯщикМестоРасположения
	|ИЗ
	|	РегистрСведений.Храм_КнигаУчета КАК Храм_КнигаУчета
	|ГДЕ
	|	Храм_КнигаУчета.ДокументХозяйственнойОперации = &ДокументХозяйственнойОперации";
	
	Запрос.УстановитьПараметр("ДокументХозяйственнойОперации",Объект);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	АдресУстановки = ""; 
	Пока Выборка.Следующий() Цикл
		Если АдресУстановки = "" Тогда
			
			АдресУстановки = АдресУстановки + Выборка.ЯщикМестоРасположения;
		Иначе
			АдресУстановки = АдресУстановки + "; " + Выборка.ЯщикМестоРасположения;
		КонецЕсли;
	КонецЦикла;;
	
	СтруктураШапки.Вставить("АдресУстановки",   АдресУстановки);
	
	
	ШапкаДокумента.Параметры.Заполнить(СтруктураШапки);
	ТабДокумент.Вывести(ШапкаДокумента);
	
	
	///////////////////		
	ТабДокумент.Вывести(ОборотЗаголовокТаблицы);
	
	Запрос = Новый Запрос;               //Запрос такой хитрый потому что к одному документу надо выбрать одну проводку
	Запрос.Текст = "ВЫБРАТЬ
	|	Храм_КнигаУчета.Ящик КАК Ящик,
	|	Храм_КнигаУчета.НаправлениеПрихода КАК НаправлениеПрихода,
	|	Храм_КнигаУчета.НаправлениеРасхода КАК НаправлениеРасхода,
	|	Храм_КнигаУчета.СуммаПриход КАК СуммаПриход
	|ИЗ
	|	РегистрСведений.Храм_КнигаУчета КАК Храм_КнигаУчета
	|ГДЕ
	|	Храм_КнигаУчета.ДокументХозяйственнойОперации = &ДокументХозяйственнойОперации";
	
	Запрос.УстановитьПараметр("ДокументХозяйственнойОперации", Объект);
	
	
	Результат1 = Запрос.Выполнить();
	Выборка1 = Результат1.Выбрать();
	СтруктураОборотСтроки = Новый Структура;
	
	Остаток = 0;
	ОборотПриход = 0;
	ОборотРасход = 0;
	Номер = 0;
	Пока Выборка1.Следующий() Цикл
		Номер = Номер +1;
		
		СтруктураОборотСтроки.Вставить("НомерЯщика", Номер);
		СтруктураОборотСтроки.Вставить("ДокументХозяйственнойОперации", Объект);
		СтруктураОборотСтроки.Вставить("Ящик", Выборка1.Ящик);
		Если Выборка1.НаправлениеПрихода = Справочники.Храм_НаправленияПрихода.Целевое Тогда
			СтруктураОборотСтроки.Вставить("НаправлениеРасхода", " на цели " + Выборка1.НаправлениеРасхода);
		иначе
			СтруктураОборотСтроки.Вставить("НаправлениеРасхода", " на уставные цели" );
		КонецЕсли;
		СтруктураОборотСтроки.Вставить("СуммаПрописью", ЧислоПрописью(Выборка1.СуммаПриход, "Л = ru_RU; ДП = Истина", "рубль,рубля,рублей,м,копейка,копейки,копеек,ж,2"));
		СтруктураОборотСтроки.Вставить("Комментарий", Объект.Комментарий);
		
		//СтруктураОборотСтроки.Вставить("Содержание",Выборка1.ДокументХозяйственнойОперацииПредставление);
		//СтруктураОборотСтроки.Вставить("СчетДт", Выборка1.СчетДт);
		//СтруктураОборотСтроки.Вставить("СчетКт", Выборка1.СчетКт);
		//СтруктураОборотСтроки.Вставить("Приход", Выборка1.СуммаПриход);
		//СтруктураОборотСтроки.Вставить("Расход", Выборка1.СуммаРасход);
		//Остаток = 	Остаток + Выборка1.СуммаПриход - Выборка1.СуммаРасход;
		//СтруктураОборотСтроки.Вставить("Остаток", Остаток);
		//ОборотПриход = ОборотПриход + Выборка1.СуммаПриход;
		//ОборотРасход = ОборотРасход + Выборка1.СуммаРасход;
		
		
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
	СтруктураОборотИтоги.Вставить("Приход", ОборотПриход);
	СтруктураОборотИтоги.Вставить("Расход", ОборотРасход);
	
	
	
	
	
	
	
	
	
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
	ОбщегоНазначения.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
	НомерСтрокиНачало, ОбъектыПечати, Объект.Ссылка);
	
	
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	//ТабДокумент.ОтображатьСетку = Ложь;
	Возврат ТабДокумент;
	
КонецФункции

&НаКлиенте
Процедура ПечатьАктаПриемаПожертвований(Команда)
	ТабДокумент = ПечатьАктаПриемаПожертвованийНаСервере();
	
	если ТабДокумент<>Неопределено Тогда
		ТабДокумент.ТолькоПросмотр = Истина;
		
		ТабДокумент.Показать();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция  ПечатьОтчетаОбОбщемПоступленииПожертвованийНаСервере()
	
	Если не ЗначениеЗаполнено(ДокументВладелец) Тогда
		возврат Неопределено;
	КонецЕсли;
	
	Объект =  ДокументВладелец;
	
	ОбъектыПечати = новый СписокЗначений;
	ОбъектыПечати.Добавить(Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры макета по умолчанию
	ТабДокумент.РазмерКолонтитулаСверху = 0;
	ТабДокумент.РазмерКолонтитулаСнизу  = 0;
	ТабДокумент.АвтоМасштаб             = Истина;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;
	ТабДокумент.ИмяПараметровПечати     = "ПАРАМЕТРЫ_ПЕЧАТИ_Храм_Храм_ОтчетОПоступленииПожертвований";
	
	ОбщегоНазначения.УстановитьМинимальныеПоляПечати(ТабДокумент);
	
	Макет = ОбщегоНазначения.МакетПечатнойФормы("РегистрСведений.Храм_КнигаУчета.ПФ_MXL_Храм_ОтчетОПоступленииПожертвований");
	
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
	СведенияОбОрганизации = ОбщегоНазначения.СведенияОЮрФизЛице(Объект.Организация, Объект.Дата);
	
	СтруктураШапки = Новый Структура;
	СтруктураШапки.Вставить("Организация",   ОбщегоНазначения.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм"));
	СтруктураШапки.Вставить("АдресОрганизации",   ОбщегоНазначения.ОписаниеОрганизации(СведенияОбОрганизации, "ФактическийАдрес"));
	СтруктураШапки.Вставить("ТелефонОрганизации",   ОбщегоНазначения.ОписаниеОрганизации(СведенияОбОрганизации, "Телефоны"));
	СтруктураШапки.Вставить("НомерДокумента", ОбщегоНазначения.НомерНаПечать(Объект.Номер, Истина, Ложь));
	СтруктураШапки.Вставить("ДатаДокумента",  Формат(Объект.Дата, "ДЛФ=ДД"));
	
	СтруктураШапки.Вставить("НачПериода", Формат(Объект.Дата,"ДЛФ=ДД" ));
	СтруктураШапки.Вставить("КонПериода", Формат(Объект.Дата,"ДЛФ=ДД" ));
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ПредседательКомиссии КАК ПредседательКомиссии,
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ЧленКомиссии1 КАК ЧленКомиссии1,
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ЧленКомиссии2 КАК ЧленКомиссии2,
	|	Храм_ИнвентаризационнаяКомиссияСрезПоследних.ЛицоУполномоченноеНаСборПожертвований КАК ЛицоУполномоченноеНаСборПожертвований
	|ИЗ
	|	РегистрСведений.Храм_ИнвентаризационнаяКомиссия.СрезПоследних(&Период, Организация = &Организация) КАК Храм_ИнвентаризационнаяКомиссияСрезПоследних";
	
	Запрос.УстановитьПараметр("Период",Объект.Дата );
	Запрос.УстановитьПараметр("Организация",Объект.Организация );
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СтруктураШапки.Вставить("ЛицоУполномоченноеНаСборПожертвований",   Выборка.ЛицоУполномоченноеНаСборПожертвований);
		
	КонецЕсли;;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Храм_КнигаУчета.Ящик.МестоРасположения КАК ЯщикМестоРасположения
	|ИЗ
	|	РегистрСведений.Храм_КнигаУчета КАК Храм_КнигаУчета
	|ГДЕ
	|	Храм_КнигаУчета.ДокументХозяйственнойОперации = &ДокументХозяйственнойОперации";
	
	Запрос.УстановитьПараметр("ДокументХозяйственнойОперации",Объект);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	АдресУстановки = ""; 
	Пока Выборка.Следующий() Цикл
		Если АдресУстановки = "" Тогда
			
			АдресУстановки = АдресУстановки + Выборка.ЯщикМестоРасположения;
		Иначе
			АдресУстановки = АдресУстановки + "; " + Выборка.ЯщикМестоРасположения;
		КонецЕсли;
	КонецЦикла;;
	
	СтруктураШапки.Вставить("АдресУстановки",   АдресУстановки);
	
	ШапкаДокумента.Параметры.Заполнить(СтруктураШапки);
	ТабДокумент.Вывести(ШапкаДокумента);
	
	///////////////////		
	ТабДокумент.Вывести(ОборотЗаголовокТаблицы);
	
	Запрос = Новый Запрос;               //Запрос такой хитрый потому что к одному документу надо выбрать одну проводку
	Запрос.Текст = "ВЫБРАТЬ
	|	Храм_КнигаУчета.Ящик КАК Ящик,
	|	Храм_КнигаУчета.НаправлениеПрихода КАК НаправлениеПрихода,
	|	Храм_КнигаУчета.НаправлениеРасхода КАК НаправлениеРасхода,
	|	Храм_КнигаУчета.СуммаПриход КАК СуммаПриход
	|ИЗ
	|	РегистрСведений.Храм_КнигаУчета КАК Храм_КнигаУчета
	|ГДЕ
	|	Храм_КнигаУчета.ДокументХозяйственнойОперации = &ДокументХозяйственнойОперации";
	
	Запрос.УстановитьПараметр("ДокументХозяйственнойОперации", Объект);
	
	Результат1 = Запрос.Выполнить();
	Выборка1 = Результат1.Выбрать();
	СтруктураОборотСтроки = Новый Структура;
	
	Остаток = 0;
	ОборотПриход = 0;
	ОборотРасход = 0;
	Номер = 0;
	Пока Выборка1.Следующий() Цикл
		Номер = Номер +1;
		
		СтруктураОборотСтроки.Вставить("НомерЯщика", Номер);
		СтруктураОборотСтроки.Вставить("ДокументХозяйственнойОперации", Объект);
		СтруктураОборотСтроки.Вставить("Ящик", Выборка1.Ящик);
		Если Выборка1.НаправлениеПрихода = Справочники.Храм_НаправленияПрихода.Целевое Тогда
			СтруктураОборотСтроки.Вставить("НаправлениеРасхода", " на цели " + Выборка1.НаправлениеРасхода);
		иначе
			СтруктураОборотСтроки.Вставить("НаправлениеРасхода", " на уставные цели" );
		КонецЕсли;
		СтруктураОборотСтроки.Вставить("СуммаПрописью", ЧислоПрописью(Выборка1.СуммаПриход, "Л = ru_RU; ДП = Истина", "рубль,рубля,рублей,м,копейка,копейки,копеек,ж,2"));
		СтруктураОборотСтроки.Вставить("Сумма", Формат(Выборка1.СуммаПриход, "ЧЦ=15; ЧДЦ=2"));
		СтруктураОборотСтроки.Вставить("Комментарий", Объект.Комментарий);
		Остаток = Выборка1.СуммаПриход;
		
		ОборотСтрокиТаблицы.Параметры.Заполнить(СтруктураОборотСтроки);
		ТабДокумент.Вывести(ОборотСтрокиТаблицы);
		
	КонецЦикла;
	
	СтруктураОборотИтоги = Новый Структура;
	СтруктураОборотИтоги.Вставить("Остаток", Остаток);
	СтруктураОборотИтоги.Вставить("Приход", ОборотПриход);
	СтруктураОборотИтоги.Вставить("Расход", ОборотРасход);
	СтруктураОборотИтоги.Вставить("Сумма", Формат(Остаток, "ЧЦ=15; ЧДЦ=2"));
	СтруктураОборотИтоги.Вставить("ДокументХозяйственнойОперации", Объект);
	
	ОборотИтоги.Параметры.Заполнить(СтруктураОборотИтоги);
	ТабДокумент.Вывести(ОборотИтоги);
	
	// Выведем подвал документа.
	СтруктураПодвала = Новый Структура;
	//СтруктураПодвала.Вставить("Настоятель",  Выборка.Настоятель);
	//СтруктураПодвала.Вставить("ПредседательПриходскогоСовета",    Выборка.ПредседательПриходскогоСовета);
	//СтруктураПодвала.Вставить("Казначей",  Выборка.Казначей);
	//	
	Подвал.Параметры.Заполнить(СтруктураПодвала);

	ТабДокумент.Вывести(Подвал);
	
	// В табличном документе зададим имя области, в которую был 
	// выведен объект. Нужно для возможности печати покомплектно.
	ОбщегоНазначения.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
	НомерСтрокиНачало, ОбъектыПечати, Объект.Ссылка);
	
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	
	Возврат ТабДокумент;
	
КонецФункции

&НаКлиенте
Процедура ПечатьОтчетаОбОбщемПоступленииПожертвований(Команда)
	ТабДокумент = ПечатьОтчетаОбОбщемПоступленииПожертвованийНаСервере();
	
	если ТабДокумент<>Неопределено Тогда
		ТабДокумент.ТолькоПросмотр = Истина;
		
		ТабДокумент.Показать();
	КонецЕсли;
КонецПроцедуры
