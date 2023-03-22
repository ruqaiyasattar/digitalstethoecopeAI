



import 'package:permission_handler/permission_handler.dart';



class PermissionsHelper{


  ///Check and request/if permanently denied make easy for user to access phone settings
  ///to allow audio Recording Permissions
  checkAndRequestForAudioRecordingPermission()async{
    await Permission.audio.status.then((value){
       if(value.isDenied){
         ///Ask because it means permission hasn't yet being requested or the permission
         ///has been denied before but not permanently.
         requestForAudioRecordingPermission();

       }else if(value.isRestricted){
         ///Ask because sometimes its from OS restrictions or parental controls
         requestForAudioRecordingPermission();

       }else if(value.isPermanentlyDenied){
         ///You will not be allowed to ask because user opted to never see the permission
         ///request dialog for this app. The only way to change the permission's status now
         ///is to let the user manually enable it in the system settings.
         openAppSettings();
       }
    });

  }


  ///Request for audio Permisssions
  requestForAudioRecordingPermission()async{
    await Permission.audio.request();
  }



}