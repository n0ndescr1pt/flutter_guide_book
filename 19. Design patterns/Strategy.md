**Стратегия** — это поведенческий паттерн проектирования, который определяет семейство схожих алгоритмов и помещает каждый из них в собственный класс, после чего алгоритмы можно взаимозаменять прямо во время исполнения программы.
#### Для чего используется
Определение семейства классов, инкапсулирование каждого из них и организация их взаимозаменяемости.
#### Пример использования
- есть несколько родственных классов, которые отличаются поведением;
- необходимо иметь несколько вариантов поведения; 
- в классе есть данные, о которых не должен знать клиент; 
- с помощью условных операторов в классе определено большое количество возможных поведений; 

#### Example

\*У нас есть разработчик у которого есть несколько видов активности: сон, тренировка, написание кода и в течении дня он может изменять свою активность\*

Общий интерфейс всех стратегий.
```dart
 abstract interface class Activity {
	 void doIt();
 }
```

Каждая конкретная стратегия реализует общий интерфейс своим способом.
```dart
 class Coding implements Activity {
	 @Override
	 void doIt(){
		print("Coding...");
	}
 }
```

```dart
class Reading implements Activity {
	 @Override
	 void doIt(){
		print("Reading...");
	}
 }
```

```dart
class Sleeping implements Activity {
	 @Override
	 void doIt(){
		print("Sleeping...");
	}
 }
```

```dart
 class Training implements Activity {
	 @Override
	 void doIt(){
		print("Training...");
	}
 }
```

Создаем самого разработчика
```dart
 class Developer {
	 Activity activity;
	
	void setActivity(Activity activity){
		this.activity = activity;
	}
	
	void executeActivity(){
		activity.doIt();
	}
 }
```

Конкретная стратегия выбирается на более высоком уровне,
например, конфигуратором всего приложения. Готовый объект-
стратегия подаётся в клиентский объект, а затем может быть
заменён другой стратегией в любой момент на лету.
```dart
 void main() {
	Developer developer = Developer();
	
	developer.setActivity(Sleeping());
	developer.executeActivity(); //Sleeping...
	
	developer.setActivity(Coding());
	developer.executeActivity(); //Coding...
	
	developer.setActivity(Training());
	developer.executeActivity(); //Training...

	//Другой пример
	if (action == addition1) {
		developer.setActivity(Sleeping());
	}
	if (action == addition2) {
		developer.setActivity(Coding());
	}
	if (action == addition3) {
		developer.setActivity(Training());
	}
	result = developer.executeActivity();
 }
```
