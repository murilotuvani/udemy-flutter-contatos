import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTable = "contacts";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

/**
 * Implementado com Singleton
 */
class ContactHelper {
  // Chama um construtor interno
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db ==null) {
      _db = await initDb();
    }
    return _db;
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath,  "contacts.db");

    /**
     * Cria ou atualiza a tabela ao cria o banco de dados
     */
    return await openDatabase(path, version: 1, onCreate: (Database db, int versao) async {
      await db.execute("CREATE TABLE $contactTable ($idColumn INTEGER PRIMARY KEY,\n" +
          " $nameColumn TEXT,\n" +
          " $emailColumn TEXT,\n" +
          " $phoneColumn TEXT,\n" +
          " $imgColumn TEXT)");
    });
  }

  /**
   * Insere os contatos no banco utilizando-o como um mapa
   *
   */
  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  /**
   * Faz uma query no banco de dados para obter as colunas</br>
   * com o where especificado passando o argumento de whereArgs</br>
   * para preencher o parametro do where
   */
  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: "$idColumn = ?", whereArgs: [id]);

    if(maps.length>0) {
      return Contact.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    int deleted = await dbContact.delete(contactTable, where:  "$idColumn = ?", whereArgs: [id]);
    return deleted;
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    int updated = await dbContact.update(contactTable, contact.toMap(), where:  "$idColumn = ?", whereArgs: [contact.id]);
    return updated;
  }

  Future<List<Contact>> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for(Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }


  Future<int> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(1) FROM $contactTable"));
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }

}



class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }
//    map.putIfAbsent(idColumn, id);
//    map.putIfAbsent(nameColumn, name);
//    map.putIfAbsent(emailColumn, email);
//    map.putIfAbsent(phoneColumn, phone);
//    map.putIfAbsent(imgColumn, img);
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
