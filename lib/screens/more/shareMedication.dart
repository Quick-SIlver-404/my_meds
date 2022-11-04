import 'package:my_meds/utilities/db_helper.dart';
import 'package:share_plus/share_plus.dart';

  void shareMed()async{
    String names = await DBHelper.getMedicineNames();
    if (names.length == 0){
      names = 'No running medication';
    }
    ShareResult result;
    result = await Share.shareWithResult(names, subject: 'List of current Medications');
  // return result.status.toString();
}

