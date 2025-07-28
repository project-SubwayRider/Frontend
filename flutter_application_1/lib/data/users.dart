class User {
  final String id;
  final String name;
  final String nickname;
  final String password;
  final String birth;
  final String startStation;
  final String endStation;
  final String phone;
  final String imagePath;
  final String address;

  User({
    required this.id,
    required this.name,
    required this.nickname,
    required this.password,
    required this.birth,
    required this.startStation,
    required this.endStation,
    required this.phone,
    required this.imagePath,
    required this.address,
  });

  // ✅ 오류 해결: 빈 유저 팩토리 생성자
  factory User.empty() {
    return User(
      id: '',
      name: '',
      nickname: '',
      password: '',
      birth: '',
      startStation: '',
      endStation: '',
      phone: '',
      imagePath: '',
      address: '',
    );
  }
}

// ✅ 예시 유저 리스트 (파일로부터 로딩한다면 여기서 로딩하도록 수정 가능)
List<User> userList = [
  User(
    id: 'test01',
    name: '홍길동',
    nickname: '길동이',
    password: '1234',
    birth: '1990-01-01',
    startStation: '강남역',
    endStation: '잠실역',
    phone: '010-1234-5678',
    imagePath: 'assets/profile.jpg',
    address: '서울시 강남구',
  ),
];
