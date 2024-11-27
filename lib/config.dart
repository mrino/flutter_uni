class Config {
  static const String _baseFuctionUrl =
      "https://daelim-server.fleecy.dev/functions/v1";
  static const _storagePublicUrl =
      'https://daelim-server.fleecy.dev/storage/v1/object/public';

  static const icon = (
    icGoogle: "$_storagePublicUrl/icons/google.png",
    icApple: "$_storagePublicUrl/icons/apple.png",
    icGithub: "$_storagePublicUrl/icons/github.png",
  );

  static const image = (
    defulatImg: "$_storagePublicUrl/icons/user.png", //
  );

  static const api = (
    getTokenUrl: '$_baseFuctionUrl/auth/get-token',
    getUserDataUrl: '$_baseFuctionUrl/auth/my-data',
    setProfileImageUrl: '$_baseFuctionUrl/auth/set-profile-image',
    changePasswordUrl: '$_baseFuctionUrl/auth/reset-password',
    getUserList: '$_baseFuctionUrl/users',
    createRoom: '$_baseFuctionUrl/chat/room/create',
    chatRoom: '$_baseFuctionUrl/chat/room/:userid'
  );
}
