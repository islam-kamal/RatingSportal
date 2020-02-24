import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reviewers/Assisant/AppbarComponents.dart';
import 'package:reviewers/UI/ThanksMessage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';

import 'Home.dart';
class ComplainPage extends StatefulWidget {
  var branch_id;
  ComplainPage({this.branch_id});
  @override
  State<StatefulWidget> createState() {
    return _ComplainPageState(branch_id);
  }
}

class _ComplainPageState extends State<ComplainPage> {
  var branch_id;
  _ComplainPageState(branch_id){
    this.branch_id=branch_id;
  }
  var _type;
  final _formKey = GlobalKey<FormState>();
  FileType _pickType = FileType.AUDIO;
  String _extension;
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  String path;
  StorageReference storageRef;
  String url;
  //upload audio file to firebase
  uploadToFirebase() {
    print('1');
    /* if (_multiPick) {
      _paths.forEach((fileName, filePath) => {upload(fileName, filePath)});
      print('1-1');
    } else {
      print('2');*/
    String fileName = path.split('/').last;
    String filePath = path;
    upload(fileName, filePath);
    print('3');
  }

  upload(fileName, filePath) {
    print('4');
    _extension = fileName.toString().split('.').last;
    print('5');
    storageRef = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask uploadTask = storageRef.putFile(
      File(filePath),
      StorageMetadata(
        contentType: '$_pickType/$_extension',
      ),
    );
    print('6');
    setState(() {
      _tasks.add(uploadTask);
    });
    print('7');
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  //download audio file to firebase
  Future<void> downloadFile(StorageReference ref) async {
    print("download - 1");
    url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    print("download - 2");
    final File tempFile = File('${systemTempDir.path}/tmp.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    print("download - 3");
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    print("download - 4");
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    final String name = await ref.getName();
    final String path = await ref.getPath();
    print(
      'Success!\nDownloaded $name \nUrl: $url'
          '\npath: $path \nBytes Count :: $byteCount',
    );
  }

  bool _isRecording = false;
  bool _isPlaying = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  FlutterSound flutterSound;
  String _recorderTxt = '00:00:00';
  double _dbLevel;
  double slider_current_position = 0.0;
  double max_duration = 1.0;
  //Toggle button tindicate if it complain or suggestion
  List<bool> isSelected;

  TextEditingController _nameController=new TextEditingController();
  TextEditingController _emailController=new TextEditingController();
  TextEditingController _mobileController=new TextEditingController();
  TextEditingController _messageController=new TextEditingController();

  static var uri = "http://n5ba.com/Ratingsportal/";
  static BaseOptions options = BaseOptions(
      baseUrl: uri,
      responseType: ResponseType.plain,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        }
      });
  static Dio dio = Dio(options);
  Future<dynamic> SuggestionData(
      String customer_name, String text, String mobile, int type, String branch_id) async {
    try {
      Options options = Options(
        contentType: ContentType.parse('application/json'),
      );
      Response response = await dio.post('api/add_complaints_suggestions',
          data: {"customer_name": customer_name, "text": text, 'mobile': mobile, 'type':type,
            'branch_id':branch_id},
          options: options);

      print('response : ' + response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        return responseJson;
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect Phone/Password");
      } else
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }
  @override
  void initState() {
    super.initState();
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();

    isSelected=[true,false];
  }
  void startRecorder() async {
    try {
      path = await flutterSound.startRecorder(null);
      print('startRecorder: $path');

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'pt_BR').format(date);

        this.setState(() {
          this._recorderTxt = txt.substring(0, 8);
        });
      });
      _dbPeakSubscription =
          flutterSound.onRecorderDbPeakChanged.listen((value) {
            print("got update -> $value");
            setState(() {
              this._dbLevel = value;
            });
          });

      this.setState(() {
        this._isRecording = true;
      });
    } catch (err) {
      print('startRecorder error: $err');
    }
  }
  void stopRecorder() async {
    try {
      String result = await flutterSound.stopRecorder();
      print('stopRecorder: $result');

      //use firebase to store audio
      uploadToFirebase();

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }

      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        leading:  new IconButton(
            icon: Icon(Icons.home),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(branch: branch_id,)));
            }
        ),
        title: AppComponents.HeaderTitle('المقترحات و الشكاوى'),

        centerTitle: true,
      ),
      body: new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 20.0,right: 20.0,),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/background.png'),
          fit: BoxFit.cover,
        )),

        child: new SafeArea(
          child: SingleChildScrollView(
            child: Form(
               key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                textDirection: TextDirection.rtl,
                children: <Widget>[

                  Container(
                    child:  ToggleButtons(
                      borderColor: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      fillColor: Colors.grey,
                      selectedColor: Colors.white,
                      selectedBorderColor: Colors.black,
                      borderWidth: 2,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left:20,right:20),
                          child: new Text('الشكاوى '
                            ,style: TextStyle(fontSize: 16),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:20,right:20),
                          child: Text('الاقتراحات',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                      onPressed: (int index){
                        setState(() {
                          for(int i=0;i<isSelected.length;i++){
                            isSelected[i]=i==index;
                          }
                        });
                        if(index==0){
                          setState(() {
                            _type=2;
                          });

                        }
                        else{
                          setState(() {
                            _type=1;
                          });
                        }
                      },
                      isSelected: isSelected,
                    ),
                    alignment: Alignment.center,
                  ),
                  Text(
                    'الأسم ',
                    style: TextStyle(
                      color: Colors.black,
                    ),

                  ),
                  new Container(
                    height: 50.0,
                    child: TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.black,),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Text(
                    'البريد الالكترونى',
                    style: TextStyle(
                        color: Colors.black,
                        ),
                  ),
                  new Container(
                    height: 50.0,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black,),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Text(
                    ' الموبايل  ',
                    style: TextStyle(
                        color: Colors.black,

                    ),
                  ),
                  new Container(
                    height: 50.0,
                    child: TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black,),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter phone';
                        }
                        return null;
                      },
                    ),
                  ),
                  Text(
                    '  التفاصيل  ',
                    style: TextStyle(
                        color: Colors.black,
                    ),
                  ),
                  TextFormField(
                    controller: _messageController,
                    style: TextStyle(color: Colors.black,),
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.multiline,
                    maxLines: 7,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your message';
                      }
                      return null;
                    },
                  ),
                  // use Builder to solve Scaffold.of() called with a context that does not contain a Scaffold Exception
                  Builder(
                    builder: (ctx) => new Container(
                        padding: EdgeInsets.only(top: 25.0,right: 25),
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _isRecording?Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 5),
                                  child: Text(
                                    this._recorderTxt,
                                    style: TextStyle(
                                      fontSize: 28.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ):new Container(),
                                _isRecording
                                    ? LinearProgressIndicator(
                                  value: 100.0 / 160.0 * (this._dbLevel ?? 1) / 100,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                  backgroundColor: Colors.red,
                                )
                                    : Container()
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width/3,
                                  child: RaisedButton(
                                    padding: const EdgeInsets.all(5.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                    ),
                                    color: Colors.blue,
                                    child: Text(
                                      'ارسال',
                                      style: TextStyle(
                                        color: Colors.white,

                                      ),
                                    ),
                                    onPressed: () async {
                                      print('type : $_type');
                                     int _typeValue= (_type==1)?1:2;
                                      // Validate returns true if the form is valid, or false otherwise.
                                      if (_formKey.currentState.validate()) {
                                        // If the form is valid, write your code to send messag If the form is valid, display a Snackbar.
                                    //   var type=(_type==0)?0:1;
                                        var res = await SuggestionData(
                                          _nameController.text.trim(),
                                          _messageController.text.trim(),
                                          _mobileController.text.trim(),
                                            _typeValue, // complain not work because type send by zero which consider null so ezz will change it
                                             branch_id
                                        );
                                        var status = res['status'];
                                        try {
                                          if (status == true) {
                                            //navigate to home screen and pass branch_id from login to home
                                            Navigator.of(context).push(
                                                MaterialPageRoute<Null>(builder:
                                                    (BuildContext context) {
                                                  return new ThanksMessage(branch_id);
                                                }));
                                            print('navigation done sucess');
                                          } else {
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Wrong email or")));
                                          }
                                        } on Exception catch (_) {
                                          throw Exception("Error on server");
                                        }





                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ThanksMessage(branch_id)));
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: FloatingActionButton(
                                    heroTag: "start_record",
                                    onPressed: () {

                                      if (!this._isRecording) {
                                        return this.startRecorder();
                                      }
                                      this.stopRecorder();
                                    },
                                    child:
                                    this._isRecording ? Icon(Icons.stop) : Icon(Icons.mic),


                                  ),
                                )
                              ],
                            ),
                          ],
                        ),

                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
     // endDrawer: AppComponents.DrawerMenu(context),
    );
  }
}
