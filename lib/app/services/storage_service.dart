import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadMedia(File file) async{
    UploadTask uploadTask= firebaseStorage
        .ref('images')
        .child(
            '${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}')
        .putFile(file);
    uploadTask.asStream().listen((event) { });
    TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => null);
    String url=await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}
