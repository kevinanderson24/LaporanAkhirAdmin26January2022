import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class UpdateProduct extends StatefulWidget {
  final Product value;
  const UpdateProduct({ Key key, this.value}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<UpdateProduct> {
  final _formkey = GlobalKey<FormState>();//formkey
  File image;
  final imagePicker = ImagePicker();
  String currentUrl;
  String newURL;
  String fileName;
  CollectionReference products = Firestore.instance.collection('product');
  Product productModel;

  TextEditingController _nameProductController;
  TextEditingController _priceProductController;
  TextEditingController _descriptionProductController;
  TextEditingController _idProductController;//controller

  Future checkForm() async {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      if(newURL == null){
        updateDataWithoutImageChanges();
      }else{
        uploadImageToFirebaseStorage();
      }
    }else{
      Fluttertoast.showToast(
        msg: "All field must be filled!",
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,       
      );
    }
  }

  //ambil gambar dari gallery
  pickImage() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = File(pick.path);
    });
  }

  //uploading the image to "Storage" in Firebase, then getting the download url and then
  //adding that download url to our "Firestore database" in Firebase
  Future uploadImageToFirebaseStorage() async {
    fileName = basename(image.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child('product/$fileName');
    StorageUploadTask uploadTask = ref.putFile(image);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    newURL = await snapshot.ref.getDownloadURL();
    updateDataWithImageChanges();
    print(newURL);
  }


  Future updateDataWithoutImageChanges() async {
    products.document(_idProductController.text).updateData({
      'name': _nameProductController.text,
      'price': int.parse(_priceProductController.text),
      'description': _descriptionProductController.text,
    });
  }

  Future updateDataWithImageChanges() async {
    products.document(_idProductController.text).updateData({
      'name': _nameProductController.text,
      'price': int.parse(_priceProductController.text),
      'description': _descriptionProductController.text,
      'url': newURL,
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idProductController = TextEditingController(text: "${widget.value.id}");
    _nameProductController = TextEditingController(text: "${widget.value.name}");
    _priceProductController = TextEditingController(text: "${widget.value.price}");
    _descriptionProductController = TextEditingController(text: "${widget.value.description}");
    currentUrl = "${widget.value.url}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Update Product", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formkey,
        autovalidateMode: AutovalidateMode.always,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Column(
              children: [
                Container(
                  height: 300.0,
                  child: InkWell(
                    onTap: () {
                      //KETIKA GAMBAR DIKLIK
                      pickImage();
                    },
                    child:
                      (image != null)
                      ? Image.file(
                        image,
                        fit: BoxFit.cover,

                      )
                      : Image.network(currentUrl)
                  )
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _idProductController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text('Product Id'),
                  ),
                  // validator: (value) {
                  //   if(value.isEmpty){
                  //     return ("Id cannot be empty");
                  //   }
                  //   return null;
                  // },
                  readOnly: true,
                  onSaved: (newValue) => _idProductController.text = newValue,
                ),
                TextFormField(
                  controller: _nameProductController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text('Product Name'),
                  ),
                  // validator: (value) {
                  //   if(value.isEmpty){
                  //     return ("Name cannot be empty");
                  //   }
                  //   return null;
                  // },
                  // onSaved: (newValue) => _nameProductController.text = newValue,
                ),
                TextFormField(
                  controller: _priceProductController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text('Product Price'),
                  ),
                  validator: (value) {
                    if(value.isEmpty){
                      return ("Price cannot be empty!");
                    }
                    return null;
                  },
                  onSaved: (newValue) => _priceProductController.text = newValue,
                ),
                TextFormField(
                  controller: _descriptionProductController,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    label: Text('Product Desciption'),
                  ),
                  // validator: (value) {
                  //   if(value.isEmpty){
                  //     return ("Description cannot be empty!");
                  //   }
                  // },
                  onSaved: (newValue) => _descriptionProductController.text = newValue,
                ),
                SizedBox(
                  height: 20,
                ),
                Material(
                  elevation: 30,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue[900],
                  child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
                      checkForm();
                      uploadImageToFirebaseStorage();
                      Navigator.pop(context);
                    },   
                    child: Text(
                      "Submit",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white)
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}