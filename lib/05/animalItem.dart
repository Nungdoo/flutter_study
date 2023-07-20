class Animal {
  String? imagePath;
  String? animalName;
  String? kind;
  bool? flyExist = false;

  // Animal 객체를 생성할 때 전달받은 동물 정보가 각각의 매개변수에 대입됨
  // required : 함수를 호출할 때 꼭 전달해야 하는 값
  Animal({
    required this.animalName,
    required this.kind,
    required this.imagePath,
    this.flyExist
  });
}