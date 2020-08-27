import 'dart:io';

import 'package:contatos/helpers/contact_helper.dart';
import 'package:contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = null;

  @override
  void initState() {
    super.initState();

    _getAllContacts();

//    Contact c = new Contact();
//    c.name = "Murilo de Moraes Tuvani";
//    c.email = "murilo.tuvani@gmail.com";
//    c.phone = "(11)99999-0000";
//    c.img = "img.jpg";
//
//    helper.saveContact(c);
//
//    helper.getAllContacts().then((list) {
//      print(list);
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _showContactPage,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext buildContext, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contacts[index].img != null
                            ? FileImage(File(contacts[index].img))
                            : AssetImage("images/person.png"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      //onTap: _showContactPage(contacts[index]),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    // Para fazer a coluna ocupar o espaco minimo possivel
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text("Ligar",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 20.0)),
                          onPressed: () {},
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text("Editar",
                              style:
                              TextStyle(color: Colors.red, fontSize: 20.0)),
                          onPressed: () {
                            _showContactPage(contact: contacts[index]);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text("Excluir",
                              style:
                              TextStyle(color: Colors.red, fontSize: 20.0)),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _showContactPage({Contact contact}) async {
    final retContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));

    print("Contato retornado $retContact");

    if (retContact != null) {
      if (contact != null) {
        await helper.updateContact(retContact);
      } else {
        await helper.saveContact(retContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
}
