import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/user.dart';
import '../widgets/alert.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _form = GlobalKey();

  bool _isLoading = false;

  String name;
  String surname;
  String profileImage;
  String adress;
  List<String> favoriteCategories=[];
  bool _init_state =true;
  File imageFile = null;

  void _saveUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_form.currentState.validate()) {
      _form.currentState.save();

      try {
        await Provider.of<User>(context, listen: false).updateuser(
            name, surname, adress, profileImage, favoriteCategories);
      } catch (error) {
        await alert(context, 'Could not reach database');
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  void didChangeDependencies() {
    if (_init_state) {
      User userData = Provider.of<User>(context, listen: false);
      if (userData != null) {
        name = userData.name == null ? ' ' : userData.name;
        surname = userData.surname == null ? ' ' : userData.surname;
        adress = userData.adress == null ? ' ' : userData.adress;
        profileImage =
            userData.profileImage == null ? ' ' : userData.profileImage;
        favoriteCategories = userData.favoriteCategories == null
            ? []
            : userData.favoriteCategories;
      }
      _init_state=false;
    }
    super.didChangeDependencies();
  }

  void _toogleFavorite(String cat) {
    var index = favoriteCategories.indexWhere((elem) {
      return elem == cat;
    });
    setState(() {
      if (index == -1) {
        favoriteCategories.add(cat);
      } else {
        favoriteCategories.removeAt(index);
      }
    });
  }

  void _takePicture() async {
     final file = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 600, maxWidth: 600);
     setState(() {
       imageFile = file;
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _saveUser();
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading? Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(3),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Stack(
                        children: <Widget>[
                          imageFile == null? Image.network(
                            'http://s3.amazonaws.com/37assets/svn/765-default-avatar.png',
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ):
                          Image.file(
                            imageFile,height: 150,
                            width: 150,
                            fit: BoxFit.cover,),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _takePicture();
                            },
                          )
                        ],
                      ),
                    ),
                    Form(
                      key: _form,
                      child: Expanded(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) {
                                name = value;
                              },
                              initialValue: name,
                              onFieldSubmitted: (_) {},
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Surname'),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) {
                                surname = value;
                              },
                              initialValue: surname,
                              onFieldSubmitted: (_) {},
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Adress'),
                              onSaved: (value) {
                                adress = value;
                              },
                              initialValue: adress,
                              onFieldSubmitted: (_) {},
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(3),
              elevation: 5,
              child: Container(
                  height: 350,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Choose your favorite categories',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: GridView.builder(
                              itemBuilder: (ctx, index) {
                                var name =
                                    Categories.categories.keys.toList()[index];
                                var icon = Categories.categories.values
                                    .toList()[index];
                                return GridTile(
                                  child: Column(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          icon,
                                          color:
                                              favoriteCategories.contains(name)
                                                  ? Colors.green
                                                  : Colors.grey,
                                        ),
                                        onPressed: () {
                                          _toogleFavorite(name);
                                        },
                                      ),
                                      Text(name),
                                    ],
                                  ),
                                );
                              },
                              itemCount: Categories.categories.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, //Amount of Columns to have
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
