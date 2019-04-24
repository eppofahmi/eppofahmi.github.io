# Proses Ekstraksi Informasi

Pada bagian ini kita akan mempelajari bagaimana cara untuk mengekstrak informasi dari teks sosial media, terutama Twitter. Ada empat langkah utama dalam tahap ini, yaitu: impor/ekspor data, preprocessing, eksplorasi, dan visualisasi. Kita akan membahas secara singkat masing-masing langkah.

[//]: <> (```{r proses1, echo = FALSE, out.width = '100%', fig.cap = "RStudio Interface terdiri empat bagian utama."}
knitr::include_graphics("images/data-science.png")```)

## Impor dan Ekspor Data

Pada pengolahan data menggunakan R, direkomendasikan menggunakan tipe data file CSV (`Comma Separated Value`). Secara sederhana, file CSV merupakan file tabel yang serupa dengan XLS namun dengan variasi delimiter atau pemisah nilai. File CSV dapat diolah sebagaimana XLS dalam aplikasi Microsoft Excel. 

### Membaca data (Import)
Untuk membaca file CSV dalam lingkungan R, ada banyak cara yang bisa dilakukan. Cara pertama yaitu dengan menggunakan fungsi yang sudah tersedia pada R, yaitu `read.csv()` dengan contoh perintah sebagai berikut


```r
df <- read.csv(nama_file_csv)
```

Cara tersebut dapat digunakan untuk membaca CSV berukuran kecil. Sedangkan bila kita ingin membaca file CSV berukuran relatif besar, direkomendasikan menggunakan library `readr` seperti yang sudah disinggung pada bab sebelumnya. Penggunaan library ini memungkinkan file dibaca jauh lebih cepat dibandingkan metode sebelumnya. Perintah yang digunakan adalah


```r
df <- readr::read_csv(nama_file_csv)
```

Hasil pembacaan yang disimpan dalam `df` merupakan sebuah data tabel.

### Menyimpan data (Ekspor)

Kita dapat menggunakan fungsi dari `readr` yaitu `write_csv()` untuk menyimpan data tabel ke dalam file CSV. Perintah yang digunakan adalah sebagai berikut:


```r
readr::write_csv(nama_file_csv)
```

### Menampilkan data
Untuk menampilkan data, disediakan perintah `print()`. Contoh penggunaannya sebagai berikut:


```r
print(df)
```

Perintah di atas akan menampilkan isi dari `df`. Namun jika jumlah barisnya banyak, maka data hanya akan ditampilkan beberapa saja. Untuk menampilkan kolom tertentu dalam suatu data tabel, kita perlu menambahkan `$<namakolom>` seperti contoh berikut:


```r
print(df$text)
```
Perintah tersebut akan menampilkan kolom `text` pada data tabel `df`.

## Pre-processing
Preprocessing merupakan sebuah langkah yang perlu dilakukan sebelum data siap untuk diproses atau dianalisis. Ada banyak jenis langkah preprocessing yang dapat dilakukan, namun langkah ini harus disesuaikan dengan data yang kita miliki. Pada kesempatan ini, kita akan melakukan preprocessing untuk teks yang berasal dari media sosial. 

### Menghapus karakter non-ASCII
Karakter teks yang digunakan di Indonesia menggunakan standar [ASCII](https://en.wikipedia.org/wiki/ASCII), namun pada banyak negara terdapat karakter-karakter yang tidak terdapat dalam standar ASCII. Pada kasus tersebut, digunakan standar yang lain, yaitu [Unicode](https://en.wikipedia.org/wiki/Unicode) yang memiliki variasi karakter lebih banyak. ASCII pada dasarnya adalah bagian dari Unicode. Pada teks sosial media, seringkali karakter non-ASCII tertulis dan itu cukup membuat sulit dalam pengolahan teks, karena kita menggunakan ASCII. Oleh karena itu, pada langkah pertama preprocessing, kita harus menghapus karakter non-ASCII tersebut.

Ciri karakter non-ASCII yang terlihat adalah adanya format seperti `<U+...>` pada teks yang kita miliki. Untuk menghapusnya, kita akan menggunakan perintah `global substitution` sebagai berikut:


```r
text <- gsub("[<].*[>]", "", text)
```
Perintah di atas bermakna mengganti semua teks dengan format `<..>` dalam variabel `text` dengan kosong, atau dengan kata lain, menghapusnya kemudian menyimpannya kembali ke dalam variabel `text`. Ini salah satu strategi dalam menghilangkan karakter non-ASCII

### Menghapus alamat URL
Sering kita temui pada teks sosial media, alamat URL sebuah website atau sejenisnya. Tentu kita tidak memerlukan alamat URL ini pada analisis selanjutnya. Untuk menghapusnya, bisa digunakan perintah:


```r
text <- gsub('http\\S+\\s*',"", text)
```

Dengan menggunakan perintah tersebut, semua teks dengan format `http...` (format alamat URL) akan dihapus. 
### Menghapus tanda baca
Tanda baca menjadi hal selanjutnya yang akan kita hapus untuk mendapatkan teks yang siap untuk dianalisis. Metode yang bisa digunakan adalah dengan memanfaatkan perintah `gsub` sama seperti sebelumnya dengan pola yang berbeda.


```r
text <- gsub("[^[:alnum:][:space:]#@]", "", text)
```

Penjelasan mengenai perintah tersebut
* Tanda `[^ ]` bermakna ambil selain pola yang ada di dalam kurung siku
* Teks `[:alnum:]` bermakna semua huruf dan angka (alfanumerik)
* Teks `[:space:]` bermakna spasi
* Karakter `#@` bermakna literal
Sehingga perintah itu secara umum bermakna menghapus semua karakter selain huruf, angka, spasi, `#` dan `@`. Dua yang terakhir sengaja tidak kita hapus karena akan digunakan untuk analisis akun dan tagar pada tahap selanjutnya.

### Menghapus tanda ganti baris

Pada teks sosial media maupun teks pada umumnya, kita akan sering menjumpai karakter `\n` yang merupakan karakter pindah baris (ada ketika kita menekan `enter` pada keyboard). Karakter ini normalnya tidak akan terlihat, namun ketika kita ambil teks dalam format ASCII, karakter ini akan diterjemahkan menjadi `\n`. Untuk menghapusnya, kita dapat menggunakan perintah berikut:


```r
text <- gsub("\n"," ",text)
```

Jika diperlukan kita bisa menggunakan cara yang sama untuk menghapus karakter sejenis lain, misalnya `\t` yang berarti `tab`. Namun karakter tersebut sangat jarang ada di sosial media twitter.

### Mengubah ke huruf kecil

Menyeragamkan huruf kapital menjadi hal yang sangat penting dalam pengolahan teks. Hal ini dikarenakan komputer akan menganggap `teks` berbeda dari `Teks`. Oleh sebab itu, dengan perintah bawaan R, `tolower()`, kita akan membuat semua karakter ke dalam huruf kecil.


```r
text <- tolower(text)
```

## Eksplorasi {#explorasi1}

Pada eksplorasi ini, kita akan mencoba mencari tahu tentang akun paling banyak disebut, tagar paling sering digunakan, serta kata yang paling sering ditulis. Namun sebelumnya satu langkah yang harus dilakukan adalah proses tokenisasi.

### Tokenisasi

Tokenisasi pada dasarnya adalah proses membagi teks yang berupa kalimat atau paragraf menjadi bagian-bagian tertentu. Dalam konteks ini, kita akan membagi kumpulan kalimat ke dalam kumpulan kata-kata. Untuk melakukan tokenisasi, kita bisa menggunakan metode dari library `tidytext` yaitu `unnest_tokens()`. Contoh perintahnya adalah sebagai berikut:


```r
df_new <- tidytext::unnest_tokens(df,word,text,token='regex',pattern="[:space:]")
```
Penjelasan dari kode tersebut adalah sebagai berikut:

* `df_new` merupakan data frame tempat menyimpan hasil tokenisasi
* `tidytext::unnest_tokens` perintah untuk memanfaatkan fungsi `unnest_tokens` yang berasal dari library `tidytext`
* `df` adalah data frame awal yang belum diproses
* `word` adalah nama kolom yang kita buat untuk menampung hasil dari tokenisasi
* `text` adalah nama kolom dari data frame `df` dimana berisi teks yang akan ditokenisasi
* `token='regex'` berarti kita menggunakan metode tokenisasi dengan memanfaatkan pola [regex](https://en.wikipedia.org/wiki/Regular_expression). Regex merupakan sebuah pola karakter yang lazim digunakan untuk pencarian teks tertentu.
* `pattern="[:space:]"` berarti bahwa pola regex yang akan kita gunakan adalah spasi. Perintah ini juga bermakna bahwa teks akan kita pisah-pisah berdasarkan spasi, sehingga akan menghasilkan kata-kata.

Hasil dari perintah di atas adalah sebuah data frame `df_new` dengan satu kolom bernama `word` yang berisi satu kata per baris. Contohnya dapat dilihat pada Tabel \@ref(tab:table1). 


Table: (\#tab:table1)Hasil tokenisasi

|word   |
|:------|
|saya   |
|mereka |
|makan  |

### Akun paling banyak disebut
Untuk mencari siapa akun-akun yang paling banyak disebut dalam menulis twit, pada dasarnya kita cukup melakukan filter dari data frame hasil tokenisasi sebelumnya, kemudian menghitung frekuensi munculnya tiap akun. Pada langkah ini, kita akan menggunakan bantuan fungsi `filter()` dari library `dplyr` dan fungsi `str_detect()` dari library `stringr`. Contoh penggunaannya dapat dilihat pada perintah berikut:


```r
df_akun <- dplyr::filter(df_new,stringr::str_detect(word, "@"))
```

* `dplyr::filter()` merupakan fungsi yang digunakan untuk melakukan filtering pada data frame sesuai dengan kondisi tertentu
* `stringr::str_detect()` digunakan untuk mencari baris tertentu pada suatu kolom yang memiliki pola tertentu

Perintah di atas bermakna kita hanya akan mengambil baris-baris pada data frame `df_new` kolom `word` yang mengandung karakter `@`, dengan kata lain berupa akun, kemudian hasilnya disimpan pada `df_akun`.

Setelah semua akun terambil, kita dapat menghitung frekuensi masing-masing dengan mengubah data frame `df_akun` ke dalam format tabel. Secara otomatis R akan menghitung frekuensi dari masing-masing baris yang sama. Kemudian kita ubah `df_akun` kembali ke data frame untuk bisa ditampilkan dan diolah lebih lanjut.


```r
df_akun <- table(df_akun)
df_akun <- as.data.frame(df_akun)
```

Selanjutnya untuk mengurutkan data berdasar frekuensi, kita dapat menggunakan fungsi `arrange()` dari library `dplyr` sebagai berikut.


```r
df_akun <- dplyr::arrange(df_akun,desc(Freq))
```

Kode di atas akan menghasilkan data frame `df_akun` yang berisi daftar akun dan frekuensinya yang telah diurutkan secara descending.

### Tagar paling sering digunakan

Untuk mencari frekuensi tagar yang digunakan, kita dapat menggunakan cara yang mirip dengan langkah mencari akun di atas. Hanya saja untuk filter yang digunakan, karakter `@` diganti dengan `#` seperti berikut.


```r
df_tagar <- dplyr::filter(df_new,stringr::str_detect(word, "#"))
```

Langkah selanjutnya sama dengan sebelumnya.

### Kata paling sering ditulis
Untuk mencari frekuensi kata selain nama akun dan tagar, kita butuh mengubah pola pencarian yang digunakan. Contoh yang bisa digunakan adalah sebagai berikut.


```r
df_kata <- dplyr::filter(df_new,stringr::str_detect(word, "^((?!@|#).)*$"))
```

Perintah di atas akan mencari kata selain yang berawalan `@` dan `#` dalam data frame `df_new` kemudian menyimpannya ke dalam data frame `df_kata`.

## Visualisasi

Untuk visualisasi dari data yang sudah didapat, kita dapat menggunakan bar chart. Implementasi bar chart dalam R didapat dengan memanfaatkan library `ggplot` dengan contoh kode sebagai berikut:


```r
ggplot(head(df_akun,n=10),aes(x=reorder(col_akun,Freq),y=Freq)) + 
  geom_col() + 
  coord_flip() +
  labs(title='10 akun paling banyak disebut',x='nama akun',y='jumlah')
```

* `head(df_akun,n=10)` maksudnya ialah mengambil 10 baris pertama dari data frame `df_akun`
* `aes()` merupakan perintah untuk mendeskripsikan variabel mana yang akan ditampilkan dalam sumbu grafik. Perintah `reorder(col_akun,Freq)` bermakna data pada kolom `col_akun` akan diurutkan berdasarkan kolom `Freq`
* `geom_col()` merupakan perintah yang bermakna grafik yang kita buat merupakan bar chart
* `coord_flip()` merupakan perintah untuk menukar sumbu pada grafik. Pada kasus ini, kita menggunakan perintah ini untuk membuat horizontal bar chart
* `labs()` digunakan untuk memberi label


