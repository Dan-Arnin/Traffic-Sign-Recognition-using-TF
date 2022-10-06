import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:just_audio/just_audio.dart';

void main() async{
  runApp(App());
}

const String my_model = "mymodel";

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _MyAppState extends State<MyApp> {
  late AppState gallery_state = AppState.free;
  late AppState camera_state = AppState.free;
  late AudioPlayer player;

  File? _image;
  List? _recognitions;
  String _model = my_model;
  double? _imageHeight;
  double? _imageWidth;
  bool _busy = false;
  bool _isButtonDisabled = true;

  String _label = "";
  String _index = "";
  String _confidence = "";

  void _clearImage() {
    _image = null;
    setState(() {
      gallery_state = AppState.free;
      camera_state = AppState.free;
      _label = "";
      _index = "";
      _confidence = "";
      _isButtonDisabled = true;
    });
  }

  Future predictGalleryImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 200, maxHeight: 200);
    File imageFile = File(image!.path);
    if (imageFile == null) return;
    setState(() {
      _busy = true;
      _image = imageFile;
      _isButtonDisabled = false;
      gallery_state = AppState.picked;
      camera_state = AppState.free;
    });
  }

  Future predictCameraImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 200, maxHeight: 200);
    File imageFile = File(image!.path);
    if (imageFile == null) return;
    setState(() {
      _busy = true;
      _image = imageFile;
      _isButtonDisabled = false;
      camera_state = AppState.picked;
      gallery_state = AppState.free;
    });
  }

  Future predictImage(File image) async {
    if (image == null) {
      return;
    }

    await MY_MODEL(image);
    audio_play();
    FileImage(image)
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    camera_state = AppState.free;
    gallery_state = AppState.free;
    _isButtonDisabled = true;
    _label = "";
    _index = "";
    _confidence = "";
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  Future loadModel() async {
    Tflite.close();
    try {
      await Tflite.loadModel(
          model: "assets/my_model.tflite",
          labels: "assets/my_model.txt"
      );
    }
    catch(e)
    {
      print(e);
    }
  }

  Future MY_MODEL(File image) async {
    List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
    );
    setState(() {
      _recognitions = recognitions;
      _label = recognitions![0]['label'].toString();
      _index = recognitions[0]['index'].toString();
      _confidence = recognitions[0]['confidence'].toString();
    });
  }

  Future audio_play() async {
    if(_label=="Speed limit (20km/h)") {
      player.setAsset('assets/20.mp3');
      player.play();
    }
    else if(_label=="Speed limit (30km/h)") {
      player.setAsset('assets/30.mp3');
      player.play();
    }
    else if(_label=="Speed limit (50km/h)") {
      player.setAsset('assets/50km.mp3');
      player.play();
    }
    else if(_label=="Speed limit (60km/h)") {
      player.setAsset('assets/60km.mp3');
      player.play();
    }
    else if(_label=="Speed limit (70km/h)") {
      player.setAsset('assets/70km.mp3');
      player.play();
    }
    else if(_label=="Speed limit (80km/h)") {
      player.setAsset('assets/80km.mp3');
      player.play();
    }
    else if(_label=="End of speed limit (80km/h)") {
      player.setAsset('assets/End of speed limit 80km per hour.mp3');
      player.play();
    }
    else if(_label=="Speed limit (100km/h)") {
      player.setAsset('assets/Speed limit 100km per hour.mp3');
      player.play();
    }
    else if(_label=="Speed limit (120km/h)") {
      player.setAsset('assets/Speed limit 120km per hour.mp3');
      player.play();
    }
    else if(_label=="No passing") {
      player.setAsset('assets/No passing.mp3');
      player.play();
    }
    else if(_label=="No passing veh over 3.5 tons") {
      player.setAsset('assets/No passing for vehicles over 3.5 tons.mp3');
      player.play();
    }else if(_label=="Right-of-way at intersection") {
      player.setAsset('assets/Right-of-way at intersection.mp3');
      player.play();
    }
    else if(_label=="Priority road") {
      player.setAsset('assets/Priority road.mp3');
      player.play();
    }
    else if(_label=="Yield") {
      player.setAsset('assets/Yield.mp3');
      player.play();
    }
    else if(_label=="Stop") {
      player.setAsset('assets/Stop.mp3');
      player.play();
    }
    else if(_label=="No vehicles") {
      player.setAsset('assets/No vehicles.mp3');
      player.play();
    }
    else if(_label=="Veh > 3.5 tons prohibited") {
      player.setAsset('assets/No passing for vehicles over 3.5 tons.mp3');
      player.play();
    }else if(_label=="No entry") {
      player.setAsset('assets/No entry.mp3');
      player.play();
    }else if(_label=="General caution") {
      player.setAsset('assets/general caution.mp3');
      player.play();
    }else if(_label=="Dangerous curve left") {
      player.setAsset('assets/Dangerous curve left.mp3');
      player.play();
    }else if(_label=="Dangerous curve right") {
      player.setAsset('assets/Dangerous curve right.mp3');
      player.play();
    }else if(_label=="Double curve") {
      player.setAsset('assets/Double curve.mp3.mp3');
      player.play();
    }else if(_label=="Bumpy road") {
      player.setAsset('assets/Bumpy road.mp3');
      player.play();
    }else if(_label=="Slippery road") {
      player.setAsset('assets/Slippery road.mp3');
      player.play();
    }else if(_label=="Road narrows on the right") {
      player.setAsset('assets/Road narrows on the right.mp3');
      player.play();
    }else if(_label=="Road work") {
      player.setAsset('assets/Road work.mp3');
      player.play();
    }else if(_label=="Traffic signals") {
      player.setAsset('assets/Traffic signals.mp3');
      player.play();
    }else if(_label=="Pedestrians") {
      player.setAsset('assets/Pedestrians.mp3');
      player.play();
    }else if(_label=="Children crossing") {
      player.setAsset('assets/Children crossing.mp3');
      player.play();
    }else if(_label=="Bicycles crossing") {
      player.setAsset('assets/Bicycles crossing.mp3');
      player.play();
    }else if(_label=="Beware of ice/snow") {
      player.setAsset('assets/Beware of ice or snow.mp3');
      player.play();
    }else if(_label=="Wild animals crossing") {
      player.setAsset('Wild animals crossing.mp3');
      player.play();
    }else if(_label=="End speed + passing limits") {
      player.setAsset('assets/End speed and passing limits.mp3');
      player.play();
    }else if(_label=="Turn right ahead") {
      player.setAsset('assets/Turn right ahead.mp3');
      player.play();
    }
    else if(_label=="Turn left ahead") {
      player.setAsset('assets/Turn left ahead.mp3');
      player.play();
    }
    else if(_label=="Ahead only") {
      player.setAsset('assets/aheadonly.mp3');
      player.play();
    }
    else if(_label=="Go straight or right") {
      player.setAsset('assets/Go straight or right.mp3');
      player.play();
    }
    else if(_label=="Go straight or left") {
      player.setAsset('assets/Go straight or left.mp3');
      player.play();
    }
    else if(_label=="Keep right") {
      player.setAsset('assets/Keep right.mp3');
      player.play();
    }
    else if(_label=="Speed limit (100km/h)") {
      player.setAsset('assets/Speed limit 100km per hour.mp3');
      player.play();
    }
    else if(_label=="Keep left") {
      player.setAsset('assets/Keep left.mp3');
      player.play();
    }
    else if(_label=="Roundabout mandatory") {
      player.setAsset('assets/Roundabout mandatory.mp3');
      player.play();
    }
    else if(_label=="End of no passing") {
      player.setAsset('assets/End of no passing.mp3');
      player.play();
    }
    else if(_label=="End no passing veh > 3.5 tons") {
      player.setAsset('assets/No passing for vehicles over 3.5 tons.mp3');
      player.play();
    }
  }
  onSelect(model) async {
    setState(() {
      _busy = true;
      _model = model;
      _recognitions = null;
      _label = "";
      _index = "";
    });
    await loadModel();

    if (_image != null) {
      predictImage(_image!);
    } else {
      setState(() {
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_image == null) _isButtonDisabled=true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Recognition using ML'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: onSelect,
            itemBuilder: (context) {
              List<PopupMenuEntry<String>> menuEntries = [
                const PopupMenuItem<String>(
                  child: Text(my_model),
                  value: my_model,
                ),
              ];
              return menuEntries;
            },
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            label: "Remove Image",
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: const Icon(Icons.close_rounded),
            onTap: _clearImage,
          ),
          SpeedDialChild(
            label: "Camera",
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.camera_enhance_rounded),
            onTap: predictCameraImage,
          ),
          SpeedDialChild(
            label: "Gallery",
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: const Icon(Icons.image_search_rounded),
            onTap: predictGalleryImage,
          ),
        ],
      ),
      body:
      Stack(
        children: //stackChildren,
        <Widget>[
          Positioned(
            bottom: 55.0,
            left: 100,
            child:
            Transform.scale(
              scale: 2.5,
              child:
              ElevatedButton(
                onPressed: _isButtonDisabled ? null : ()=> predictImage(_image!),
                child: const Text("Classify"),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 30,
            child:Container(
              margin: const EdgeInsets.all(40.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.circular(16),
              ),
              width: 200,
              height: 200,
              child: _image == null ? Image.asset("assets/no_selection.png") : Image.file(_image!),
            ),
          ),
          Positioned(
            top: 300,
            left: 50,
            child:
            Text(_label != null ? 'Label = $_label' : "Empty"),
          ),
          Positioned(
            top: 320,
            left: 50,
            child:
            Text(_index != null ? 'index = $_index' : "Empty",),
          ),
          Positioned(
            top: 340,
            left: 50,
            child:
            Text(_confidence != null ? 'confidence = $_confidence' : "Empty"),
          ),
        ],
      ),
    );
  }
}