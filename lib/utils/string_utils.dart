
class StringUtils {

  static List<String> stringToArray(String string,String formatLabel){
     if(string != null && formatLabel != null && string.contains(formatLabel)){
        List<String> array = string.split(formatLabel);
        return array ;
     }
     return [];
  }

  static dynamic trimValue(dynamic value){
     if(value is String && value.isNotEmpty){
        return value.trim();
     }
     return value;
  }

}