import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Filmy'),
          ),
          //ListTile(title: Text('Add Server')),
          FilledButton(
              onPressed: () {
                // start of code
                final GlobalKey<FormState> formKey = GlobalKey<FormState>();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      var urlController = TextEditingController();

                      return AlertDialog(
                        scrollable: true,
                        title: const Text('Connect to server'),
                        content: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: urlController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    String pattern =
                                        r'^(?:http|https):\/\/[\w\-_]+(?:\.[\w\-_]+)+[\w\-.,@?^=%&:/~\\+#]*$';
                                    RegExp regExp = RegExp(pattern);

                                    if (value == null || value.isEmpty) {
                                      return 'Please enter valid url';
                                    } else if (!regExp.hasMatch(value)) {
                                      //!regExp.hasMatch(value)
                                      return 'Please enter valid url';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Server Url',
                                    icon: Icon(Icons.web_asset),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Close")),
                          ElevatedButton(
                              child: const Text("Connect"),
                              onPressed: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                var form = formKey.currentState;
                                var value = form?.validate();
                                if (value == true) {
                                  var server_url = urlController.text;
                                  prefs.setString("server_url", server_url);

                                  //Navigator.pop(context);

                                  Phoenix.rebirth(context);
                                }
                              })
                        ],
                      );
                    });

                // end of code
              },
              child: const Text("Connect to server")),

          //ListTile(title: Text('Page One'), onTap: () => _navPush(context, DrawerDirectoryPage())),
          //ListTile(title: Text('Page Two'), onTap: () => _navPush(context, PageTwo()))
        ],
      ),
    );
  }

  Future<dynamic> _navPush(BuildContext context, Widget page) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ));
  }
}
