// api 호출 url
const String _baseUrl = "https://daelim-server.fleecy.dev/functions/v1";
const String getTokenUrl = '$_baseUrl/auth/get-token';
const String getUserDataUrl = '$_baseUrl/auth/my-data';
const String setProfileImageUrl = '$_baseUrl/auth/set-profile-image';

const String _storagePublicUrl =
    'https://daelim-server.fleecy.dev/storage/v1/object/public';

// 아이콘 url
const String icGoogle = "$_storagePublicUrl/icons/google.png";
const String icApple = "$_storagePublicUrl/public/icons/apple.png";
const String icGithub = "$_storagePublicUrl/icons/github.png";
//기본 이미지
const String defulatImg = "$_storagePublicUrl/icons/user.png";
