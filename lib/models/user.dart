class User {
  int? id;
  final String name;
  final String imageUrl;
  final String email;

  User({
    this.name = "",
    this.imageUrl = "https://cdn.pixabay.com/user/2013/11/05/02-10-23-764_250x250.jpg",
    this.id,
    this.email = "",
  });
  
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
      "email": email,
    };
  }
}