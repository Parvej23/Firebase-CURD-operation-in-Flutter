import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _nameController= TextEditingController();
  XFile? image;
  final ImagePicker _picker= ImagePicker();
  FirebaseFirestore firestore= FirebaseFirestore.instance;
  final storage= FirebaseStorage.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    super.dispose();
  }
  progressDialog(){
    showDialog(
        context: context,
        builder: (context){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }
  WriteData(context) async{
    showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(builder: (context, setState){
            return Dialog(
              child: Container(
                height: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.title_outlined,
                        ),
                        hintText: 'Language name'
                      ),
                    ),
                    Expanded(
                      child: image==null
                          ?Center(
                          child: IconButton(
                          onPressed: () async{
                            image= await _picker.pickImage(
                              source: ImageSource.gallery);
                            setState((){});
                          },
                            icon: Icon(Icons.add_a_photo),
                        ) ,
                      ):Image.file(
                        File(
                            (image!.path)
                        ),
                        fit: BoxFit.contain,
                      )
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: ()async{
                          try{
                            progressDialog();
                            File imageFile= File(image!.path);
                            UploadTask _uploadTast= storage
                                .ref('images')
                                .child(image!.name)
                                .putFile(imageFile);
                            TaskSnapshot snapshot= await _uploadTast;
                            var imageUrl= await snapshot.ref.getDownloadURL();
                            firestore.collection('languages').add(
                              {
                                'name':_nameController.text,
                                'icon': imageUrl,
                              }
                            ).whenComplete(() {
                              Fluttertoast.showToast(msg: 'Added Successfully');
                              _nameController.clear();
                              image=null;
                              Navigator.of(context)
                              ..pop()
                              ..pop();
                            });
                          }catch(e){
                            print(e);
                            Navigator.of(context)
                            ..pop()
                            ..pop();
                          }
                        },
                        child: Text('Write Data'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        }
    );
  }
  updatedData(context,documentID) async{
    showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(builder: (context, setState){
            return Dialog(
              child: Container(
                height: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.title_outlined,
                        ),
                        hintText: 'Language name'
                      ),
                    ),
                    Expanded(
                      child: image==null
                          ?Center(
                          child: IconButton(
                          onPressed: () async{
                            image= await _picker.pickImage(
                              source: ImageSource.gallery);
                            setState((){});
                          },
                            icon: Icon(Icons.add_a_photo),
                        ) ,
                      ):Image.file(
                        File(
                            (image!.path)
                        ),
                        fit: BoxFit.contain,
                      )
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: ()async{
                          try{
                            progressDialog();
                            File imageFile= File(image!.path);
                            UploadTask _uploadTast= storage
                                .ref('images')
                                .child(image!.name)
                                .putFile(imageFile);
                            TaskSnapshot snapshot= await _uploadTast;
                            var imageUrl= await snapshot.ref.getDownloadURL();
                            firestore.collection('languages').doc(documentID).update(
                              {
                                'name':_nameController.text,
                                'icon': imageUrl,
                              }
                            ).whenComplete(() {
                              Fluttertoast.showToast(msg: 'Update Successfully');
                              _nameController.clear();
                              image=null;
                              Navigator.of(context)
                              ..pop()
                              ..pop();
                            });
                          }catch(e){
                            print(e);
                            Navigator.of(context)
                            ..pop()
                            ..pop();
                          }
                        },
                        child: Text('Update Data'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        }
    );
  }
  final Stream<QuerySnapshot> _languageStream =
      FirebaseFirestore.instance.collection('languages').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parogramming language"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>WriteData(context),
        child: Icon(
          Icons.add
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _languageStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Center(child: Text('Something went wrong'));
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: Text("Loading"));
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document){
              Map<String, dynamic> data=
                  document.data()! as Map<String, dynamic>;
              return Stack(
                children: [
                  Card(
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Image.network(
                            data['icon'],
                            height: 200,
                          ),
                          Text(
                            data['name'],
                            style: TextStyle(
                              fontSize: 40
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      color: Colors.grey,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: ()=>updatedData(context,document.id),
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: (){
                              firestore
                              .collection('languages')
                                  .doc(document.id)
                                  .delete()
                                  .then((value) => Fluttertoast.showToast(
                                  msg:'deleted successfully'
                              )).catchError((error)=>Fluttertoast.showToast(msg: error));
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList()
          );
        },

      ),
    );
  }
}
