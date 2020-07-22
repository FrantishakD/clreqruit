Zadanie rekrutacyjne <br/>
Na deweloperskim sandbox’ie przygotuj Apex REST API, które będzie przyjmować listę leadów w formacie JSON i zapisywać je do standardowego obiektu “Lead”. Endpoint powinien zawierać jedną metodę do tworzenia i aktualizacji rekordów. Do obiektu “Lead” należy dodać pole External Id, w którym będziemy przechowywać zewnętrzne id lead’a. Pola obowiązkowe to id, lastname i phone. Jeśli obiekt nie zawiera tych pól, to API powinno zwrócić: id obiektu, flagę success równą “false” oraz message z błędem. Natomiast dla rekordów, które udało się zapisać, API powinno zwrócić ich id, flagę success równą “true” oraz message “Created” lub “Updated”. <br/>
Model danych (Request): <br/>
Lead: <br/>
UUID Id DateTime createddate String firstname String lastname String phone Address address <br/>
Address: <br/>
String street String city String postalcode String country <br/>
Przykładowy JSON: <br/>
[
{
“id” : “123e4567-e89b-12d3-a456-426655440000”, “createddate” : “​2019-10-24T11:28:41.000-0700”, “firstname” : “Arnold”, “lastname” : “Shwarzenegger”, “phone” : “12223334444”, “address” : {
“street” : “Coulterville” “city” : “Los Angeles”, “postalcode” : “​99501” “country” : “United States”
} }, {
“id” : “00112233-4455-6677-8899-aabbccddeeff”, “createddate” : “​2019-10-24T13:02:45.000-0700”, “firstname” : “Brad”, “lastname” : “Pitt”, “phone” : null, “address” : {
“street” : “Beverly Dr 238/1” “city” : “​Beverly Hills​”, “postalcode” : “​90212​” “country” : “United States” } }
] <br/>
Przykładowa odpowiedź: <br/>
[
{
“id” : “123e4567-e89b-12d3-a456-426655440000”, “success” : true, “message” : “Created” }, {
“id” : “00112233-4455-6677-8899-aabbccddeeff”, “success” : false, “message” : “Required field missing” } ]
