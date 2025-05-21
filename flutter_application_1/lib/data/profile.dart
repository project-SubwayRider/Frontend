class UserProfile {
  final String id;
  final String name;
  final String nickname;
  final String password;
  final String birthdate;
  final String startStation;
  final String endStation;
  final String mannerTemp;
  final String phoneNumber;
  final String profileImage;
  final String joinDate;
  final String address;

  UserProfile({
    required this.id,
    required this.name,
    required this.nickname,
    required this.password,
    required this.birthdate,
    required this.startStation,
    required this.endStation,
    required this.mannerTemp,
    required this.phoneNumber,
    required this.profileImage,
    required this.joinDate,
    required this.address,
  });
}

// 예시 유저 데이터
final UserProfile userProfile = UserProfile(
  id: 'chltjdghks80',
  name: '최성환',
  nickname: '위고비파이터',
  password: '••••••••',
  birthdate: '2000-04-21',
  startStation: '하계역&월계역',
  endStation: '영통역',
  mannerTemp: '12.34℃',
  phoneNumber: '010-2635-8036',
  profileImage: 'assets/profile.png',
  joinDate: '2025-06-03',
  address: '서울특별시 노원구 하계2동',
);
