class HelperFunctions{
  static String getConvoId(String uid, String pid){
    return uid.hashCode <= pid.hashCode ? '${uid}_$pid' : '${pid}_$uid';
  }
}