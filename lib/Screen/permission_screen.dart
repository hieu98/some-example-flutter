import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.mic),
                ),
                onTap: () async{
                  PermissionStatus microphoneStatus = await Permission.location.request();
                  if(microphoneStatus == PermissionStatus.granted){
                    
                  }
                  if(microphoneStatus == PermissionStatus.denied){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("This permission is recommended.")));
                  }
                  if(microphoneStatus ==  PermissionStatus.permanentlyDenied){
                    openAppSettings();
                  }
                  
                },
                title: Text('Microphone Permission'),
                subtitle: Text('Status of Permission'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
