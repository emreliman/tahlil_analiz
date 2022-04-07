class Analysis {
  String islem_adi = "";
  String sonuc = "";
  String? sonuc_birimi;
  String referans_degeri = "";
  String tarih = "";
  String? ust_sinif;

  Analysis(this.islem_adi, this.sonuc, this.sonuc_birimi, this.referans_degeri,
      this.tarih, this.ust_sinif);

  Analysis.empty() {
    islem_adi = "";
    sonuc = "";
    sonuc_birimi = "";
    referans_degeri = "";
    tarih = "";
    ust_sinif = "";
  }

  Analysis.fromJson(Map<String, dynamic> json)
      : islem_adi = json['Islem_Adi'],
        sonuc = json['Sonuc'],
        sonuc_birimi = json['Sonuc_Birimi'],
        referans_degeri = json['Referans_Degeri'],
        tarih = json['Tarih'],
        ust_sinif = json['Ust_Sinif'];

  Map<String, dynamic> toJson() => {
    'Islem_Adi': islem_adi,
    'Sonuc': sonuc,
    'Sonuc_Birimi':sonuc_birimi,
    'Referans_Degeri':referans_degeri,
    'Tarih':tarih,
    'Ust_Sinif':ust_sinif
  };

// @override
// String toString() {
//   return "${this.islem_adi}";
// }
}
