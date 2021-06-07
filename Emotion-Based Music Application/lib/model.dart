class SongModel {
   String songName;
   String songUrl;
   String songInterest;
  String songType;

  SongModel(
      { this.songName,
        this.songUrl,
         this.songInterest,
         this.songType
      });

  SongModel.fromJson(Map<String, dynamic> json) {
    songName= json['song name'];
    songUrl = json['songurl'];
    songInterest = json['interest'];
    songType = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['song name'] = this.songName;
    data['songurl'] = this.songUrl;
    data['interest'] = this.songInterest;
    data['type'] = this.songType;
    return data;
  }
}
