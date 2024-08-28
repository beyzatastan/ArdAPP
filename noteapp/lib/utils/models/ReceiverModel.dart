

class ReceiverModel {
  final String receiverId;

  ReceiverModel
  ({
    required this.receiverId,
  });

  //map e cevir 
  Map<String,String> toMap(){
    return {
      "receiverId":receiverId,
    };
  }

}