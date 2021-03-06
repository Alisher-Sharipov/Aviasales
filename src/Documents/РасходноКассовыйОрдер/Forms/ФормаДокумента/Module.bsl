&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЭтаФорма.Параметры.ВидОперации="ОплатаПоставщику" Тогда
		ЭтаФорма.Заголовок="Оплата поставщику";	
	ИначеЕсли ЭтаФорма.Параметры.ВидОперации="ПрочийРасход" Тогда
		ЭтаФорма.Заголовок="Прочий расход денежных средств";
		Элементы.Группа2.Видимость=Ложь;
	КонецЕсли;
	Если Объект.НужнаКонвертация Тогда
		Элементы.СуммаКонвертации.Видимость=Истина;
		Элементы.ВалютаКонвертации.Видимость=Истина;
		Элементы.Курс.Видимость=Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидОплатыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Данные=ОбработкаВыбора(ВыбранноеЗначение);
	Если Данные="Наличный" Тогда
		Элементы.БанковскийСчет.Видимость=Ложь;
		Элементы.Касса.Видимость=Истина;
	ИначеЕсли Данные="Безналичный" Тогда
		Элементы.БанковскийСчет.Видимость=Истина;
		Элементы.Касса.Видимость=Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ОбработкаВыбора(ВыбранноеЗначение)
	ВидОплаты="";
	Если ВыбранноеЗначение=Перечисления.ВидОплаты.Наличный Тогда
		ВидОплаты="Наличный";	
	ИначеЕсли ВыбранноеЗначение=Перечисления.ВидОплаты.Безналичный Тогда
		ВидОплаты="Безналичный";	
	КонецЕсли;
	Возврат ВидОплаты;
КонецФункции

&НаСервереБезКонтекста
Функция ПоставщикОбработкаВыбораНаСервере(ВыбранноеЗначение)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВзаиморасчетыСАвиакомпаниямиОстатки.СуммаЗадолженностиАГНОстаток КАК СуммаЗадолженностиАГНОстаток
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСАгенствами.Остатки КАК ВзаиморасчетыСАвиакомпаниямиОстатки
	|ГДЕ
	|	ВзаиморасчетыСАвиакомпаниямиОстатки.Авиакомпания = &Авиакомпания";
	
	Запрос.УстановитьПараметр("Авиакомпания", ВыбранноеЗначение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Долг=0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Долг=ВыборкаДетальныеЗаписи.СуммаЗадолженностиАГНОстаток;	
	КонецЦикла;
	Возврат Долг;
	
КонецФункции
&НаКлиенте
Процедура ПоставщикОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Долг=ПоставщикОбработкаВыбораНаСервере(ВыбранноеЗначение);
	Элементы.Декорация1.Заголовок="Долг: "+Долг;
КонецПроцедуры

&НаКлиенте
Процедура НужнаКонвертацияПриИзменении(Элемент)
		Если Объект.НужнаКонвертация=Истина Тогда
		Элементы.КассаКонвертации.Видимость=Истина;
		Элементы.Курс.Видимость=Истина;
		Элементы.СуммаКонвертации.Видимость=Истина;
		Элементы.ВалютаКонвертации.Видимость=Истина;
	Иначе
		Элементы.КассаКонвертации.Видимость=Ложь;
		Элементы.Курс.Видимость=Ложь;
		Элементы.СуммаКонвертации.Видимость=Ложь;
		Элементы.ВалютаКонвертации.Видимость=Ложь;		
		КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура КурсПриИзменении(Элемент)
		Объект.СуммаКонвертации=Объект.СуммаОплаты/Объект.Курс;
КонецПроцедуры

