import 'package:contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    super.initState();

    Contact c = new Contact();
    c.name = "Murilo de Moraes Tuvani";
    c.email = "murilo.tuvani@gmail.com";
    c.phone = "(11)99999-0000";
    c.img = "img.jpg";

    helper.saveContact(c);

    helper.getAllContacts().then((list) {
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
