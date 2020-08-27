import 'dart:io';

import 'package:contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  // Contato é opcional no construtur, por isso os {}
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    // Pegando da superclasse
    // se for nulo cria um
    // senao cria um novo copiand os campos transformando em mapa
    // e transformando em objeto novamente.
    if (widget.contact == null) {
      _editedContact = new Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: buildScaffold(context),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair as alterações serão perdidas!"),
              actions: [
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context); // Sai do dialogo
                  },
                ),
                FlatButton(
                  child: Text("Confirmar"),
                  onPressed: () {
                    Navigator.pop(context); // Sai do dialogo
                    Navigator.pop(context); // Sai da edicao do contato
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Widget buildScaffold(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact.name ?? "Novo contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showHomePage,
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
                child: Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _editedContact.img != null
                          ? FileImage(File(_editedContact.img))
                          : AssetImage("images/person.png"))),
            )),
            TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                }),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "e-mail"),
              onChanged: (text) {
                _userEdited = true;
                _editedContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone),
          ],
        ),
      ),
    );
  }

  void _showHomePage() {
    // Se o nome nao estiver vazio
    // volta para tela anterior.
    if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
      Navigator.pop(context, _editedContact);
    } else {
      // Caso o nome esteja vazio o foco retorna para
      // o campo de nome
      FocusScope.of(context).requestFocus(_nameFocus);
    }
  }
}
