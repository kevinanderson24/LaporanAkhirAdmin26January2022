import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/Model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class AddProduct extends StatefulWidget {
  const AddProduct({key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formkey = GlobalKey<FormState>(); //formkey
  CollectionReference collectionReference =
      Firestore.instance.collection('product');
  final TextEditingController nameController =
      new TextEditingController(); //controller
  final TextEditingController priceController =
      new TextEditingController(); //controller
  final TextEditingController descriptionController =
      new TextEditingController(); //controller
  final TextEditingController idController =
      new TextEditingController(); //controller

  File image;
  final imagePicker = ImagePicker();
  String fileName;
  String downloadURL;

  //image picker
  Future pickImage() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        image = File(pick.path);
      }
    });
  }

  checkForm(BuildContext context) {
    final key = _formkey.currentState;
    if(key.validate() && image != null){
      uploadImageToFirebaseStorage(context).whenComplete(() {
          // setState(() {
          //   image = null;
          // });
          // idController.text = '';
          // nameController.text = '';
          // priceController.text = '';
          // descriptionController.text = '';
      });
    }else if(key.validate() == true && image == null){
      Fluttertoast.showToast(
        msg: "Image must be selected",
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,       
      );
    }else{
      Fluttertoast.showToast(
        msg: "Id, Name, Price and Description cannot be empty, image must be selected!",
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,       
      );
    }
  }

  // checkExistsProduct(BuildContext context) async {
  //   QuerySnapshot snapshot = await collectionReference.getDocuments();

  //   // // snapshot.documents.

  //   snapshot.documents.forEach((document) {
  //     if(document.data['name'] == nameController.text){
  //       Fluttertoast.showToast(msg: "Product exists already!");
        
  //     }else{
  //       checkForm(context);
  //     }
  //   });
  // }

  //uploading the image, then getting the download url and then
  //adding that download url to our cloud Firestore
  uploadImageToFirebaseStorage(BuildContext context) async {
    fileName = basename(image.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child('product/$fileName');
    StorageUploadTask uploadTask = ref.putFile(image);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    downloadURL = await snapshot.ref.getDownloadURL();
    addDataProduct(context);
    // print(downloadURL); //url will be show on terminal
  }

  //send details (productname, productprice, url) to firestore
  addDataProduct(BuildContext context) async {
    Product productModel = Product();

    //writing all the values
    productModel.name = nameController.text;
    productModel.id = idController.text;
    productModel.price = int.tryParse(priceController.text);
    productModel.description = descriptionController.text;
    productModel.url = downloadURL;

    await collectionReference
        .document(idController.text)
        .setData(productModel.toMap());

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added successfully!"), backgroundColor: Colors.greenAccent));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Add Product", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(300, 20, 300, 20),
          child: Column(
            children: [
              Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    //------------------------ ID ---------------------------//
                    TextFormField(
                      controller: idController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Product Id',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if(value.isEmpty){
                          return ("Id is required");
                        }
                        return null;
                      },
                      onSaved: (newValue) => idController.text = newValue,
                    ),
                    SizedBox(height: 10),
                    //------------------ NAME ------------------------------------//
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Product Name',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if(value.isEmpty){
                          return ("Name is required");
                        }
                        return null;
                      },
                      onSaved: (newValue) => nameController.text = newValue,
                    ),
                    SizedBox(height: 10),
                    //------------------------- PRICE -------------------------------//
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Product Price',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if(value.isEmpty){
                          return ("Price is required");
                        }
                        return null;
                      },
                      onSaved: (newValue) => priceController.text = newValue,
                    ),
                    SizedBox(height: 10),
                    //---------------------- DESCRIPTION------------------------------//
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Product Description',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if(value.isEmpty){
                          return ("Description is required");
                        }
                        return null;
                      },
                      onSaved: (newValue) => descriptionController.text = newValue,
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        children: [
                          (image != null)
                          ? Image.file(
                            image,
                            width: 200,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            width: 200,
                            height: 180,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: Colors.black)
                            ),
                            child: Text("No Image Selected", style: TextStyle(fontSize: 12)),
                          ),
                          SizedBox(width: 20),
                          Container(
                            width: 170,
                            child: ElevatedButton.icon(
                              label: Text(
                                "Select Image", 
                                textAlign: TextAlign.center, 
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              icon: Icon(Icons.add_photo_alternate),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.greenAccent, //background color
                                onPrimary: Colors.white, //foreground color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.centerLeft
                              ),
                              onPressed: () {
                                pickImage();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue[900],
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 100,
                        onPressed: (){
                          checkForm(context);
                        },
                        child: Text(
                          "Submit",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
