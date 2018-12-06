#!/bin/bash
id_set(){
id=`awk 'BEGIN{i=1}
{
 printf"ids="i";";
 i++;
}'<"hartadb.txt"`;
eval "$id";
}
penjelasan_anak(){
clear;
echo "================PENJELASAN PEMBAGIAN HARTA WARIS ANAK ================"
echo " Penjelasan Singkat Pembagian Harta waris anak: "
printf " - Jika Mayit hanya meninggalkan 1 anak Perempuan saja, maka Maka anak PRP Tsb Mendapatakan 1/2 bagian\n\n "
printf " - Jika Mayit hanya meninggalkan Lebih dari 1 anak Perempuan saja, maka Maka mereka mendapatkan Mendapatakan 2/3 bagian Harta dibagi bersama\n\n "
printf " - Jika Mayit hanya meninggalkan 1 anak Laki Laki, maka Maka anak laki2 Tsb Mendapatakan Semua Bagian Harta \n\n "
printf " - Jika Mayit hanya meninggalkan lebih dari 1 anak Laki Laki, maka Maka mereka Tsb Mendapatakan Semua Bagian Harta dibagi bersama \n\n "
printf " - Jika Mayit hanya meninggalkan anak laki dan perempuan, maka anak laki kai mendatkan bagian 2 kali nya bagian perempuan\n"
printf "=====================================================================\n\n"
}

penjelasan_orang_tua(){
clear;
echo "================PENJELASAN PEMBAGIAN HARTA WARIS ORANG TUA ================"
echo " Penjelasan Singkat Pembagian Harta waris anak: "
printf " - Jika Mayit tidak Meninggalkan anak, dan hanya meninggalkan ayah, maka ayah mewaris semua harta yang ditinggalkan mayit \n\n"
printf " - Jika Mayit tidak meninggalkan anak, tapi meninggalkan ayah dan ibu, maka ibu mendapatkan 1/3 bagian untuk bersama, dan ayah mendapatkan sisanya \n\n"
printf " - Jika Mayit hanya meninggalkan anak (laki laki/prp), maka: \n"
printf " \t- ayah mendapatkan 1/6 dari harta waris\n"
printf " \t- Ibu mendapatkan 1/6 dari harta waris\n"
printf " \t- sisanya untuk anak, dengan pembagian: Anak laki laki mendapatkan\n\t2 kali bagian nya anak perempuan\n"
printf "=====================================================================\n\n"
}

penjelasan_suami_istri(){
clear;
echo "================PENJELASAN PEMBAGIAN HARTA WARIS SUAMI ISTRI ================"
echo " Penjelasan Singkat Pembagian Harta waris anak: "
printf " - Jika Mayit tidak Meninggalkan anak, maka suami mendapatkan 1/2 dari seluruh harta, dan Istri mendapatkan 1/4 dari seluruh harta\n\n"
printf " - Jika Mayit tidak meninggalkan anak, maka suami mendapatkan 1/4 dari seluruh harta, dan istri mendapatkan 1/8 dari seluruh harta\n\n"
printf " ========================TERDAPAT PENGECUALIAN ============================\npada saat keluarga yang ditinggal adalah:\n"
printf " \t- ayah\n"
printf " \t- Ibu mendapatkan 1/6 dari harta waris\n"
printf " \t- ayah\n"
printf "Maka pada saat itu, yang seharusnya ibu mendapatkan 1/3 dari seluruh harta. dan ayah mendapatkan sisanya, hal ini kemudian di rubah dengan pembagian:\n"
printf " \t- istri dan suami mendapatkan bagian seperti biasa (1/2 atau 1/4 atau 1/8) \tseperti penjelesan di atas\n"
printf " \t- Ibu mendapatkan harta waris 1/3 dari HARTA sisa nya (BUKAN HARTA SELURUHNYA)\n"
printf " \t- ayah mendapatkan sisa harta setelah diambil oleh istri dan ibu\n"
printf "=====================================================================\n\n"
}
add_data(){
data=$(zenity --forms --title="Tambah Catatan Aset" --text="Silahkan Tambahkan aset anda" --separator=" " \
 --add-entry="Nama Aset"\
 --add-entry="Jenis Aset"\
 --add-entry="Debit"\
 --add-entry="Kredit") 
if [ $? -eq 1 ]; then
 main;
fi
id_set;
echo $data > hartadb_sem.txt
namaaset=$(awk '{print $1}' hartadb_sem.txt)
jenisaset=$(awk '{print $2}' hartadb_sem.txt)
debit=$(awk '{print $3}' hartadb_sem.txt)
kredit=$(awk '{print $4}' hartadb_sem.txt)
saldoawal=`awk 'END{print}' hartadb.txt | awk '{print $6}'`

saldo=`echo "scale=2;$saldoawal+$kredit-$debit" |bc`



echo "aset$((ids+1)) "$namaaset" "$jenisaset" "$debit" "$kredit" "$saldo >> hartadb.txt
lihat_data;

}

delete_data(){
zenity --question --text "Anda yakin ingin membatalkan input aset terakhir";
if [ $? -eq 0 ];
then
banding=`cat hartadb.txt | wc -l`;
echo "$(sed -i "$banding d" hartadb.txt)";
echo $banding
benar=$(zenity --info --title "Sukses" --text "Data Dihapus");
exit
fi
}

lihat_data(){
data=`awk 'BEGIN{FS=" ";i=0}
{
 printf "a["i"]="$1"; a["i+1"]="$2"; a["i+2"]="$3"; a["i+3"]="$4"; a["i+4"]="$5"; a["i+5"]="$6";";
 i+=6; 
}' < "hartadb.txt"`;
 eval "$data" ; #loop
 zenity --list --width 500 --height 500 --title "Aset Harta Anda" --text "Jumlah total aset anda" \
   --column "Id" --column "Nama Aset" --column "Jenis Aset" --column "Debit" --column "Kredit" --column "Total Aset" "${a[@]}"; 
main;
}


database() {
pilihan=`zenity --list --height 234 --width 280 --title "DATABASE HARTA" --text "\t\t\t\  Pilih Menu" --column "Menu" "Lihat Database" "Add Database" "Batalkan Input Terakhir" "Menu Utama" "Keluar"`

if [ "$pilihan" == "Add Database" ]
  then
   add_data;
elif [ "$pilihan" == "Batalkan Input Terakhir" ]
  then
   delete_data;
elif [ "$pilihan" == "Lihat Database" ]
  then
   lihat_data;
elif [ "$login" == "Menu Utama" ]
  then
   main;
elif [ "$login" == "Keluar" ]
  then
   exit
fi


}

dalil() {
pilih=`zenity --list --height 234 --width 280 --title "Silahkan Pilih Penjelesan" --text "\t\t\t\  Pilih Menu" --column "Keterangan Waris" "Penjelasan Waris Anak" "Penjelasan Waris Orang Tua" "Penjelasan Waris Suami Istri" "Menu Utama" "Keluar"`

if [ "$pilih" == "Penjelasan Waris Anak" ]
  then
   penjelasan_anak;
   zenity --info --text "Terima Kasih, Penjelasan Waris Anak bisa dilihat di Console"
   main;
elif [ "$pilih" == "Penjelasan Waris Orang Tua" ]
  then
   penjelasan_orang_tua;
   zenity --info --text "Terima Kasih, Penjelasan Waris Orang Tua bisa dilihat di Console"
   main;
elif [ "$pilih" == "Penjelasan Waris Suami Istri" ]
  then
   penjelasan_suami_istri;
   zenity --info --text "Terima Kasih, Penjelasan Waris Suami Istri bisa dilihat di Console"
   main;
elif [ "$pilih" == "Menu Utama" ]
  then
   main;
elif [ "$pilih" == "Keluar" ]
  then
   exit
else 
   echo "Program Error"
fi
}

hitung() {

data=$(zenity --forms --title="PERHITUNGAN FAROID" --text="Silahkan inputkan anggota keluarga yang ditinggalkan mayit" --separator=" "\
  --add-entry="Nilai Aset Harta"\
  --add-entry="Jumlah anak Laki laki "\
  --add-entry="Jumlah anak perempuan "\
  --add-entry="jika ada ayah input 1 "\
  --add-entry="Jumlah Ibu "\
  --add-entry="Jika ada Suami Input 1 "\
  --add-entry="Jumlah Istri ")
echo $data > inputfaroid.txt

uang=$(awk '{print $1}' inputfaroid.txt)
lakilaki=$(awk '{print $2}' inputfaroid.txt)
perempuan=$(awk '{print $3}' inputfaroid.txt)
ayah=$(awk '{print $4}' inputfaroid.txt)
ibu=$(awk '{print $5}' inputfaroid.txt)
suami=$(awk '{print $6}' inputfaroid.txt)
istri=$(awk '{print $7}' inputfaroid.txt)


##### ALOGARITMA PERHITUNGAN HARTA WARIS ANAK
if [ "$perempuan" = 0 -a "$lakilaki" = 1 -a "$ayah" = 0 -a "$ibu" = 0 -a "$suami" = 0 -a "$istri" = 0 ]
  then
   penjelasan_anak;
   zenity --info --text "Anak tunggal laki laki mendapatkan semua harta\n\n Penjelasan ada di Console" 
elif [ "$perempuan" = 1 -a "$lakilaki" = 0 -a "$ayah" = 0 -a "$ibu" = 0 -a "$suami" = 0 -a "$istri" = 0 ]
  then
   penjelasan_anak;
   zenity --info --text "Anak tunggal perempuan mendapatkan 1/2 harta \n\n Penjelasan ada di Console" 
   
elif [ "$perempuan" -gt 1 -a "$lakilaki" = 0 -a "$ayah" = 0 -a "$ibu" = 0 -a "$suami" = 0 -a "$istri" = 0 ]
  then 
   hasil=`echo "scale=2;2/3/$perempuan" |bc`
   penjelasan_anak;
   zenity --info --text "Masing maing anak Perempuan mendapatkan $hasil bagian harta \n\n Penjelasan ada di Console" 
   
elif [ "$perempuan" = 0 -a "$lakilaki" -gt 1 -a "$ayah" = 0 -a "$ibu" = 0 -a "$suami" = 0 -a "$istri" = 0 ]
  then
   hasil=`echo "scale=2;1/$lakilaki" |bc`
   penjelasan_anak;
   zenity --info --text "Masing2 anak laki-laki mendapatkan $hasil bagian harta"
elif [ "$perempuan" -gt 0 -a "$lakilaki" -gt 0 -a "$ayah" = 0 -a "$ibu" = 0 -a "$suami" = 0 -a "$istri" = 0 ]
  then
   let kepalalaki=$lakilaki*2
   kepalaprp=$perempuan
   hasil=`echo "scale=2;1/($kepalalaki+$kepalaprp)" |bc`
   hasillaki=`echo "scale=2;$hasil*2" |bc`
   hasilprp=`echo "scale=2;$hasil" |bc`
   
   uanglaki=`echo "scale=2;$uang*$hasillaki" |bc`
   uangprp=`echo "scale=2;$uang*$hasilprp" |bc`
   penjelasan_anak;
   zenity --info --text "masing masing anak laki laki mendapatkan $uanglaki , masing masing anak prp mendapat $uangprp \n\n Penjelasan Ada di Console"

#### ALGORITMA PERHITUNGAN HARTA WARIS ORANG TUA &&& SUAMI ISTRI
  
elif [ "$perempuan" = 0 -a "$lakilaki" = 0 -a "$ayah" = 1 -a "$ibu" = 0 ]
  then
   if [ "$suami" -gt 0 -a "$istri" = 0  ]
   then
  	jatah_suami=`echo "scale=2;$uang/2" |bc`
  	sisa=`echo "scale=2;$uang-$jatah_suami" |bc`
  	zenity --info --text "Suami mendapatkan $jatah_suami, Ayah mendapatkan $sisa"
   elif [ "$suami" = 0 -a "$istri" -gt 0  ]
   then
  	jatah_istri=`echo "scale=2;$uang/4" |bc`
	jatah_istrifix= `echo "scale=2;$jatah_istri/$istri" |bc`
  	sisa=`echo "scale=2;$uang-$jatah_istri" |bc`
  	zenity --info --text "Istri mendapatkan $jatah_istri, Ayah mendapatkan $sisa"
   elif [ "$suami" -gt 0 -a "$istri" -gt 0  ]
   then  
  	jatah_istri=`echo "scale=2;$uang/4" |bc`
	jatah_istrifix= `echo "scale=2;$jatah_istri/$istri" |bc`
  	jatah_suami=`echo "scale=2;$uang/2" |bc`
  	sisa=`echo "scale=2;$uang-($jatah_istri+$jatah_suami)" |bc`
  	zenity --info --text "Istri mendapatkan $jatah_istri, suami mendapat $jatah_suami Ayah mendapatkan $sisa"
   elif [ "$suami" = 0 -a "$istri" = 0  ]
	then
   	penjelasan_orang_tua;
   	zenity --info --text "Ayah mendapatkan semua harta waris"
   fi
####ALGORITMA SEPERTIGA BAQII (IBU MENDAPATKAN sepertiga DARI SISA HARTA BUKAN SELURUH HARTA)......
elif [ "$perempuan" = 0 -a "$lakilaki" = 0 -a "$ayah" = 1 -a "$ibu" -gt 0 ]
  then
   if [ "$suami" -gt 0 -a "$istri" = 0  ]
   then
	jatah_suami=`echo "scale=2;$uang/2" |bc`
  	sisa=`echo "scale=2;$uang-$jatah_suami" |bc`
        jatah_ibu=`echo "scale=2;$sisa/3" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
        jatah_ayah=`echo "scale=2;$uang-($jatah_ayah+$jatah_ibu)" |bc`
  	zenity --info --text "Suami mendapatkan $jatah_suami, Ayah mendapatkan $sisa, Ibu mendapatkan $jatah_ibufix"
   elif [ "$suami" = 0 -a "$istri" -gt 0  ]
   then
    	jatah_istri=`echo "scale=2;$uang/4" |bc`
	jatah_istrifix=`echo "scale=2;$jatah_istri/$istri" |bc`
  	sisa=`echo "scale=2;$uang-$jatah_suami" |bc`
        jatah_ibu=`echo "scale=2;$sisa/3" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
        jatah_ayah=`echo "scale=2;$uang-($jatah_istri+$jatah_ibu)" |bc`
  	zenity --info --text "Istri mendapatkan $jatah_istrifix, Ayah mendapatkan $sisa, Ibu mendapatkan $jatah_ibufix"
   elif [ "$suami" -gt 0 -a "$istri" -gt 0  ]
   then
        jatah_istri=`echo "scale=2;$uang/4" |bc`
	jatah_istrifix=`echo "scale=2;$jatah_istri/$istri" |bc`
	jatah_suami=`echo "scale=2;$uang/2" |bc`
  	sisa=`echo "scale=2;$uang-($jatah_suami+$jatah_istri)" |bc`
        jatah_ibu=`echo "scale=2;$sisa/3" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
        jatah_ayah=`echo "scale=2;$uang-($jatah_suami+$jatah_istri+$jatah_ibu)" |bc`
  	zenity --info --text "Istri mendapatkan $jatah_istrifix, Suami mendapatkan $jatah_suami Ayah mendapatkan $sisa, Ibu mendapatkan $jatah_ibufix"
   elif [ "$suami" = 0 -a "$istri" = 0  ]
   then
   	jatahibu=`echo "scale=2;$uang/6" |bc`
   	jatahibu_fixed=`echo "scale=2;$jatahibu/$ibu" |bc`
   	sisa=`echo "scale=2;$uang-$jatahibu" |bc`
   	jatahayah_fixed=$sisa
   	penjelasan_orang_tua;
   	zenity --info --text "Ayah mendapatkan $jatahayah_fixed dan $ibu ibu masing2 mendapatkan $jatahibu_fixed"
   fi
elif [ "$perempuan" -gt 0 -a "$lakilaki" -gt 0 -a "$ayah" -gt 0 -a "$ibu" -gt 0 ]
  then
   if [ "$suami" -gt 0 -a "$istri" = 0  ]
   then
	jatah_suami=`echo "scale=2;$uang/4" |bc`
 	jatah_ayah=`echo "scale=2;$uang/6" |bc`
	jatah_ibu=`echo "scale=2;$uang/6" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
 	sisa=`echo "scale=2;$uang-($jatah_suami+$jatah_ayah+$jatah_ibu)" |bc`
	anaklaki_kpl=`echo "scale=2;$lakilaki*2" |bc`
	jatah_anak=`echo "scale=2;$sisa/($anaklaki_kpl+$perempuan)" |bc`
	jatah_laki=`echo "scale=2;$jatah_anak*2" |bc`
	jatah_prp=$jatah_anak
	zenity --info --text "Suami mendapatkan $jatah_suami Ayah mendapatkan $jatah_ayah, Ibu mendapatkan $jatah_ibufix, anak laki laki mendapatkan $jatah_laki, anak perempuan mendapatkan $jatah_prp"
   elif [ "$suami" = 0 -a "$istri" -gt 0  ]
   then
  	jatah_istri=`echo "scale=2;$uang/8" |bc`
	jatah_istrifix=`echo "scale=2;$jatah_istri/$istri" |bc`
 	jatah_ayah=`echo "scale=2;$uang/6" |bc`
	jatah_ibu=`echo "scale=2;$uang/6" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
 	sisa=`echo "scale=2;$uang-($jatah_istri+$jatah_ayah+$jatah_ibu)" |bc`
	anaklaki_kpl=`echo "scale=2;$lakilaki*2" |bc`
	jatah_anak=`echo "scale=2;$sisa/($anaklaki_kpl+$perempuan)" |bc`
	jatah_laki=`echo "scale=2;$jatah_anak*2" |bc`
	jatah_prp=$jatah_anak
	zenity --info --text "Istri mendapatkan $jatah_istrifix, Ayah mendapatkan $jatah_ayah, Ibu mendapatkan $jatah_ibufix, anak laki laki mendapatkan $jatah_laki, anak perempuan mendapatkan $jatah_prp"
   elif [ "$suami" -gt 0 -a "$istri" -gt 0  ]
   then
	jatah_suami=`echo "scale=2;$uang/4" |bc`
  	jatah_istri=`echo "scale=2;$uang/8" |bc`
	jatah_istrifix=`echo "scale=2;$jatah_istri/$istri" |bc`
 	jatah_ayah=`echo "scale=2;$uang/6" |bc`
	jatah_ibu=`echo "scale=2;$uang/6" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
 	sisa=`echo "scale=2;$uang-($jatah_suami+$jatah_istri+$jatah_ayah+$jatah_ibu)" |bc`
	anaklaki_kpl=`echo "scale=2;$lakilaki*2" |bc`
	jatah_anak=`echo "scale=2;$sisa/($anaklaki_kpl+$perempuan)" |bc`
	jatah_laki=`echo "scale=2;$jatah_anak*2" |bc`
	jatah_prp=$jatah_anak
	zenity --info --text "Istri mendapatkan $jatah_istrifix, Suami mendapatkan $jatah_suami Ayah mendapatkan $jatah_ayah, Ibu mendapatkan $jatah_ibufix, anak laki laki mendapatkan $jatah_laki, anak perempuan mendapatkan $jatah_prp"
   elif [ "$suami" = 0 -a "$istri" = 0  ]
   then
   	jatah_ibu=`echo "scale=2;$uang/6" |bc`
   	jatah_ibu_fixed=`echo  "scale=2;$jatah_ibu/$ibu" |bc`
   	jatah_ayah=$jatah_ibu
   	anaklakikpl=`echo "scale=2;$lakilaki*2" |bc`
   	anakprpkpl=$perempuan
   	jatahanak=`echo "scale=2;$uang-$jatah_ayah-$jatah_ibu" |bc`
   	jatah_anak=`echo "scale=2;$jatahanak/($anaklakikpl+$anakprpkpl)" |bc`
   	jatahlaki_fixed=`echo "scale=2;$jatah_anak*2" |bc`
   	jatahprp_fixed=$jatah_anak
   	zenity --info --text "Ayah mendapatkan $jatah_ayah, ibu mendapatkan $jatah_ibu, Anak laki2 mendapatkan     $jatahlaki_fixed anak perempuan mendapatkan $jatahprp_fixed"
   fi

elif [ "$perempuan" = 0 -a "$lakilaki" -gt 0 -a "$ayah" -gt 0 -a "$ibu" -gt 0 ]
  then
    if [ "$suami" -gt 0 -a "$istri" = 0  ]
    then
	jatah_suami=`echo "scale=2;$uang/4" |bc`
 	jatah_ayah=`echo "scale=2;$uang/6" |bc`
	jatah_ibu=`echo "scale=2;$uang/6" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
 	sisa=`echo "scale=2;$uang-($jatah_suami+$jatah_ayah+$jatah_ibu)" |bc`
	jatah_laki=`echo "scale=2;$sisa/$lakilaki" |bc`
	zenity --info --text "Suami mendapatkan $jatah_suami Ayah mendapatkan $jatah_ayah, Ibu mendapatkan $jatah_ibufix, anak laki laki mendapatkan $jatah_laki"
    elif [ "$suami" = 0 -a "$istri" -gt 0  ]
    then
  	jatah_istri=`echo "scale=2;$uang/8" |bc`
	jatah_istrifix=`echo "scale=2;$jatah_istri/$istri" |bc`
 	jatah_ayah=`echo "scale=2;$uang/6" |bc`
	jatah_ibu=`echo "scale=2;$uang/6" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
 	sisa=`echo "scale=2;$uang-($jatah_istri+$jatah_ayah+$jatah_ibu)" |bc`
	jatah_laki=`echo "scale=2;$sisa/$lakilaki" |bc`
	zenity --info --text "Istri mendapatkan $jatah_istrifix,Ayah mendapatkan $jatah_ayah, Ibu mendapatkan $jatah_ibufix, anak laki laki mendapatkan $jatah_laki"
    elif [ "$suami" -gt 0 -a "$istri" -gt 0  ]
    then
	jatah_suami=`echo "scale=2;$uang/4" |bc`
  	jatah_istri=`echo "scale=2;$uang/8" |bc`
	jatah_istrifix=`echo "scale=2;$jatah_istri/$istri" |bc`
 	jatah_ayah=`echo "scale=2;$uang/6" |bc`
	jatah_ibu=`echo "scale=2;$uang/6" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
 	sisa=`echo "scale=2;$uang-($jatah_suami+$jatah_istri+$jatah_ayah+$jatah_ibu)" |bc`
	jatah_laki=`echo "scale=2;$sisa/$lakilaki" |bc`
	zenity --info --text "Istri mendapatkan $jatah_istrifix, Suami mendapatkan $jatah_suami Ayah mendapatkan $jatah_ayah, Ibu mendapatkan $jatah_ibufix, anak laki laki mendapatkan $jatah_laki"
    elif [ "$suami" = 0 -a "$istri" = 0  ]
    then
   	jatah_ibu=`echo "scale=2;$uang/6" |bc`
   	jatah_ibu_fixed=`echo  "scale=2;$jatah_ibu/$ibu" |bc`
   	jatah_ayah=$jatah_ibu
   	anaklakikpl=`echo "scale=2;$lakilaki*2" |bc`
   	anakprpkpl=$perempuan
   	jatahanak=`echo "scale=2;$uang-$jatah_ayah-$jatah_ibu" |bc`
   	jatah_anak=`echo "scale=2;$jatahanak/($anaklakikpl+$anakprpkpl)" |bc`
   	jatahlaki_fixed=`echo "scale=2;$jatah_anak*2" |bc`
   	jatahprp_fixed=$jatah_anak
   	zenity --info --text "Ayah mendapatkan $jatah_ayah, ibu mendapatkan $jatah_ibu, Anak laki2 mendapatkan $jatahlaki_fixed"
    fi
elif [ "$perempuan" -gt 0 -a "$lakilaki" = 0 -a "$ayah" -gt 0 -a "$ibu" -gt 0 ]
  then
   if [ "$suami" -gt 0 -a "$istri" = 0  ]
   then
	jatah_suami=`echo "scale=2;$uang/4" |bc`
 	jatah_ayah=`echo "scale=2;$uang/6" |bc`
	jatah_ibu=`echo "scale=2;$uang/6" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
 	sisa=`echo "scale=2;$uang-($jatah_suami+$jatah_ayah+$jatah_ibu)" |bc`
	if [ "$perempuan" = 1 ]
   	then
   	jatah_anak=`echo "scale=2;$sisa/2" |bc`
   	elif [ "$perempuan" -gt 1 ]
   	then
   	jatah_anak=`echo "scale=2;2/3*$sisa/$perempuan |bc`
   	fi
	zenity --info --text "Suami mendapatkan $jatah_suami Ayah mendapatkan $jatah_ayah, Ibu mendapatkan $jatah_ibufix, anak Perempuan mendapatkan $jatah_anak"
   elif [ "$suami" = 0 -a "$istri" -gt 0  ]
   then
  	jatah_istri=`echo "scale=2;$uang/8" |bc`
	jatah_istrifix=`echo "scale=2;$jatah_istri/$istri" |bc`
 	jatah_ayah=`echo "scale=2;$uang/6" |bc`
	jatah_ibu=`echo "scale=2;$uang/6" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
 	sisa=`echo "scale=2;$uang-($jatah_istri+$jatah_ayah+$jatah_ibu)" |bc`
	if [ "$perempuan" = 1 ]
   	then
   	jatah_anak=`echo "scale=2;$sisa/2" |bc`
   	elif [ "$perempuan" -gt 1 ]
   	then
   	jatah_anak=`echo "scale=2;2/3*$sisa/$perempuan" |bc`
   	fi
	zenity --info --text "Istri mendapatkan $jatah_istrifix,  Ayah mendapatkan $jatah_ayah, Ibu mendapatkan $jatah_ibufix, anak perempuan mendapatkan $jatah_anak"
   elif [ "$suami" -gt 0 -a "$istri" -gt 0  ]
   then
	jatah_suami=`echo "scale=2;$uang/4" |bc`
  	jatah_istri=`echo "scale=2;$uang/8" |bc`
	jatah_istrifix=`echo "scale=2;$jatah_istri/$istri" |bc`
 	jatah_ayah=`echo "scale=2;$uang/6" |bc`
	jatah_ibu=`echo "scale=2;$uang/6" |bc`
	jatah_ibufix=`echo "scale=2;$jatah_ibu/$ibu" |bc`
 	sisa=`echo "scale=2;$uang-($jatah_suami+$jatah_istri+$jatah_ayah+$jatah_ibu)" |bc`
	if [ "$perempuan" = 1 ]
   	then
   	jatah_anak=`echo "scale=2;$sisa/2" |bc`
   	elif [ "$perempuan" -gt 1 ]
   	then
   	jatah_anak=`echo "scale=2;2/3*$sisa/$perempuan" |bc`
   	fi
	zenity --info --text "Istri mendapatkan $jatah_istrifix, Suami mendapatkan $jatah_suami Ayah mendapatkan $jatah_ayah, Ibu mendapatkan $jatah_ibufix, anak perempuan mendapatkan $jatah_anak"
   elif [ "$suami" = 0 -a "$istri" = 0  ]
   then
   	jatah_ibu=`echo "scale=2;$uang/6" |bc`
   	jatah_ibu_fixed=`echo  "scale=2;$jatah_ibu/$ibu" |bc`
   	jatah_ayah=$jatah_ibu
   	anakprpkpl=$perempuan
   	jatahanak=`echo "scale=2;$uang-$jatah_ayah-$jatah_ibu" |bc`
   	if [ "$perempuan" = 1 ]
   	then
   	jatah_anak=`echo "scale=2;$jatahanak/2" |bc`
   	elif [ "$perempuan" -gt 1 ]
   	then
   	jatah_anak=`echo "scale=2;2/3*$jatahanak/$anakprpkpl" |bc`
   	fi
   	echo $jatahanak
   	echo $jatah_anak
   	zenity --info --text "Ayah mendapatkan $jatah_ayah, ibu mendapatkan $jatah_ibu, anak perempuan mendapatkan     $jatah_anak"
   fi

fi
main;
}

main(){
login=`zenity --list --height 234 --width 280 --title "PROGRAM FAROID" --text "\t\t\t\  Pilih Menu" --column "Menu" "Perhitungan Faroid" "Penjelasan Faroid" "Database Harta" "Keluar"`

if [ "$login" == "Database Harta" ]
  then
   database;
elif [ "$login" == "Penjelasan Faroid" ]
  then
   dalil;
elif [ "$login" == "Perhitungan Faroid" ]
  then
   hitung;
elif [ "$login" == "Keluar" ]
  then
   exit
fi
}

main
